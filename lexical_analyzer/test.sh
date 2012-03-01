#!/bin/bash
for f in lexer_test test2
do
	cat $f.pas | ./lex > $f.output
done
