package org.synctv.app

import android.app.PictureInPictureParams
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest

class MainActivity : FlutterActivity() {
    private lateinit var pictureInPictureChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        pictureInPictureChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "org.synctv.app/picture_in_picture",
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
                "exit" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && isInPictureInPictureMode) {
                        startActivity(
                            Intent(this, MainActivity::class.java).apply {
                                flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
                            },
                        )
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "org.synctv.app/passkey_identity",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAndroidIdentity" -> result.success(androidIdentity())
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

    @Suppress("DEPRECATION")
    private fun androidIdentity(): Map<String, Any> {
        val signatures = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            packageManager
                .getPackageInfo(packageName, PackageManager.GET_SIGNING_CERTIFICATES)
                .signingInfo
                ?.apkContentsSigners
                .orEmpty()
        } else {
            packageManager
                .getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
                .signatures
                .orEmpty()
        }
        val fingerprints = signatures.map { signature ->
            MessageDigest.getInstance("SHA-256")
                .digest(signature.toByteArray())
                .joinToString(":") { byte -> "%02X".format(byte) }
        }
        return mapOf(
            "packageName" to packageName,
            "certificateSha256" to fingerprints,
        )
    }
}
