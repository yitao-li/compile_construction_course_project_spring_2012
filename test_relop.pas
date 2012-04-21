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
	b : boolean;
begin
	r.b.a := 100 + 2 * 2 + 1 or 8;
	b := r.b.a < 2
end.
