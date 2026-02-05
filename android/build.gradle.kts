allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    tasks.withType<JavaCompile>().configureEach {
        if (sourceCompatibility == "1.8" || sourceCompatibility == "8") {
            sourceCompatibility = "11"
        }
        if (targetCompatibility == "1.8" || targetCompatibility == "8") {
            targetCompatibility = "11"
        }
        options.compilerArgs.add("-Xlint:-options")
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
