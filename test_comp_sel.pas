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
	m := 1 + 2;
	r.b.s := 100;   {no field with name 's'}
	r.b.a := 100;
end.
