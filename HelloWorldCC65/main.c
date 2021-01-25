#include <6502.h>
#include <lynx.h>
#include <tgi.h>
#include <stdlib.h>
#include <conio.h>
#include <joystick.h> 

void initialize()
{
	tgi_install(&tgi_static_stddrv);
	joy_install(&joy_static_stddrv);
	tgi_init();

	CLI();

	while (tgi_busy()) ;

	tgi_setpalette(tgi_getdefpalette());
	tgi_setcolor(COLOR_WHITE);
	tgi_setbgcolor(COLOR_BLACK);

	tgi_clear();
}

void show_screen()
{
	// Clear current screen
	tgi_clear();

	tgi_setcolor(COLOR_WHITE);
	tgi_outtextxy(20, 48, "Hello, World!");

	tgi_updatedisplay();
}

void main(void)
{
	initialize();

	while (1)
	{
		if (kbhit())
		{
			switch (cgetc())
			{
			case 'F':
				tgi_flip();
				break;

			default:
				break;
			}
		}

		if (!tgi_busy())
		{
			show_screen();
		}
	}
	return;
}