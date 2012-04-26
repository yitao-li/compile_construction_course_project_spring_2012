{ 
	This program is lexical and parsing error-free. 
	It has multi-declaration error.
}

program errorfree;
type
	s = string;
	in = integer;
	A = array[1..10] of integer;
	RR = record
		a,b : integer;
		c   : string
	end;
	R = record
		a,b : RR;
		c   : string
	end;
	
                                        
var
	z : s;
	m : in;
	r : R;
begin
	z := "";
	m := 1 + 2 * 3 + 4 * 5 * (6 + 7);
	m := -1 + 1;
	m := (1 + m * 2) * (3 * 4 + 5 * m);
	m := -(1 + 11 + 111) * (2 + 22 + 222) * (3 + 33 + 333) + (4 + 44) * (5 + 55);
	m := 3 * 4 + 1;
	m := -3 * 4 + 1;
	m := 3 * 4 * 6 + 1;
	m := -3 * 4 * 6 + 1;
	m := 3 * 4 * 6 * 9 + 1;
	m := -3 * 4 * 6 * 9 + 1;
	m := 1 + 3 * 4;
	m := 1 + 3 * 4 * 6;
	m := 1 + 3 * 4 * 6 * 9;
	m := -7;
	m := 1 + 2;
	m := m + 1 + 2 + 3 +4 + 5 + 6;
	m := 1 + 2 + 1;
	r.b.a := 100;
	m := r.b.a + r.b.a;
end.
