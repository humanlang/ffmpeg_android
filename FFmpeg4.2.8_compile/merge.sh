#!/bin/bash
make clean
set -e
archbit=64

if [ $archbit -eq 64 ];then
echo "build for 64bit"
CPU=armv8-a
LIBTYPE=arch-arm64
PLATFORM=aarch64-linux-android
PLATFORM2=aarch64-linux-android

elif [ $archbit -eq 32 ];then
echo "build for 32bit"
CPU=armv7-a
LIBTYPE=arch-arm
PLATFORM=arm-linux-androideabi
PLATFORM2=arm-linux-androideabi

else
echo "build for x86_64"
CPU=x86_64
LIBTYPE=arch-x86_64
PLATFORM=x86_64-linux-android
PLATFORM2=x86_64
fi

export NDK=/Users/yangxinbao/Library/Android/sdk/ndk/21.1.6352462
export TOOLCHAIN=$NDK/toolchains/$PLATFORM2-4.9/prebuilt/darwin-x86_64
export PREFIX=./android_a/$CPU
export ALIBS=$NDK/platforms/android-21/$LIBTYPE

$TOOLCHAIN/bin/$PLATFORM-ld -rpath-link=$ALIBS/usr/lib -L$ALIBS/usr/lib -L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so $PREFIX/lib/libavfilter.a $PREFIX/lib/libswresample.a $PREFIX/lib/libavcodec.a $PREFIX/lib/libavformat.a $PREFIX/lib/libavutil.a $PREFIX/lib/libswscale.a -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker $TOOLCHAIN/lib/gcc/$PLATFORM/4.9.x/libgcc.a