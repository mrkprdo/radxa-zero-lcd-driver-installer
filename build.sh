#!/usr/bin/bash

ECHO='echo -e'

${ECHO} "Simple LCD Device Tree Overlay Compiler & Installer"
${ECHO} "for Radxa Zero running Ubuntu/Debian"
${ECHO} "author: mrkprdo"

function usage()
{
    ${ECHO} "USAGE: ./build.sh -t|--target <lcd_driver> -c|--clean -b|--build-only OR -h|--help"
    ${ECHO} "\t-t | --target <lcd_driver>          Select target LCD driver supported by linux kernel fbtft"
    ${ECHO} "\t-c | --clean                        Clean the workspace before running, deletes previously"
    ${ECHO} "\t                                    generated files in directory"
    ${ECHO} "\t-b | --build-only                   Builds device tree overlay and fbtft kernel drivers"
    ${ECHO} "\t-h | --help                         Display this help menu"
    ${ECHO} "\n"
}

SHOWUSAGE=0
CLEAN=0
BUILDONLY=0
TARGETDRIVER=""
KERNELVERSION=$(uname -r)
DTOPATH="/boot/dtbs/$KERNELVERSION/amlogic/overlay"

VALID_ARGS=$(getopt -o t:cbh --long target:,clean,build-only,help -- "$@")
eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    -h | --help)
        SHOWUSAGE=1
        shift;
        break
        ;;
    -c | --clean)
        CLEAN=1
        shift;
        ;;
    -b | --build-only)
        BUILDONLY=1
        shift;
        ;;
    -t | --target)
        TARGETDRIVER=$2
        shift 2;
        ;;
    *) 
        shift;
        break 
        ;;
  esac
done

get_sudo_pass() {
    if [[ -n "$PASSWORD" ]]
    then
        sudo -k
        echo "$PASSWORD" | sudo -S echo -n "" 2>/dev/null
        [[ $? -eq 0 ]] && return 0
    fi
    echo -n "[sudo] password for $USER: "
    read -s PASSWORD
    echo ""
}

if [[ $SHOWUSAGE = 1 ]]
then
    usage
else
    get_sudo_pass
    cd ./fbtft
    if [[ $CLEAN = 1 ]]
    then
        echo "Cleaning workspace before starting..."
        make clean
    fi

    if [[ $TARGETDRIVER != "" ]]
    then
        # start building here
        echo "Building target for: $TARGETDRIVER"
        make
        echo "Done building."
        if [[ $BUILDONLY = 0 ]]
        then
            echo "Installing dto files and kernel driver"
            echo $PASSWORD | sudo cp {fb_$TARGETDRIVER.ko,fbtft.ko} /usr/lib/modules/$KERNELVERSION/kernel/drivers/staging/fbtft/
            echo $PASSWORD | sudo cp ../meson-g12a-spi-$TARGETDRIVER.dts $DTOPATH
            echo $PASSWORD | sudo dtc -@ -I dts -O dtb -o $DTOPATH/meson-g12a-spi0-$TARGETDRIVER.dtbo $DTOPATH/meson-g12a-spi0-$TARGETDRIVER.dts
        fi
    fi
fi