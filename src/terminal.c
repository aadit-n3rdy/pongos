
#include "terminal.h"

#define COLS 80
#define ROWS 25

struct terminal_char* const VGA_BUF = (void*)0xB8000;
int cursor = 0;

static void term_newline() {
	cursor = COLS + cursor - cursor%COLS;
}

static void scroll() {
	for (int i = 0; i < ROWS-1; i++) {
		for (int j = 0; j < COLS; j++) {
			VGA_BUF[COLS * i + j] = VGA_BUF[COLS * (i+1) + j];
		}
	}
	for (int j = 0; j < COLS; j++) {
		VGA_BUF[COLS * 79 + j] = (struct terminal_char){ ' ', (TERM_DEFAULT_BG<<4) | TERM_DEFAULT_FG };
	}
}

static void inc_cursor() {
	cursor++;
	if (cursor >= COLS * ROWS) {
		scroll();
		cursor = COLS * (ROWS-1) + 1;
	}
}

void term_putchar(unsigned char fg, unsigned char bg, char c) {
	switch(c) {
		case '\n':
			term_newline();
			break;
		default:
			VGA_BUF[cursor].col = (bg<<4) | fg;
			VGA_BUF[cursor].val = c;
			inc_cursor();
			break;
	}
}

void term_puts(char *str) {
	while (*str != '\0') {
		term_putchar(TERM_DEFAULT_FG, TERM_DEFAULT_BG, *str);
		str++;
	}
}
