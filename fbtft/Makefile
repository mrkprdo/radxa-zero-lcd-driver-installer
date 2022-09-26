ifneq ($(KERNELRELEASE),)
# kbuild part of makefile

# Optionally, include config file to allow out of tree kernel modules build
-include $(src)/.config

# Core module
obj-$(CONFIG_FB_TFT)             += fbtft.o
fbtft-y                          += fbtft-core.o fbtft-sysfs.o fbtft-bus.o fbtft-io.o

# drivers
obj-$(CONFIG_FB_TFT_ST7735R)     += fb_st7735r.o
obj-$(CONFIG_FB_TFT_ST7789V)     += fb_st7789v.o

# Device modules
obj-$(CONFIG_FB_TFT_FBTFT_DEVICE) += fbtft_device.o

else
# normal makefile
KDIR ?= /lib/modules/`uname -r`/build

default: .config
	$(MAKE) -C $(KDIR) M=$$PWD modules

.config:
	grep config Kconfig | cut -d' ' -f2 | sed 's@^@CONFIG_@; s@$$@=m@' > .config

install:
	$(MAKE) -C $(KDIR) M=$$PWD modules_install


clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions \
	       *.order *.symvers *.mod

endif
