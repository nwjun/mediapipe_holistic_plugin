package com.NNJ.mediapipe_holistic;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class NativeViewFactory extends PlatformViewFactory {
    final BinaryMessenger messenger;
    public NativeViewFactory(@NonNull BinaryMessenger binaryMessenger){
        super(StandardMessageCodec.INSTANCE);
        this.messenger = binaryMessenger;
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int viewId, @Nullable Object args) {
        final Map<String, Object> createParams = (Map<String, Object>) args;
        return new NativeView(context, messenger, viewId, createParams);
    }
}
