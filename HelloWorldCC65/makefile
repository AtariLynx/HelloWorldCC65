# Include paths we may need for compilations
ifndef PREFIX
	PREFIX=/usr/share
endif
ifeq ($(CC65_HOME),)
	CC65_HOME=$(PREFIX)/cc65
endif
CC65_INC=$(CC65_HOME)/include
CC65_LIB=$(CC65_HOME)/lib
CA65_INC=$(CC65_HOME)/asminc

# Compiling for Atari Lynx system
SYS=lynx

# Names of tools
CO=co65
CC=cc65
AS=ca65
AR=ar65
CL=cl65
SPRPCK=sprpck
CP=cp
RM=rm -f
ECHO=echo

CODE_SEGMENT=CODE
DATA_SEGMENT=DATA
RODATA_SEGMENT=RODATA
BSS_SEGMENT=BSS
 
SEGMENTS=--code-name $(CODE_SEGMENT) \
				--rodata-name $(RODATA_SEGMENT) \
				--bss-name $(BSS_SEGMENT) \
				--data-name $(DATA_SEGMENT)

# Flag for assembler
AFLAGS=-I $(CA65_INC) -t $(SYS)

# Flags for C-code compiler
CFLAGS=-I $(CC65_INC) -t $(SYS) --add-source -O -Or -Cl -Os

target = helloworld.lnx 
objects = main.o

$(target) : $(objects)
	$(CL) -t $(SYS) -o $@ -m helloworld.map $(objects) lynx.lib 

.SUFFIXES: .o .c .s .asm .bmp

# Rule for making a *.o file out of a *.c file
%.o: %.c
	$(CC) $(CFLAGS) $(SEGMENTS) -o $(patsubst %c, %s, $(notdir $<)) $<
	$(AS) -o $@ $(AFLAGS) $(*).s
	$(RM) $*.s

# Rule for making a *.o file out of a *.s or *.asm file
%.o: %.s
	$(AS) -o $@ $(AFLAGS) $<
%.o: %.asm
	$(AS) -o $@ $(AFLAGS) $<

# Rule for making a *.o file out of a *.bmp file
%.o : %.bmp
	$(SPRPCK) -t6 -p2 $<
	$(ECHO) .global _$* > $*.s
	$(ECHO) .segment \"$(RODATA_SEGMENT)\" >> $*.s
	$(ECHO) _$*: .incbin \"$*.spr\" >> $*.s
	$(AS) -o $@ $(AFLAGS) $*.s
	$(RM) $*.s
	$(RM) $*.pal
	$(RM) $*.spr

lynx-stdjoy.o:
	$(CP) $(CC65_HOME)/target/$(SYS)/drv/joy/$*.joy .
	$(CO) --code-label _$(SYS)joy $*.joy
	$(AS) -o $@ $(AFLAGS) $*.s
	$(RM) $*.joy
	$(RM) $*.s

lynx-160-102-16.o:
	$(CP) $(CC65_HOME)/target/$(SYS)/drv/tgi/$*.tgi .
	$(CO) --code-label _$(SYS)tgi -o $*.s $*.tgi
	$(AS) -o $@ $(AFLAGS) $*.s
	$(RM) $*.tgi
	$(RM) $*.s

all: $(target)

clean :
	$(RM) $(objects)
	$(RM) $(target)
	$(RM) *.spr
	$(RM) *.tgi
	$(RM) *.joy
	$(RM) *.s
	$(RM) *.pal