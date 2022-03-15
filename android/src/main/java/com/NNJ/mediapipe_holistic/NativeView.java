package com.NNJ.mediapipe_holistic;

import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.SurfaceTexture;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.util.Size;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

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

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;

public class NativeView implements PlatformView, MethodChannel.MethodCallHandler {
    private static final String NAMESPACE = "mediapipe_holistic";
    private static final String TAG = "Change later";

    @NonNull
    private  final SurfaceView previewDisplayView;
    private final BinaryMessenger messenger;
    private final MethodChannel channel;

    // {@link SurfaceTexture} where the camera-preview frames can be accessed.
    private SurfaceTexture previewFrameTexture = null;
    private CameraXPreviewHelper cameraHelper;
    private static CameraHelper.CameraFacing CAMERA_FACING = CameraHelper.CameraFacing.FRONT;

    private final static String BINARY_GRAPH_NAME = "holistic_tracking_gpu.binarypb";
    private final static String INPUT_VIDEO_STREAM_NAME = "input_video";
    private final static String OUTPUT_VIDEO_STREAM_NAME = "output_video";
//    private final static String OUTPUT_HOLISTIC_PRESENCE_STREAM_NAME = "holistic_presence";
//    private final static String OUTPUT_LANDMARKS_STREAM_NAME = "holistic_landmarks";
    private final static String POSE_LANDMARKS = "pose_landmarks";
    private final static String LEFT_HAND_LANDMARKS="left_hand_landmarks";
    private final static String RIGHT_HAND_LANDMARKS="right_hand_landmarks";
    private final static String FACE_LANDMARKS="face_landmarks";

    static {
        // Load all native libraries needed by the app.
        System.loadLibrary("mediapipe_jni");
        try {
            System.loadLibrary("opencv_java3");
        } catch (java.lang.UnsatisfiedLinkError e) {
            // Some example apps (e.g. template matching) require OpenCV 4.
            System.loadLibrary("opencv_java4");
        }
    }

    // Creates and manages an {@link EGLContext}.
    private EglManager eglManager;
    private FrameProcessor processor;
    // Converts the GL_TEXTURE_EXTERNAL_OES texture from Android camera into a regular texture to be
    // consumed by {@link FrameProcessor} and the underlying MediaPipe graph.
    private ExternalTextureConverter converter;
    // Flips the camera-preview frames vertically before sending them into FrameProcessor to be
    // processed in a MediaPipe graph, and flips the processed frames back when they are displayed.
    // This is needed because OpenGL represents images assuming the image origin is at the bottom-left
    // corner, whereas MediaPipe in general assumes the image origin is at top-left.
    private final boolean FLIP_FRAMES_VERTICALLY = true;


    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink = null;

    public NativeView(@NonNull Context context, @NonNull BinaryMessenger messenger, int id, @Nullable Map<String, Object> creationParams) {
        channel = new MethodChannel(messenger, String.format("%s/%d", NAMESPACE,id));
        channel.setMethodCallHandler(this);

        eventChannel = new EventChannel(messenger, String.format("%s/%d/landmarks",NAMESPACE, id));
        eventChannel.setStreamHandler(landmarksStreamHandler());

        this.previewDisplayView = new SurfaceView(context);
        this.messenger = messenger;
        if (Shared.binding != null){
            Shared.binding.addRequestPermissionsResultListener(CameraRequestPermissionsListener());
        }
        // Initialize asset manager so that MediaPipe native libraries can access the app assets, e.g.,
        // binary graphs.
        setupPreviewDisplayView();
        AndroidAssetUtil.initializeNativeAssetManager(Shared.activity);

        eglManager = new EglManager(null);
        processor = new FrameProcessor(
                Shared.activity,
                eglManager.getNativeContext(),
                BINARY_GRAPH_NAME,
                INPUT_VIDEO_STREAM_NAME,
                OUTPUT_VIDEO_STREAM_NAME
        );

        setupProcess();
        PermissionHelper.checkAndRequestCameraPermissions(Shared.activity);
        if(PermissionHelper.cameraPermissionsGranted(Shared.activity)) onResume();

    }

    private void setupPreviewDisplayView() {
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
                Log.e(TAG, "Listen event channel");
            }

