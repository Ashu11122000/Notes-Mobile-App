import org.gradle.api.file.Directory
import org.gradle.api.tasks.Delete

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Store all build outputs in a shared root build directory.
val rootBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()

rootProject.layout.buildDirectory.value(rootBuildDir)

subprojects {

    // Store each module's build output under the shared build directory.
    layout.buildDirectory.value(rootBuildDir.dir(name))

    // Ensure the app module is evaluated first when required.
    evaluationDependsOn(":app")
}

// Clean the shared build directory.
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}