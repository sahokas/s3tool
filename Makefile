# Makefile
# http://www.gnu.org/software/make/manual/make.html

CC = gcc

#flags for compiling the executable
CFLAGS = -Wall -pedantic -g -O3


SOURCE = s3tool.cpp aws_s3.cpp aws_s3_misc.cpp

INCLUDEDIRS =

# defined HAVE_CONFIG_H to make curlpp work
DEFINES = -DHAVE_CONFIG_H -DHAVE_STDINT_H

LIBS = -lstdc++ -lssl -lcrypto -lcurl

EXECNAME = s3tool

# openssl and libcurl are typically present on a system, but this is
# not the case for curlpp. try building using a local curlpp version
# if LOCALCURLPP_DIR is found.
LOCAL_CURLPP_DIR = curlpp-0.7.3
ifeq (exists, $(shell test -d $(LOCAL_CURLPP_DIR) && echo exists))
INCLUDEDIRS += -I$(LOCAL_CURLPP_DIR)/include
LIBS += $(LOCAL_CURLPP_DIR)/src/curlpp/.libs/libcurlpp.a
else
LIBS += -lcurlpp
endif

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

