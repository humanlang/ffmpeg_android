#!/bin/bash
make clean
set -e
archbit=32

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