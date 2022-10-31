# FFmpeg_android
Use FFmpeg in Android, including ffmpeg compile to .so files, system integration and so on.

FFmpeg 5.1.2 compilation

1. Required environment: MacOS or linux

2. Required files: FFmpeg source package https://ffmpeg.org/

3. The installation location of NDK, you can download it, or find it in the sdk directory of android studio (if it was installed).

```
#!/bin/bash
make clean
set -e
archbit=64

if [ $archbit -eq 64 ];then
echo "build for 64bit"
ARCH=aarch64
CPU=armv8-a
API=21
PLATFORM=aarch64
ANDROID=android
CFLAGS=""
LDFLAGS=""

else
echo "build for 32bit"
ARCH=arm
CPU=armv7-a
API=16
PLATFORM=armv7a
ANDROID=androideabi
CFLAGS="-mfloat-abi=softfp -march=$CPU"
LDFLAGS="-Wl,--fix-cortex-a8"
fi

export NDK=/Users/yangxinbao/Library/Android/sdk/ndk/21.1.6352462
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/bin
export SYSROOT=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
export CROSS_PREFIX=$TOOLCHAIN/$ARCH-linux-$ANDROID-
export CC=$TOOLCHAIN/$PLATFORM-linux-$ANDROID$API-clang
export CXX=$TOOLCHAIN/$PLATFORM-linux-$ANDROID$API-clang++
export PREFIX=./android/$CPU

function build_android {
    ./configure \
    --prefix=$PREFIX \
    --cross-prefix=$CROSS_PREFIX \
    --target-os=android \
    --arch=$ARCH \
    --cpu=$CPU \
    --cc=$CC \
    --cxx=$CXX \
    --nm=$TOOLCHAIN/$ARCH-linux-$ANDROID-nm \
    --strip=$TOOLCHAIN/$ARCH-linux-$ANDROID-strip \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="$CFLAGS" \
    --extra-ldflags="$LDFLAGS" \
    --extra-ldexeflags=-pie \
    --enable-runtime-cpudetect \
    --disable-static \
    --enable-shared \
    --disable-ffprobe \
    --disable-ffplay \
    --disable-ffmpeg \
    --disable-debug \
    --disable-doc \
    --enable-avfilter \
    --enable-decoders \
    $ADDITIONAL_CONFIGURE_FLAG

    make -j4
    make install
}
build_android
```

Create the build_android.sh file in the source package and paste the above configuration information.

cd to the source package directory, run the following command


```
$ chmod +x build_android.sh
```
```
$ ./build_android.sh
```

<b>archbit=64</b> means that the library is compiled to support the cpu architecture arm64-v8a. If it is changed to a different value, such as archbit=32, it will be compiled to support armeabi-v7a.

<b>Export the NDK = / Users/yangxinbao/Library/Android/SDK/the NDK / 21.1.6352462</b> modified into their own the NDK directory

<b>export PREFIX=./android/$CPU</b> indicates the location of the dynamic library (.so files) after successful compilation (android folder and its subdirectories in the current folder).

<b>Do not do complex operation, run first!</b>
