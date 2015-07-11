#include <stm32f0xx_gpio.h>
#include <stm32f0xx_rcc.h>

/*
    This example code is basically taken from
    http://hsel.co.uk/2014/05/31/stm32f0-tutorial-1-gpio/
*/

#define GreenLED_Pin GPIO_Pin_9
#define BlueLED_Pin GPIO_Pin_8
#define LED_GPIO GPIOC

#define PushButton_Pin GPIO_Pin_0
#define PushButton_GPIO GPIOA

int main(void) {
    /* enable clocks to the gpio pins A and C */
    RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOA, ENABLE);
    RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOC, ENABLE);

    /* set up the GPIO */
    GPIO_InitTypeDef gp;
    gp.GPIO_Pin = GreenLED_Pin | BlueLED_Pin;
    gp.GPIO_Mode = GPIO_Mode_OUT; /* digital output */
    gp.GPIO_OType = GPIO_OType_PP; /* push-pull */
    gp.GPIO_PuPd = GPIO_PuPd_NOPULL; /* disable pull-up and pull-down resistors */
    gp.GPIO_Speed = GPIO_Speed_Level_1; /* the slowest */
    GPIO_Init(LED_GPIO, &gp);

    /* set up the button */
    gp.GPIO_Mode = GPIO_Mode_IN;
    GPIO_Init(PushButton_GPIO, &gp);

    /* wait for a push */
    uint8_t buttonRead = 0;

    while(1) {
        buttonRead = GPIO_ReadInputDataBit(PushButton_GPIO, PushButton_Pin);
        if(buttonRead) {
            /* green on, blue off */
            GPIO_SetBits(LED_GPIO, GreenLED_Pin);
            GPIO_ResetBits(LED_GPIO, BlueLED_Pin);
        }
        else {
            /* blue on, green off */
            GPIO_ResetBits(LED_GPIO, GreenLED_Pin);
            GPIO_SetBits(LED_GPIO, BlueLED_Pin);
        }
    }

    return 0;
}
