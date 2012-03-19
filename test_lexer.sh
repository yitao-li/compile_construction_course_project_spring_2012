#!/bin/bash
for f in lexer_test test2 test3
do
	./lex < $f.pas > $f.output
done
