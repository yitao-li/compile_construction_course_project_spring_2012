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
	m, nested1, nested2, error, prod: in;
	a, b, c: ARRAY; 
	d : DOUBLE_ARRAY;
begin
	a[0] := m;
	a[0 - 1] := m;
	a[0 * 0 - 1] := m;
	a[0 - 1 * 1] := a[0 * 0 * 0- 1];
	a[0 - 1 * 1 * 1] := a[0 * 0 - 1 * 1];
	a[0 * 0 * 0- 1 * 1 * 1] := a[0 + 1 + 2];
	a[(1 + 2) * (3 + 4)] := prod;
	d[0] := error; {incompatible assignment}
	a[a[a[0] + 1] + 2] := nested1; {nested}
	a[b[c[0] + 1] + 2] := a[0 + 0];
	a[0 + 0] := (1 - 2 div 3) * (3 * 4 + 55);
	a[0 - 0 div 0] := -2 div (1 - 2 * (3 - 4 div (5 + 6)));  {not handling division by 0 yet}
end.
