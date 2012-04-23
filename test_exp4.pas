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
	r = record
		a,b : integer;
		c   : string
	end;
	RR = array[1..10] of r;
var
	z : s;
	m, nested1, nested2, error, prod: in;
	a, b, c: ARRAY; 
	d : DOUBLE_ARRAY;
	rrrr : RR;
	                                                
begin
	rrrr[0].b := 0;
	rrrr[rrrr[0].b].a := 0;
	rrrr[a[0]].b := 0;
	a[0] := rrrr[a[0]].b;
	a[0 - 0 div 0] := -2 div (1 - 2 * (3 - 4 div (5 + 6)));  {not handling division by 0 yet}
end.
