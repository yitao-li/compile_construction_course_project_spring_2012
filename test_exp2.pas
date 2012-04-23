{ 
	This program is lexical and parsing error-free. 
	It has multi-declaration error.
}

program errorfree;
type
	s = string;
	in = integer;
	ARRAY = array[1..10] of integer;
	DOUBLE_ARRAY = array[1..10] of ARRAY;                              
var
	z : s;
	m : in;
	a : ARRAY;
	b : DOUBLE_ARRAY;
begin
	m := a[0];
	m := a[0 - 1];
	m := a[0 * 0 - 1];
	m := a[0 - 1 * 1];
	m := a[0 * 0 * 0- 1];
	m := a[0 - 1 * 1 * 1];
	m := a[0 * 0 - 1 * 1];
	m := a[0 * 0 * 0- 1 * 1 * 1];
	m := a[0 + 1 + 2];
	m := a[(1 + 2) * (3 + 4)];
	m := b[0]; {incompatible assignment}
	m := (1 - 2 div 3) * (3 * 4 + 55);
	m := -2 div (1 - 2 * (3 - 4 div (5 + 6)));
end.
