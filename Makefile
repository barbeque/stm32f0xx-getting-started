CC=arm-none-eabi-gcc
# where you unpacked the ST distro from http://www.st.com/web/en/catalog/tools/PF257884 to
ST_STDPERIPH_LIB=$(HOME)/Code/cross-compilers/STM32F0xx_StdPeriph_Lib_V1.5.0

# location of core_cm0.h
ST_CORE_INCLUDE_DIR=$(ST_STDPERIPH_LIB)/Libraries/CMSIS/Include
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

CFLAGS=-c -Wall -D$(BUILDING_FOR_DEVICE) -I$(ST_CORE_INCLUDE_DIR) -I$(ST_DEVICE_INCLUDE_DIR) -I$(ST_PERIPH_INCLUDE_DIR)

define cc-command
$(CC) $(CFLAGS) $< -o $@
endef

PERIPHERALS=$(wildcard $(ST_PERIPH_SOURCE_DIR)/*.c)
PERIPHERALS_OBJECTS=$(PERIPHERALS:.c=.o) # TODO: This should be an output directory or something

all: blink.o $(PERIPHERALS_OBJECTS)  #device.o
	# link the program
	$(CC) blink.o $(PERIPHERALS_OBJECTS) device.o

clean:
	rm -f *.o *.elf

# TODO: Build device C files
# TODO: Build peripheral C files

$(PERIPHERALS_OBJECTS): $(PERIPHERALS)
	$(cc-command)

%.o: %.c
	$(cc-command)
