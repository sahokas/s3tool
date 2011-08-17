# Makefile
# http://www.gnu.org/software/make/manual/make.html

CC = gcc

#flags for compiling the executable
CFLAGS = -Wall -pedantic -g -O3


SOURCE = s3tool.cpp aws_s3.cpp aws_s3_misc.cpp

INCLUDEDIRS =

# defined HAVE_CONFIG_H to make curlpp work
DEFINES = -DHAVE_CONFIG_H -DHAVE_STDINT_H

LIBS = -lstdc++ -lssl -lcrypto -lcurlpp -lcurl

EXECNAME = s3tool


CSOURCES = $(filter %.c,$(SOURCE))
CPPSOURCES = $(filter %.cpp,$(SOURCE))
MSOURCES = $(filter %.m,$(SOURCE))

OBJECTS = $(CSOURCES:.c=.o) \
          $(CPPSOURCES:.cpp=.o) \
          $(MSOURCES:.m=.o)


CFLAGS := $(CFLAGS) $(DEFINES) $(INCLUDES) $(INCLUDEDIRS)


default: $(EXECNAME) Makefile


run: $(EXECNAME) Makefile
	./$(EXECNAME)

#$(EXECNAME): $(OBJECTS)

$(EXECNAME): $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) $(LIBS) -o $(EXECNAME)


%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.m
	$(CC) $(CFLAGS) -c $< -o $@


install:


clean:
	rm -f $(OBJECTS)
	rm -f $(EXECNAME)
	rm -f .depend


depend:
	if [ ! -e .depend ]; then touch .depend; fi
	makedepend -f.depend -- $(CFLAGS) -- $(SOURCE)

-include .depend

