plugins {

    id("com.android.application")

    id("kotlin-android")

    // FLUTTER
    id("dev.flutter.flutter-gradle-plugin")

    // FIREBASE
    id("com.google.gms.google-services")

}

android {

    namespace = "com.example.firstapp"

    compileSdk = flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion

    compileOptions {

        sourceCompatibility =
        JavaVersion.VERSION_17

        targetCompatibility =
        JavaVersion.VERSION_17

        // DESUGARING
        isCoreLibraryDesugaringEnabled = true

    }

    kotlinOptions {

        jvmTarget =
        JavaVersion.VERSION_17.toString()

    }

    defaultConfig {

        applicationId =
        "com.example.firstapp"

        minSdk =
        flutter.minSdkVersion

        targetSdk =
        flutter.targetSdkVersion

        versionCode =
        flutter.versionCode

        versionName =
        flutter.versionName

    }

    buildTypes {

        release {

            signingConfig =
            signingConfigs.getByName("debug")

        }

    }

}

flutter {

    source = "../.."

}

dependencies {

    coreLibraryDesugaring(

        "com.android.tools:desugar_jdk_libs:2.1.4"

    )

}