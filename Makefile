CC=arm-none-eabi-gcc
LD=arm-none-eabi-ld
OBJCOPY=arm-none-eabi-objcopy
OBJDUMP=arm-none-eabi-objdump
SIZE=arm-none-eabi-size
# where you unpacked the ST distro from http://www.st.com/web/en/catalog/tools/PF257884 to
ST_STDPERIPH_LIB=$(HOME)/Code/cross-compilers/STM32F0xx_StdPeriph_Lib_V1.5.0

# location of core_cm0.h
ST_CORE_INCLUDE_DIR=$(ST_STDPERIPH_LIB)/Libraries/CMSIS/Include
# location of stm32f0xx_conf.h
ST_CONF_INCLUDE_DIR=$(ST_STDPERIPH_LIB)/Projects/STM32F0xx_StdPeriph_Templates
# location of stm32f0xx.h from the ST distro
ST_DEVICE_INCLUDE_DIR=$(ST_STDPERIPH_LIB)/Libraries/CMSIS/Device/ST/STM32F0xx/Include
# location of system_stm32f0xx.c
ST_DEVICE_SOURCE_DIR=$(ST_STDPERIPH_LIB)/Libraries/CMSIS/Device/ST/STM32F0xx/Source/Templates
# location of stm32f0xx_gpio.h
ST_PERIPH_INCLUDE_DIR=$(ST_STDPERIPH_LIB)/Libraries/STM32F0xx_StdPeriph_Driver/inc
# location of stm32f0xx_gpio.c
ST_PERIPH_SOURCE_DIR=$(ST_STDPERIPH_LIB)/Libraries/STM32F0xx_StdPeriph_Driver/src
# device we are building against, must be one listed in stm32f0xx.h
BUILDING_FOR_DEVICE=STM32F051

# location of the OpenOCD board config files
OPENOCD_BOARD_DIR=/usr/share/openocd/scripts/board
# OpenOCD's extra config file for this board, not to be confused with the above config files.
OPENOCD_PROC_FILE=extra/stm32f0-openocd.cfg

CFLAGS=-c -g -Os -Wall -D$(BUILDING_FOR_DEVICE) -I$(ST_CORE_INCLUDE_DIR) -I$(ST_DEVICE_INCLUDE_DIR) -I$(ST_PERIPH_INCLUDE_DIR) -I$(ST_CONF_INCLUDE_DIR)
CFLAGS += -mlittle-endian -mcpu=cortex-m0 -march=armv6-m -mthumb
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -DUSE_STDPERIPH_DRIVER

define cc-command
$(CC) $(CFLAGS) $< -o $@
endef

PERIPHERALS=$(wildcard $(ST_PERIPH_SOURCE_DIR)/*.c)
PERIPHERALS_OBJECTS=$(notdir $(PERIPHERALS:.c=.o))
DEVICES=$(wildcard $(ST_DEVICE_SOURCE_DIR)/*.c)
DEVICES_OBJECTS=$(notdir $(DEVICES:.c=.o)) # $notdir removes the directory path, which is sweet

STARTUP_FILE=$(ST_STDPERIPH_LIB)/Libraries/CMSIS/Device/ST/STM32F0xx/Source/Templates/TrueSTUDIO/startup_stm32f0xx.s

blink.elf: blink.o $(PERIPHERALS_OBJECTS) $(DEVICES_OBJECTS)
	# link the program
	$(CC) -o blink.elf -Tstm32f0.ld -Wl,-lc -Wl,-lg -Wl,-lm -Wl,--gc-sections *.o $(STARTUP_FILE)

blink.bin: blink.elf
	$(OBJCOPY) -O ihex blink.elf blink.hex
	$(OBJCOPY) -O binary blink.elf blink.bin
	$(OBJDUMP) -St blink.elf > blink.lst
	$(SIZE) blink.elf

program: blink.bin
	# you must have OpenOCD installed and the device connected
	openocd -f $(OPENOCD_BOARD_DIR)/stm32f0discovery.cfg \
			-f $(OPENOCD_PROC_FILE)\
			-c "stm_flash `pwd`/blink.bin" -c shutdown

clean:
	rm -f *.o *.elf

$(PERIPHERALS_OBJECTS): %.o: $(ST_PERIPH_SOURCE_DIR)/%.c
	$(cc-command)

$(DEVICES_OBJECTS): %.o: $(ST_DEVICE_SOURCE_DIR)/%.c
	$(cc-command)

%.o: %.c
	$(cc-command)
