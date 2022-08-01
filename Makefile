TARGET = main
MCU = STM32G031xx
MCU_FILES = STM32G031K8Tx
ST_MCU_DEF = STM32G031xx
MCU_CLASS = G0
MCU_SPEC = cortex-m0plus

# Toolchain definitions (ARM bare metal defaults)
TOOLCHAIN = /usr
CC = $(TOOLCHAIN)/bin/arm-none-eabi-gcc
AS = $(TOOLCHAIN)/bin/arm-none-eabi-as
LD = $(TOOLCHAIN)/bin/arm-none-eabi-ld
OC = $(TOOLCHAIN)/bin/arm-none-eabi-objcopy
OD = $(TOOLCHAIN)/bin/arm-none-eabi-objdump
OS = $(TOOLCHAIN)/bin/arm-none-eabi-size

WARN_FLAGS = -Wall -Wextra -Wpedantic -Werror

# Assembly directives.
ASFLAGS += -c
ASFLAGS += -O0
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb
ASFLAGS += $(WARN_FLAGS)
# (Set error messages to appear on a single line.)
ASFLAGS += -fmessage-length=0
ASFLAGS += -DVVC_$(MCU_CLASS)

# C compilation directives
CFLAGS += -mcpu=$(MCU_SPEC)
CFLAGS += -mthumb
CFLAGS += -msoft-float
CFLAGS += -mfloat-abi=soft
CFLAGS += -Os
CFLAGS += $(WARN_FLAGS)
CFLAGS += -g
CFLAGS += -fmessage-length=0
CFLAGS += -ffunction-sections
CFLAGS += -fdata-sections
CFLAGS += --specs=nosys.specs
CFLAGS += -D$(ST_MCU_DEF)
CFLAGS += -DVVC_$(MCU_CLASS)

# Linker directives.
LSCRIPT = ./device/ld/$(MCU_FILES).ld
LFLAGS += -mcpu=$(MCU_SPEC)
LFLAGS += -mthumb
LFLAGS += -msoft-float
LFLAGS += -mfloat-abi=soft
LFLAGS += $(WARN_FLAGS)
LFLAGS += --specs=nosys.specs
LFLAGS += -lgcc
LFLAGS += -Wl,--gc-sections
LFLAGS += -Wl,-L./device/ld
LFLAGS += -T$(LSCRIPT)

AS_SRC   =  ./device/startup/startup_stm32g030xx.s
C_SRC    =  ./device/startup/system_stm32g0xx.c ./src/main.c

INCLUDE  =  -I./
INCLUDE  += -I/opt/STM32/STM32G0

OBJS  = $(AS_SRC:.s=.o)
OBJS += $(C_SRC:.c=.o)

.PHONY: all
all: $(TARGET).bin

%.o: %.s
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $(INCLUDE) $< -o $@

$(TARGET).elf: $(OBJS)
	$(CC) $^ $(LFLAGS) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OC) -S -O binary $< $@
	$(OS) $<

flash: $(TARGET).bin
	openocd -f ./device/openocd/openocd.cfg -f ./device/openocd/flash.cfg -c "stm_flash `pwd`/$(TARGET).bin" -c shutdown

.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf
	rm -f $(TARGET).bin
