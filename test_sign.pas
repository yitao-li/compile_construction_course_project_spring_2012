{ 
	This program is lexical and parsing error-free. 
	It has multi-declaration error.
}

program errorfree;
type
	s = string;
	in = integer;
	A = array[1..10] of integer;
var
	z : s;
	m : in;
	a : A;
begin
	z := "";
	m := -7 + 66;
	m := 6 and 666;
	a[0] := -1;
end.
