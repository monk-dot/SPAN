#!/bin/bash

CROSS_COMPILER=/home/dev/Desktop/PROJECTS/ANDROID_PLATFORM_GINGERBREAD/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-

KERNEL_PATH=/home/dev/Desktop/PROJECTS/ANDROID_KERNEL_GALAXYNEXUS/KERNEL/omap
ANYKERNEL_PATH=/home/dev/Desktop/PROJECTS/ANDROID_KERNEL_GALAXYNEXUS/ANYKERNEL

cd $KERNEL_PATH

echo "##################################################"
echo "clean"
echo "##################################################"
make distclean
rm -rf $ANYKERNEL_PATH/kernel/zImage
rm -rf $ANYKERNEL_PATH/system/modules/*
rm *.log
rm $KERNEL_PATH/arch/arm/boot/zImage


echo "##################################################"
echo "create defconfig"
echo "##################################################"
make ARCH=arm CROSS_COMPILE=$CROSS_COMPILER tuna_defconfig


echo "##################################################"
echo "start menuconfig"
echo "##################################################"
make ARCH=arm CROSS_COMPILE=$CROSS_COMPILER menuconfig


echo "##################################################"
echo "compile kernel core"
echo "##################################################"
make -j1 ARCH=arm CROSS_COMPILE=$CROSS_COMPILER 2>&1 | tee build_kernel.log


echo "##################################################"
echo "compile kernel modules"
echo "##################################################"
make -j1 ARCH=arm CROSS_COMPILE=$CROSS_COMPILER modules 2>&1 | tee build_kernel_modules.log


echo "##################################################"
echo "copy kernel and modules to anykernel"
echo "##################################################"
cp $KERNEL_PATH/arch/arm/boot/zImage $ANYKERNEL_PATH/kernel
find $KERNEL_PATH -name *.ko -print | xargs -I {} cp {} $ANYKERNEL_PATH/system/modules


echo "##################################################"
echo "make zip for use with ClockworkMod Recovery"
echo "##################################################"
cd $ANYKERNEL_PATH
zip -r myupdate.zip *


echo "##################################################"
echo "done!"
echo "##################################################"


