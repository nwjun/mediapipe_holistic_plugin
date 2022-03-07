package com.NNJ.mediapipe_holistic;

import android.content.Context;
import android.view.SurfaceView;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

public class NativeView implements PlatformView {
    @NonNull
    private  final SurfaceView previewDisplayView;

    public NativeView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        this.previewDisplayView = new SurfaceView(context);
    }


    @Override
    public View getView() {
        return previewDisplayView;
    }

    @Override
    public void dispose() {

    }
}
