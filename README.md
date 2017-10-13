# Swift JNI Bridge

This is a small project for testing different approaches of communication between Java and Swift code.

There are 4 basic technics:
- Shared object - object created in Swift (or Java) with strong reference on another side (unbalanced retain for ARC and GlobalReference for JavaGC)
- JNI data copying
- JSON serialization
- Protocol buffer serialization

### How to compile

First, you need to compile proto files: 

1. Install protobuf compiler with brew

```brew install protobuf```

2. Compile and install [Swift Protobuf compiler plugin](https://github.com/apple/swift-protobuf#building-and-installing-the-code-generator-plugin)
3. Generate Java and Swift proto-classes:

```
protoc --java_out=./app/src/main/java/ DataModel.proto
protoc --swift_out=./app/src/main/swift/Sources DataModel.proto
```

Now import the project to Android Studio or build it with Gradle.

### XCode

You can generate Xcode project file with

```
cd ./app/src/main/swift
swift package generate-xcodeproj
```

This project wouldn't compile for macOS because of JNI library, but you can edit code there.

