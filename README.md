Made this to make trial and error in setting some configuration more automated

## NOTE:
> Only works for st7789v and st7735r drivers

## Install dependencies:
```
$ sudo apt install device-tree-compiler build-essentail fbi
```

## Build 
- First step check phandle value for gpio. Modify the dts file of your target driver accordingly.
- Also configure the lcd configuration in the dts file. Ie. width,height etc.
- Run build.sh script
```bash
# shell script to run build kernel driver and device overlays and copy them to destination

$ ./build.sh -h
Simple LCD Device Tree Overlay Compiler & Installer
for Radxa Zero running Ubuntu/Debian
author: mrkprdo
USAGE: ./build.sh -t|--target <lcd_driver> -c|--clean -b|--build-only OR -h|--help
        -t | --target <lcd_driver>          Select target LCD driver supported by linux kernel fbtft
        -c | --clean                        Clean the workspace before running, deletes previously
                                            generated files in directory
        -b | --build-only                   Builds device tree overlay and fbtft kernel drivers
        -h | --help                         Display this help menu

# to build
$ ./build.sh -t <st7735r or st7789v> -c
```
- Wait for the build to finish.
> TODO: Fix build to compile only target driver, now it compiles everything. lazy to fix it.
- Modify `/boot/uEnv.txt` and add/change these values:
```
# NOTE to change driver meson-g12a-spi-<driver>
overlays=meson-g12a-spi-st7789v 
param_spidev_spi_bus=1
param_spidev_max_freq=10000000
```
- Reboot.
- Check if `/dev/fb1` exists, `ls /dev/fb*`
- To test if it works, run:
```
sudo fbi -d /dev/fb1 -T 1 -noverbose -a sky.jpg
```

## Pin Configuration
```
VCC      - PIN 4 5v or PIN 1 3.3v
GND      - PIN 6
DC/AO    - PIN 12
MOSI/SDA - PIN 19
SCLK     - PIN 23
SS0/CS   - PIN 24
RESET    - PIN 35
LED      - PIN 17
```

## Troubleshooting
This is the not so fun part. It might be that the kernel drivers included may not work on your specific lcd screens. Shortcut is to search github for the kernel files that someone might already made for the driver that you have. Search for `fb_st7789v.c` just an example.

If you have better understanding of low level development of drivers you can probably debug it yourself.

What I normally found is that, you might need to modify the kernel file's width height and bus width according to your display. Make sure it aligns to the values you modified on your meson file.


