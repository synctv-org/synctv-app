package com.sync.app

import android.app.PictureInPictureParams
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var pictureInPictureChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        pictureInPictureChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.sync.app/picture_in_picture",
        )
        pictureInPictureChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isAvailable" -> result.success(isPictureInPictureAvailable())
                "enter" -> {
                    if (!isPictureInPictureAvailable()) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    val width = call.argument<Int>("width") ?: 16
                    val height = call.argument<Int>("height") ?: 9
                    val params = PictureInPictureParams.Builder()
                        .setAspectRatio(Rational(width.coerceAtLeast(1), height.coerceAtLeast(1)))
                        .build()
                    result.success(enterPictureInPictureMode(params))
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration,
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        if (::pictureInPictureChannel.isInitialized) {
            pictureInPictureChannel.invokeMethod(
                "onPictureInPictureChanged",
                isInPictureInPictureMode,
            )
        }
    }

    private fun isPictureInPictureAvailable(): Boolean =
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
}
