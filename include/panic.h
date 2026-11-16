#ifndef PANIC_H
#define PANIC_H

#define ASSERT(condition) do { if (!(condition)) panic(#condition); } while (0)

void panic(char *chr);

#endif
