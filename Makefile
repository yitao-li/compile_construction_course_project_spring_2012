CC=g++
CFLAGS=-c -g -std=c++0x -O3 -Wall
LDFLAGS=
BISON_FLAGS=-d -v

FLEX=flex
FLEX_FLAGS=-l
FLEX_OUTPUT=lex.h

BISON=bison
BISON_OUTPUT_C=parser.tab.c
BISON_OUTPUT_H=parser.tab.h
BISON_OUTPUT_O=parser.tab.o

SOURCES=lex.l parser.y
EXECUTABLE=parser

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(SOURCES:.l=.h) $(SOURCES:.y=.o)
	$(CC) $(LDFLAGS) $(BISON_OUTPUT_O) -o $@

.l.h:
	$(FLEX) $(FLEX_FLAGS) -o $(FLEX_OUTPUT) $<

.y.o:
	$(BISON) $(BISON_FLAGS) $< && $(CC) $(CFLAGS) $(BISON_OUTPUT_C)

clean:
	rm *.o *.out *.output $(FLEX_OUTPUT) $(BISON_OUTPUT_C) $(BISON_OUTPUT_H) $(EXECUTABLE)
