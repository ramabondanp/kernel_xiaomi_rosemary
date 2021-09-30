#!/bin/bash
# Original script by arter97 <Park Ju Hyung <qkrwngud825@gmail.com>
# Modified

export RAMDISKDIR=`readlink -f .`
export PARTITION_SIZE=67108864

export PATH="$RAMDISKDIR/bin/:$PATH"

export OS="11.0.0"
export SPL="2021-06"

echo "ramdiskdir = $RAMDISKDIR"

echo "Making new boot image"
mkbootimg \
    --kernel $RAMDISKDIR/Image.gz \
    --ramdisk $RAMDISKDIR/ramdisk.cpio.gz \
    --cmdline 'bootopt=64S3,32N2,64N2' \
    --base           0x40078000 \
    --pagesize       2048 \
    --kernel_offset  0x00008000 \
    --ramdisk_offset 0x07c08000 \
    --second_offset  0xbff88000 \
    --tags_offset    0x0bc08000 \
    --dtb            ramdisk.dtb \
    --dtb_offset     0x0bc08000 \
    --os_version     $OS \
    --os_patch_level $SPL \
    --header_version 2 \
    -o $RAMDISKDIR/boot.img

GENERATED_SIZE=$(stat -c %s boot.img)
if [[ $GENERATED_SIZE -gt $PARTITION_SIZE ]]; then
	echo "boot.img size larger than partition size!" 1>&2
	exit 1
fi

echo "done"
ls -al boot.img
echo ""
