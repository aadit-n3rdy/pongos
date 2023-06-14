
#define TERM_DEFAULT_COL 0x0f

struct terminal_char {
	unsigned char val;
	unsigned char col;
} __attribute__((packed));

struct terminal_char* const VGA_BUF = (void*)0xB8000;


void terminal_print(const char *str) {
	struct terminal_char *cur_ptr = VGA_BUF;
	while (*str != '\0') {
		cur_ptr->val = *str;
		cur_ptr->col = TERM_DEFAULT_COL;
		str++;
		cur_ptr++;
	}
}

void kernel_main() {
	terminal_print("Hello World!!");
}
