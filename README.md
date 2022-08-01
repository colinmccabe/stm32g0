# STM32G0 example project

Minimal example project for STM32G031K8 Nucleo-32 and arm-none-eabi-gcc

## Sources and dependencies

- AUR package [stm32g0-headers-git](https://aur.archlinux.org/packages/stm32g0-headers-git)
- Makefile and main.c inspired by [WRansohoff/STM32_quickstart](https://github.com/WRansohoff/STM32_quickstart/tree/d8c2a2328ed44e3319bcd777cfe0c3b95022fac9)
- From [STMicroelectronics/STM32CubeG0](https://github.com/STMicroelectronics/STM32CubeG0/tree/v1.6.1)
    - [STM32G031K8Tx.ld](https://github.com/STMicroelectronics/STM32CubeG0/blob/v1.6.1/Projects/NUCLEO-G031K8/Examples/ADC/ADC_ContinuousConversion_TriggerSW/STM32CubeIDE/STM32G031K8TX_FLASH.ld)
    - [startup_stm32g030xx.s](https://github.com/STMicroelectronics/STM32CubeG0/blob/v1.6.1/Drivers/CMSIS/Device/ST/STM32G0xx/Source/Templates/gcc/startup_stm32g030xx.s)
    - [system_stm32g0xx.c](https://github.com/STMicroelectronics/STM32CubeG0/blob/v1.6.1/Projects/NUCLEO-G031K8/Examples_LL/LPTIM/LPTIM_PulseCounter_Init/Src/system_stm32g0xx.c)
- From [szczys/stm32f0-discovery-basic-template](https://github.com/szczys/stm32f0-discovery-basic-template/tree/d29476db3aa759bbad4cb432c883b14d99ac56da)
    - [flash.cfg](https://github.com/szczys/stm32f0-discovery-basic-template/blob/d29476db3aa759bbad4cb432c883b14d99ac56da/extra/stm32f0-openocd.cfg)
