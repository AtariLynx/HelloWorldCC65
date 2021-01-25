!INCLUDE <lynxcc65.mak>

target = helloworld.lnx
objects = main.o

$(target) : $(objects)
	$(CL) -t $(SYS) -o $@ -m helloworld.map $(objects) lynx.lib

all: $(target)
	
clean:
  $(RM) *.tgi
  $(RM) *.s
  $(RM) *.joy
  $(RM) *.o
  $(RM) *.lnx 