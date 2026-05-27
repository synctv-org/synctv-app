plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

fun flutterDartDefine(name: String): String? {
    val encoded = providers.gradleProperty("dart-defines").orNull ?: return null
    return encoded
        .split(',')
        .asSequence()
        .mapNotNull { value ->
            runCatching {
                String(java.util.Base64.getDecoder().decode(value))
            }.getOrNull()
        }
        .firstOrNull { value -> value.startsWith("$name=") }
        ?.substringAfter('=')
        ?.takeIf { value -> value.isNotBlank() }
}

fun oauth2AppLinkHost(): String {
    providers.gradleProperty("syncTvOauth2AppLinkHost").orNull?.let { value ->
        if (value.isNotBlank()) return validateOauth2AppLinkHost(value)
    }
    flutterDartDefine("SYNC_TV_OAUTH2_APP_LINK_ORIGIN")?.let { value ->
        val uri = java.net.URI(value)
        if (
            uri.scheme != "https" ||
            uri.host.isNullOrBlank() ||
            uri.port != -1 ||
            !uri.query.isNullOrBlank() ||
            !uri.fragment.isNullOrBlank()
        ) {
            throw GradleException(
                "SYNC_TV_OAUTH2_APP_LINK_ORIGIN must be an https origin without port, query, or fragment"
            )
        }
        return uri.host
    }
    return "oauth.invalid"
}

fun validateOauth2AppLinkHost(host: String): String {
    val value = host.trim()
    if (
        value.isBlank() ||
        value.any { it.isWhitespace() } ||
        value.contains(":") ||
        value.contains("/") ||
        value.contains("?") ||
        value.contains("#")
    ) {
        throw GradleException("syncTvOauth2AppLinkHost must be a host name without port, scheme, or path")
    }
    return value
}

android {
    namespace = "com.sync.app"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.sync.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["oauth2AppLinkHost"] = oauth2AppLinkHost()
    }

    buildTypes {
        release {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
