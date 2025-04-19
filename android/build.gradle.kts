buildscript {
//    ext.kotlin_version = "1.5.13"
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Update this line to use the latest or required Android Gradle plugin version
        classpath("com.android.tools.build:gradle:8.0.2") // Use the appropriate version here
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
