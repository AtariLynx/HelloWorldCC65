CC65="C:\Program Files\CC65"
CC65_BIN=$(CC65)\bin
CC65_INC=$(CC65)\include
CC65_ASMINC=$(CC65)\asminc
CC65_TOOLS=$(CC65)\wbin
 
BUILDDIR=$(MAKEDIR)\$(BUILD)
ODIR=$(MAKEDIR)\obj

.SUFFIXES : .c .s .asm .bmp
.SOURCE : 
 
# Compiling for Atari Lynx system
SYS=lynx

# Names of tools
CO=co65
CC=cc65
AS=ca65
AR=ar65
CL=cl65
SPRPCK=sprpck
CP=copy
RM=del
ECHO=echo
TOUCH=touch
  
CODE_SEGMENT=CODE
DATA_SEGMENT=DATA
RODATA_SEGMENT=RODATA
BSS_SEGMENT=BSS
 
SEGMENTS=--code-name $(CODE_SEGMENT) \
				--rodata-name $(RODATA_SEGMENT) \
				--bss-name $(BSS_SEGMENT) \
				--data-name $(DATA_SEGMENT)

# Flag for assembler
AFLAGS=
 
# Flags for C-code compiler
CFLAGS=-I . -t $(SYS) --add-source -O -Or -Cl -Os

# Rule for making a *.o file out of a *.s or *.asm file
.s.o:
	$(AS) -t $(SYS) -I $(CC65_ASMINC) -o $@ $(AFLAGS) $<
.asm.o:
	$(AS) -t $(SYS) -I $(CC65_ASMINC) -o $@ $(AFLAGS) $<
 
# Rule for making a *.o file out of a *.c file
.c.o:
	$(CC) -o $(*).s $(SEGMENTS) $(CFLAGS) $<
	$(AS) -o $@ $(AFLAGS) $(*).s

lynx-stdjoy.o:
	$(CP) $(CC65)\target\lynx\drv\joy\$*.joy .
	$(CO) --code-label _lynxjoy $*.joy
	$(AS) -t lynx -o $@ $(AFLAGS) $*.s
	$(RM) $*.joy
	$(RM) $*.s
 
lynx-160-102-16.o:
	$(CP) $(CC65)\target\lynx\drv\tgi\$*.tgi .
	$(CO) --code-label _lynxtgi -o $*.s $*.tgi
	$(AS) -t lynx -o $@ $(AFLAGS) $*.s
	$(RM) $*.tgi
	$(RM) $*.s

# Rule for making a *.o file out of a *.bmp file
.bmp.o:
	$(SPRPCK) -t6 -p2 $<
	$(ECHO) .global _$(*B) > $*.s
	$(ECHO) .segment "$(RODATA_SEGMENT)" >> $*.s
	$(ECHO) _$(*B): .incbin "$*.spr" >> $*.s
	$(AS) -t lynx -o $@ $(AFLAGS) $*.s
	$(RM) $*.s
	$(RM) $*.pal
	$(RM) $*.spr