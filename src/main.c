#include <stddef.h>
#include <string.h>
#include <stm32g0xx.h>

#define LED_PIN 6

// Default values for the core system clock frequency.
const uint32_t CORE_CLOCK_HZ = 16000000;

// SysTick counter definition.
volatile uint32_t systick = 0;


// Delay for a specified number of milliseconds.
// TODO: Prevent rollover bug on the 'systick' value.
void delay_ms(uint32_t ms) {
  // Calculate the tick value when the system should stop delaying.
  uint32_t next = systick + ms;

  // Wait until the system reaches that tick value.
  // Use the 'wait for interrupt' instruction to save power.
  while (systick < next) __WFI();
}


void delay_nop(uint32_t iterations) {
  for (uint32_t i = 0; i < iterations; ++i) __NOP();
}


// SysTick interrupt handler: increment the global 'systick' value.
void SysTick_Handler(void) {
  ++systick;
}


void printchar(char c) {
  while (!(USART2->ISR & USART_ISR_TXE_TXFNF));
  USART2->TDR = c;
}


void println(char *str) {
  for (size_t i = 0; i < strlen(str); ++i) {
    printchar(str[i]);
  }

  printchar('\r');
  printchar('\n');
}


int main(void) {
  // Set up the SysTick peripheral for 1ms ticks.
  SysTick_Config(CORE_CLOCK_HZ / 1000);

  // Blink
  RCC->IOPENR |= RCC_IOPENR_GPIOCEN;
  GPIOC->MODER &= ~(0x3 << (LED_PIN * 2));  // This is initialized to 0xF!
  GPIOC->MODER |=  0x1 << (LED_PIN * 2);
  GPIOC->ODR |= 1 << LED_PIN;

  // USART Nucleo Virtual COM PORT
  RCC->IOPENR |= RCC_IOPENR_GPIOAEN;
  GPIOA->MODER &= ~GPIO_MODER_MODE2;  // This is initialized to 0xF!
  GPIOA->MODER |= GPIO_MODER_MODE2_1;
  GPIOA->AFR[0] |= GPIO_AFRL_AFSEL2_0;
  RCC->APBENR1 |= RCC_APBENR1_USART2EN;
  USART2->BRR = CORE_CLOCK_HZ / 115200;
  USART2->CR1 |= USART_CR1_TE;
  USART2->CR1 |= USART_CR1_UE;

  while (1) {
    delay_ms(1000);
    GPIOC->ODR ^= 1 << LED_PIN;
    println("hello");
  }

  return 0;
}
