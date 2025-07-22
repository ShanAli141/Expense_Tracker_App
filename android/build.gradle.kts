plugins {
    // Other plugins if any...
    id("com.google.gms.google-services") version "4.4.3" apply false
}

import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

allprojects {
    repositories {
        google()
        mavenCentral()
    }

    configurations.all {
        resolutionStrategy {
            // You can try either of these strategies:
            // Option 1: Force latest version
            force("com.google.firebase:firebase-iid:21.1.0")

            // Option 2: Exclude to avoid duplicates
            exclude("com.google.firebase", "firebase-iid")
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)

    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
