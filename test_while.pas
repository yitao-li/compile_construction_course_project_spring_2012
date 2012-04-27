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
	while true do
		begin
			z := "HELLO";
			m := m + 1;
			b := true;
			while m + 3 = m + 1 + 2 do
				begin
					if b = false then m := m + 1 else m := m - 1;
					z := "HELLO" 
				end
		end
	;
end.
