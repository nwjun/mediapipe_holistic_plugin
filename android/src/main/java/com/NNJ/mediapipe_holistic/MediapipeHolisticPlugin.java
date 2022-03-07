package com.NNJ.mediapipe_holistic;

import android.app.Activity;
import android.content.Context;
import android.graphics.SurfaceTexture;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.util.Size;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;

import androidx.annotation.NonNull;

import com.google.mediapipe.components.CameraHelper;
import com.google.mediapipe.components.CameraXPreviewHelper;
import com.google.mediapipe.components.ExternalTextureConverter;
import com.google.mediapipe.components.FrameProcessor;
import com.google.mediapipe.components.PermissionHelper;
import com.google.mediapipe.formats.proto.LandmarkProto;
import com.google.mediapipe.framework.AndroidAssetUtil;
import com.google.mediapipe.framework.PacketGetter;
import com.google.mediapipe.glutil.EglManager;
import com.google.protobuf.InvalidProtocolBufferException;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** MediapipeHolisticPlugin */
public class MediapipeHolisticPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private static String TAG = "Change later";
  private final String NAMESPACE = "mediapipe_holistic";
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Activity activity;
  private Context context;
  // {@link SurfaceTexture} where the camera-preview frames can be accessed.
  private SurfaceTexture previewFrameTexture = null;
  // {@link SurfaceView} that displays the camera-preview frames processed by a MediaPipe graph.
  private SurfaceView previewDisplayView;
  private CameraXPreviewHelper cameraHelper = null;
  private static CameraHelper.CameraFacing CAMERA_FACING = CameraHelper.CameraFacing.FRONT;

  private final static String BINARY_GRAPH_NAME = "holistic_tracking_gpu.binarypb";
  private final static String INPUT_VIDEO_STREAM_NAME = "input_video";
  private final static String OUTPUT_VIDEO_STREAM_NAME = "output_video";
  private final static String OUTPUT_HOLISTIC_PRESENCE_STREAM_NAME = "holistic_presence";
  private final static String OUTPUT_LANDMARKS_STREAM_NAME = "holistic_landmarks";

  // Creates and manages an {@link EGLContext}.
  private EglManager eglManager = new EglManager(null);
  private FrameProcessor processor;
  // Converts the GL_TEXTURE_EXTERNAL_OES texture from Android camera into a regular texture to be
  // consumed by {@link FrameProcessor} and the underlying MediaPipe graph.
  private ExternalTextureConverter converter = null;
  // Flips the camera-preview frames vertically before sending them into FrameProcessor to be
  // processed in a MediaPipe graph, and flips the processed frames back when they are displayed.
  // This is needed because OpenGL represents images assuming the image origin is at the bottom-left
  // corner, whereas MediaPipe in general assumes the image origin is at top-left.
  private final boolean FLIP_FRAMES_VERTICALLY = true;


  private EventChannel eventChannel;
  private EventChannel.EventSink eventSink = null;



  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "mediapipe_holistic");
    channel.setMethodCallHandler(this);

    eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), NAMESPACE+"/landmarks");
    eventChannel.setStreamHandler(landmarksStreamHandler());

    this.context = flutterPluginBinding.getApplicationContext();

    // Must be set only after context is assigned
    previewDisplayView = new SurfaceView(context);
    processor = new FrameProcessor(
            activity,
            eglManager.getNativeContext(),
            BINARY_GRAPH_NAME,
            INPUT_VIDEO_STREAM_NAME,
            OUTPUT_VIDEO_STREAM_NAME
    );

    System.loadLibrary("mediapipe_jni");
    System.loadLibrary("opencv_java3");

    flutterPluginBinding
            .getPlatformViewRegistry()
            .registerViewFactory(NAMESPACE+"/view", new NativeViewFactory());

    //   r.addRequestPermissionsResultListener(CameraRequestPermissionsListener());
    setupPreviewDisplayView();
    // Initialize asset manager so that MediaPipe native libraries can access the app assets, e.g.,
    // binary graphs.
    AndroidAssetUtil.initializeNativeAssetManager(activity);
    setupProcess();
    PermissionHelper.checkAndRequestCameraPermissions(activity);
    if(PermissionHelper.cameraPermissionsGranted(activity)) onResume();

  }

  private void setupProcess() {
    processor.getVideoSurfaceOutput().setFlipY(FLIP_FRAMES_VERTICALLY);
    processor.addPacketCallback(
            OUTPUT_HOLISTIC_PRESENCE_STREAM_NAME,
            (packet) -> {
              boolean holisticPresence = PacketGetter.getBool(packet);
              if(!holisticPresence) Log.d(TAG, "[TS:" + packet.getTimestamp() + "] Holistic presence is false, no holistic detected.");

            });
    processor.addPacketCallback(
            OUTPUT_HOLISTIC_PRESENCE_STREAM_NAME,
            packet -> {
              byte[] landmarksRaw = PacketGetter.getProtoBytes(packet);
              if(eventSink==null){
                try{
                  LandmarkProto.NormalizedLandmarkList landmarks = LandmarkProto.NormalizedLandmarkList.parseFrom(landmarksRaw);
                  if (landmarks == null){
                    Log.d(TAG,"[TS:" + packet.getTimestamp() + "] No hand landmarks.");
                    return;
                  }
                  // Note: If holistic presence is false, these landmarks are useless
                  Log.d(TAG, "[TS: " + packet.getTimestamp()+"] #Landmarks for holistic: " + landmarks.getLandmarkCount() +"\n "+  getLandmarksString(landmarks));
                } catch (InvalidProtocolBufferException e){
                  Log.e(TAG, "Couldn't Exception received - "+e);
                  return;
                }
              }else{
                new Handler(Looper.getMainLooper())
                        .post(() -> eventSink.success(landmarksRaw));
              }

            }
    );
  }

  private String getLandmarksString(@NonNull LandmarkProto.NormalizedLandmarkList landmarks) {
    String landmarksString = "";
    int landmarkIndex = 0;
    for (LandmarkProto.NormalizedLandmark landmark : landmarks.getLandmarkList()) {
      landmarksString +=  ("\t\tLandmark["
              + landmarkIndex
              + "]: ("
              + landmark.getX()
              + ", "
              + landmark.getY()
              + ", "
              + landmark.getZ()
              + ")\n");
      landmarkIndex ++;
    }
    return landmarksString;
  }

  private EventChannel.StreamHandler landmarksStreamHandler() {
    return new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
      }

      @Override
      public void onCancel(Object arguments) {
        eventSink = null;
      }
    };
  }

  private void onResume() {
    converter = new ExternalTextureConverter(eglManager.getContext());
    converter.setFlipY(FLIP_FRAMES_VERTICALLY);
    converter.setConsumer(processor);
    if(PermissionHelper.cameraPermissionsGranted(activity)) startCamera();
  }

  private void startCamera() {
    cameraHelper = new CameraXPreviewHelper();
    cameraHelper.setOnCameraStartedListener(
            surfaceTexture -> {
              previewFrameTexture = surfaceTexture;
              // Make the display view visible to start showing the preview. This triggers the
              // SurfaceHolder.Callback added to (the holder of) previewDisplayView.
              previewDisplayView.setVisibility(View.VISIBLE);
            }
    );
    cameraHelper.startCamera(activity,CAMERA_FACING, null);
  }

  private void setupPreviewDisplayView(){
    previewDisplayView.setVisibility(View.GONE);
    previewDisplayView.getHolder().addCallback(new SurfaceHolder.Callback() {
      @Override
      public void surfaceCreated(@NonNull SurfaceHolder surfaceHolder) {
        processor.getVideoSurfaceOutput().setSurface(surfaceHolder.getSurface());
      }

      @Override
      public void surfaceChanged(@NonNull SurfaceHolder surfaceHolder, int format, int width, int height) {
        // (Re-)Compute the ideal size of the camera-preview display (the area that the
        // camera-preview frames get rendered onto, potentially with scaling and rotation)
        // based on the size of the SurfaceView that contains the display.
        Size viewSize = new Size(width, height);
        Size displaySize = cameraHelper.computeDisplaySizeFromViewSize(viewSize);
        boolean isCameraRotated = cameraHelper.isCameraRotated();
        // Connect the converter to the camera-preview frames as its input (via
        // previewFrameTexture), and configure the output width and height as the computed
        // display size.
        converter.setSurfaceTextureAndAttachToGLContext(
                previewFrameTexture,
                isCameraRotated ? displaySize.getHeight() : displaySize.getWidth(),
                isCameraRotated ? displaySize.getWidth() : displaySize.getHeight()
        );

      }

      @Override
      public void surfaceDestroyed(@NonNull SurfaceHolder surfaceHolder) {
        processor.getVideoSurfaceOutput().setSurface(null);
      }
    });

  }
  
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {

  }
}