            @Override
            public void onCancel(Object arguments) {
                eventSink = null;
            }
        };
    }

    private void setupProcess() {
        processor.getVideoSurfaceOutput().setFlipY(FLIP_FRAMES_VERTICALLY);
        processor.addPacketCallback(
                LEFT_HAND_LANDMARKS,
                packet -> {
                    byte[] landmarksRaw = PacketGetter.getProtoBytes(packet);
                    if(eventSink==null){
                        try{
                            LandmarkProto.NormalizedLandmarkList landmarks = LandmarkProto.NormalizedLandmarkList.parseFrom(landmarksRaw);
                            if (landmarks == null){
                                Log.d(TAG,"[TS:" + packet.getTimestamp() + "] No left hand landmarks.");
                                return;
                            }
                            // Note: If holistic presence is false, these landmarks are useless
                            Log.d(TAG, "[TS: " + packet.getTimestamp()+"] #Landmarks for left hand: " + landmarks.getLandmarkCount() +"\n "+  getLandmarksString(landmarks));
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
        processor.addPacketCallback(
                RIGHT_HAND_LANDMARKS,
                packet -> {
                    byte[] landmarksRaw = PacketGetter.getProtoBytes(packet);
                    if(eventSink==null){
                        try{
                            LandmarkProto.NormalizedLandmarkList landmarks = LandmarkProto.NormalizedLandmarkList.parseFrom(landmarksRaw);
                            if (landmarks == null){
                                Log.d(TAG,"[TS:" + packet.getTimestamp() + "] No right hand landmarks.");
                                return;
                            }
                            // Note: If holistic presence is false, these landmarks are useless
                            Log.d(TAG, "[TS: " + packet.getTimestamp()+"] #Landmarks for right hand: " + landmarks.getLandmarkCount() +"\n "+  getLandmarksString(landmarks));
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
        processor.addPacketCallback(
                POSE_LANDMARKS,
                packet -> {
                    byte[] landmarksRaw = PacketGetter.getProtoBytes(packet);
                    if(eventSink==null){
                        try{
                            LandmarkProto.NormalizedLandmarkList landmarks = LandmarkProto.NormalizedLandmarkList.parseFrom(landmarksRaw);
                            if (landmarks == null){
                                Log.d(TAG,"[TS:" + packet.getTimestamp() + "] No pose hand landmarks.");
                                return;
                            }
                            // Note: If holistic presence is false, these landmarks are useless
                            Log.d(TAG, "[TS: " + packet.getTimestamp()+"] #Landmarks for pose hand: " + landmarks.getLandmarkCount() +"\n "+  getLandmarksString(landmarks));
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
        processor.addPacketCallback(
                FACE_LANDMARKS,
                packet -> {
                    byte[] landmarksRaw = PacketGetter.getProtoBytes(packet);
                    if(eventSink==null){
                        try{
                            LandmarkProto.NormalizedLandmarkList landmarks = LandmarkProto.NormalizedLandmarkList.parseFrom(landmarksRaw);
                            if (landmarks == null){
                                Log.d(TAG,"[TS:" + packet.getTimestamp() + "] No face hand landmarks.");
                                return;
                            }
                            // Note: If holistic presence is false, these landmarks are useless
                            Log.d(TAG, "[TS: " + packet.getTimestamp()+"] #Landmarks for face hand: " + landmarks.getLandmarkCount() +"\n "+  getLandmarksString(landmarks));
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

//    private String getLeftHandLandmarksDebugString(List<LandmarkProto.NormalizedLandmarkList> leftHandLandmarks){
//        if (leftHandLandmarks.isEmpty()){
//            return  "No left hand landmarks";
//        }
//        String leftHandLandmarksStr = "Number of hand detected: " + leftHandLandmarks.size() + "\n";
//        int handIndex = 0;
//        for (LandmarkProto.NormalizedLandmarkList landmarks : leftHandLandmarks) {
//            leftHandLandmarksStr +=
//                    "\t#Hand landmarks for hand[" + handIndex + "]: " + landmarks.getLandmarkCount() + "\n";
//            int landmarkIndex = 0;
//            for (LandmarkProto.NormalizedLandmark landmark : landmarks.getLandmarkList()) {
//                leftHandLandmarksStr +=
//                        "\t\tLandmark ["
//                                + landmarkIndex
//                                + "]: ("
//                                + landmark.getX()
//                                + ", "
//                                + landmark.getY()
//                                + ", "
//                                + landmark.getZ()
//                                + ")\n";
//                ++landmarkIndex;
//            }
//            ++handIndex;
//        }
//        return leftHandLandmarksStr;
//    }

    private PluginRegistry.RequestPermissionsResultListener CameraRequestPermissionsListener() {
        return (requestCode, permissions, grantResults) -> {
            if(requestCode != 0){
                return false;
            } else{
                for (int result:grantResults){
                    if(result == PackageManager.PERMISSION_GRANTED) onResume();
                    else Toast.makeText(Shared.activity, "Please allow permission for camera", Toast.LENGTH_LONG).show();
                }
                return true;
            }
        };
    }

    private void onResume() {
        converter = new ExternalTextureConverter(eglManager.getContext());
        converter.setFlipY(FLIP_FRAMES_VERTICALLY);
        converter.setConsumer(processor);
        if(PermissionHelper.cameraPermissionsGranted(Shared.activity)) startCamera();
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
        cameraHelper.startCamera(Shared.activity,CAMERA_FACING, null);
    }


    @Override
    public View getView() {
        return previewDisplayView;
    }

    @Override
    public void dispose() {
        converter.close();
        previewDisplayView.setVisibility(View.GONE);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
            result.notImplemented();
        }
    }
}

