import java.net.URI
import java.util.Base64
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

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
                String(Base64.getDecoder().decode(value))
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
        val uri = URI(value)
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

val releaseSigningValues = mapOf(
    "storeFile" to System.getenv("SYNCTV_ANDROID_KEYSTORE_PATH"),
    "storePassword" to System.getenv("SYNCTV_ANDROID_KEYSTORE_PASSWORD"),
    "keyAlias" to System.getenv("SYNCTV_ANDROID_KEY_ALIAS"),
    "keyPassword" to System.getenv("SYNCTV_ANDROID_KEY_PASSWORD"),
)
val configuredReleaseSigningValues = releaseSigningValues.filterValues { !it.isNullOrBlank() }
if (
    configuredReleaseSigningValues.isNotEmpty() &&
    configuredReleaseSigningValues.size != releaseSigningValues.size
) {
    throw GradleException(
        "Android release signing requires keystore path, store password, key alias, and key password"
    )
}
val releaseSigningConfigured =
    configuredReleaseSigningValues.size == releaseSigningValues.size

android {
    namespace = "org.synctv.app"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "org.synctv.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["oauth2AppLinkHost"] = oauth2AppLinkHost()
    }

    signingConfigs {
        if (releaseSigningConfigured) {
            create("release") {
                storeFile = file(releaseSigningValues.getValue("storeFile")!!)
                storePassword = releaseSigningValues.getValue("storePassword")
                keyAlias = releaseSigningValues.getValue("keyAlias")
                keyPassword = releaseSigningValues.getValue("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Local and fork builds remain installable and are labeled as development
            // artifacts by CI. Official releases inject a stable release keystore.
            signingConfig = signingConfigs.getByName(
                if (releaseSigningConfigured) "release" else "debug"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}
