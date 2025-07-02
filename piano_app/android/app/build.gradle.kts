import java.util.Properties  // Add this import statement at the top

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.piano_app"
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
        applicationId = "com.example.piano_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keyProperties = rootProject.file("android/key.properties")

            // Ensure the key.properties file exists and load the values from it
            if (keyProperties.exists()) {
                val properties = Properties() // Now this works after importing Properties
                properties.load(keyProperties.inputStream())

                storeFile = file(properties["storeFile"] as String)
                storePassword = properties["storePassword"] as String
                keyAlias = properties["keyAlias"] as String
                keyPassword = properties["keyPassword"] as String
            } else {
                throw GradleException("Key properties file not found!")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // ProGuard settings for release build
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
