import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android Gradle plugin.
    id("dev.flutter.flutter-gradle-plugin")
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
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

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
