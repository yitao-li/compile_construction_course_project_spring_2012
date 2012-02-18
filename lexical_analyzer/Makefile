CC=gcc
CFLAGS=-c -g -Wall -O3
LDFLAGS=

FLEX=flex
FLEX_OUTPUT=lex.yy.c

RUN_FLEX=$(FLEX_INPUT:.l=.c)
SOURCES=lex.l
OBJECTS=$(SOURCES:.l=.o)
EXECUTABLE=lex


all: $(RUN_FLEX) $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

.l.o:
	$(FLEX) $< && $(CC) $(CFLAGS) $(FLEX_OUTPUT) -o $@

clean:
	rm *.o $(FLEX_OUTPUT) $(EXCUTABLE)
