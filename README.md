### Getting started with the discovery board
This is example code and a Makefile that I cobbled together from multiple sources when trying to figure out how to use the STM32F0DISCOVERY evaluation board on my Mac.

The full ordeal can be found on my blog [here](http://nondisplayable.ca/2015/07/10/stm32f0-discovery-setup-mac-os-x.html)

## Requirements
There are a number of tasks needed to fix this to work on your computer.

 1. Install libusb, [stlink](https://github.com/texane/stlink), the driver for stlink, the [GCC EABI arm tools](https://launchpad.net/gcc-arm-embedded/+download) and [openocd](http://openocd.git.sourceforge.net/git/gitweb.cgi?p=openocd/openocd;a=summary).
 2. Download [the STM standard peripheral library](http://www.st.com/web/en/catalog/tools/PF257884), which you'll need to build pretty much anything.
 3. Alter the Makefile's variables, including telling it what chipset you are using (my device was the STM32F051, but yours might not be)
 4. `make`
 5. With the device connected, call `make program` to push it to the device using OpenOCD.
