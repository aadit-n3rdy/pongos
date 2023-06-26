#ifndef CLOS_TERMINAL_H
#define CLOS_TERMINAL_H

#define TERM_DEFAULT_COL 0x0f

#define TERM_DEFAULT_FG WHITE
#define TERM_DEFAULT_BG BLACK

enum  TERM_COLORS {
	BLACK			= 0,
	BLUE			= 1,
	GREEN			= 2,
	CYAN			= 3,
	RED				= 4,
	MAGENTA			= 5,
	BROWN			= 6,
	LIGHT_GRAY		= 7,
	DARK_GRAY		= 8,
	LIGHT_BLUE		= 9,
	LIGHT_GREEN		= 10,
	LIGHT_CYAN		= 11,
	LIGHT_RED		= 12,
	LIGHT_MAGENTA	= 13,
	LIGHT_YELLOW	= 14,
	WHITE			= 15
};

struct terminal_char {
	unsigned char val;
	unsigned char col;
} __attribute__((packed));


void term_putchar(unsigned char fg, unsigned char bg, char c);

void term_puts(char *str);

#endif
