plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "uz.mcodevs.my_cast"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "uz.mcodevs.my_cast"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = Math.max(flutter.minSdkVersion, 21) // Chromecast requires API 21+
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Rename generated APKs to: my_cast_{version_name}_{version_code}.apk
androidComponents {
    onVariants(selector().all()) { variant ->
        variant.outputs.forEach { output ->
            if (output is com.android.build.api.variant.ApkVariantOutput) {
                val vName = variant.versionName?.get() ?: "0.0.0"
                val vCode = variant.versionCode?.get()?.toString() ?: "0"
                output.outputFileName.set("my_cast_${'$'}vName_${'$'}vCode.apk")
            }
        }
    }
}

dependencies {
    // Google Cast SDK
    implementation("com.google.android.gms:play-services-cast-framework:21.4.0")
    implementation("androidx.mediarouter:mediarouter:1.7.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
}
