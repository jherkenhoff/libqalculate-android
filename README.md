# libqalculate-android

Port of [liqalculate](https://github.com/Qalculate/libqalculate) to Android.

## Importing

The library can be found in [Maven Central](https://central.sonatype.com/artifact/com.jherkenhoff/libqalculate).
You can use library in your android project by declaring it as a dependency in your `build.gradle` file:
```implementation 'com.jherkenhoff:libqalculate:4.8.1-2'```

## Description
This is a port of libqalculate using some monkeypatching and SWIG to build it on Android.

It should implement all the features from `libqalculate`, and can easily sync with the latest version by modifying `CMakeLists.txt`.

## Compiling
The project can only be built under Linux (maybe MacOS too) but not on Windows as it relies on bash shell scripts. On Windows, you can use a virtual machine.

The following instructions were tested under Ubuntu 22.04 LTS in a VirtualBox v7 virtualized environment, using Android Studio 2022.3.1:

* Install Android Studio. Once it is installed, go into the SDK Manager, and install `NDK` in the Build Tools tab.
* `git clone` this repository: `git clone https://github.com/jherkenhoff/libqalculate-android`
* Install all the required toolchain libraries for compilation: `sudo apt-get install cmake swig m4 ninja-build g++ intltool`
    * Ensure CMake >= 3.22.1. If it is different from 3.22.1, then [specify the version you have installed in build.gradle](https://stackoverflow.com/questions/60718412/could-not-get-version-from-cmake-dir), so that `cmake` path can be found when compiling.
    * Troubleshooting: 
        * if you don't apt-get install m4, you will get [this error](https://stackoverflow.com/questions/11368989/no-usable-m4-in-path-or-usr5bin)!
        * if `/bin/ninja` is not present then you will get [this weird error](https://github.com/expo/expo/issues/22029) that is due to [ninja being in a different folder than cmake](https://issuetracker.google.com/issues/206099937), so ensure to apt-get install ninja-build.
        * if no g++, you get [this error](https://askubuntu.com/questions/509663/c-preprocessor-lib-cpp-fails-sanity-check).

<details>
    <summary>In case of SWIG Syntax Error</summary>

Normally the following issue is fixed, but it may creep back up in the future: When building, if you get a `SWIG error: Syntax Error in input(1)` in `includes.h`, this is because there are some lines of code using some syntax that are not accepted in the newest C99 standards, so they need to be modified. The error (and link) given in the Build console in Android Studio will point directly to the problematic functions (because once one is fixed, it will jump to the next one). The issue was fixed by updating to the latest `libqalculate` from v4.4.0 to v4.8.1, which likely implemented syntax fixes.

Note: Don't bother modifying `includes.h` with `#ifndef SWIG .... #endif` blocks as advised [here](https://stackoverflow.com/a/60166645/1121352) because `includes.h` is automatically generated from `libqalculate`, so instead try to fix the root cause by patching or updating to the latest `libqalculate`. The problematic functions were: `EvaluationOptions, SortOptions, PrintOptions, InternalPrintStruct, ParseOptions`
</details>

At this point, `libqalculate-android` should build just fine into an `.aar` library file that can be linked into any Android Kotlin project.

To get the app, you need to compile [qalculate-android](https://github.com/jherkenhoff/qalculate-android), just `git clone` it in a folder alongside `libqalculate-android` (both folders must be siblings), then try to build from `qalculate-android` using `./gradlew assembleDebug` or via Android Studio to get an `.apk` file. If any issue is encountered, Build > Rebuild Project (maybe after project clean in the same menu).
