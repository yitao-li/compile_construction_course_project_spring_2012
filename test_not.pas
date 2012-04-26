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
	a[0] := not m;
	m := not a[0];
	a[0] := not (2 * 3);
	a[0] := not (2 + 3) div 3;
	a[0] := (1 - not 2 div 3) + (3 * not 4 + 55);
	a[0] := not (1 - not 2 div 3) + not (3 * not 4 + 55);
end.
