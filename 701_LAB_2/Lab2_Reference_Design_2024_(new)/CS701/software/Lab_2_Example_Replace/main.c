/*
 * main.c
 *
 *  Created on: 29/04/2024
 *      Author: ntjo268
 */

#include <stdio.h>
#include "system.h"
#include "stdbool.h"
#include "altera_avalon_pio_regs.h"
#include <stdint.h>
#include <alt_types.h>
#include <sys/alt_irq.h>
#include <sys/alt_alarm.h>

int display_count(int count) { // decimal
	switch (count) {
	case 0:
		return 0b1000000;
		break;
	case 1:
		return 0b1111001;
		break;
	case 2:
		return 0b0100100;
		break;
	case 3:
		return 0b0110000;
		break;
	case 4:
		return 0b0011001;
		break;
	case 5:
		return 0b0010010;
		break;
	case 6:
		return 0b0000010;
		break;
	case 7:
		return 0b1111000;
		break;
	case 8:
		return 0b0000000;
		break;
	case 9:
		return 0b0010000;
		break;

	default:
		return 0b1111111;
		break;
	}
}

int main()
{
	int KEY0, KEY1, KEY2;
	int input;
	int state, count = 0;
	uint16_t bitmask = IORD_ALTERA_AVALON_PIO_DATA(LED_PIO_BASE);

	int dataNOCRD = IORD_ALTERA_AVALON_PIO_DATA(NOC_32_IN_BASE);
	printf("\n %d \n", dataNOCRD);
	//int dataNOCWR = IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_BASE);
	int dataNOCsplit[8];

	int addrNOCRD = IORD_ALTERA_AVALON_PIO_DATA(NOC_8_IN_BASE);
	printf("\n %d \n", addrNOCRD);
	//int addrNOCWR = IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_BASE);

	while(1) {
		//printf("%d \n", (IORD_ALTERA_AVALON_PIO_DATA(BUTTON_PIO_BASE)));
		//usleep(500);
		if (IORD_ALTERA_AVALON_PIO_DATA(BUTTON_PIO_BASE) == 13) {
			//printf("button check = 14 \n");
			if (state > 4){
				state = 4;
			} else {
				state = 10;
			}
			count = count + 1;
			if (count > 9){
				count = 0;
			}
			usleep(250000);
			printf("%d \n", count);
		}
		int digit0 = display_count(count);
		IOWR_ALTERA_AVALON_PIO_DATA(DIGIT_0_PIO_BASE, digit0);

		//

		int mask = 0xF;

		for (int i = 0; i < 8; i++) {
			dataNOCsplit[i] = (dataNOCRD >> (4 * i)) & mask;
			//printf("%d \n", dataNOCsplit[i]);
			//usleep(250000);
		}



		if ((dataNOCsplit[7] == 8) && ((dataNOCsplit[4] & 0x1) == 0) && (IORD_ALTERA_AVALON_PIO_DATA(BUTTON_PIO_BASE) == 11) ) {
			IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 3);
			IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, dataNOCRD);

		} else if ((dataNOCsplit[7] == 8) && ((dataNOCsplit[4] & 0x1) == 1) && (IORD_ALTERA_AVALON_PIO_DATA(BUTTON_PIO_BASE) == 7) ) {
			IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 3);
			IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, dataNOCRD);

		} else {

			switch(state) {
				case(10):
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 3);
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, 0x93100000);
					state = 9;
				break;
				case(9):
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 1);
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, 0xb1020000);
					state = 8;
				break;
				case(8):
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 1);
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, 0xb1030000);
					state = 7;
				break;
				case(7):
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 0);
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, 0xa0220000);
					state = 6;
				break;
				case(6):
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 0);
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, 0xa0230000);
					state = 5;
				break;
				case(4):
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 0);
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, 0xa0000000);
					state = 3;
				break;
				case(3):
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 0);
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, 0xa0010000);
					state = 2;
				break;
				case(2):
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 1);
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, 0xb1000000);
					state = 1;
				break;
				case(1):
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 1);
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, 0xb1010000);
					state = 0;
				break;
				default:
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_8_OUT_BASE, 1);
					IOWR_ALTERA_AVALON_PIO_DATA(NOC_32_OUT_BASE, 0x00000000);
				break;
			}

		}
	}

	return 0;
}
