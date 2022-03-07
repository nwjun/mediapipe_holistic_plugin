package com.NNJ.mediapipe_holistic;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class NativeViewFactory extends PlatformViewFactory {
    public NativeViewFactory(){
        super(StandardMessageCodec.INSTANCE);
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int viewId, @Nullable Object args) {
        final Map<String, Object> createParams = (Map<String, Object>) args;
        return new NativeView(context, viewId, createParams);
    }
}
