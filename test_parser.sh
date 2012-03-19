#!/bin/bash
for f in lexer_test test2 test3
do
	./parser < $f.pas
	mv rules.out $f.rules.out
	mv symtable.out $f.symtable.out
done
