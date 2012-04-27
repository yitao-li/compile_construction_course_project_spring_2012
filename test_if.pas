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
	if r.b.a = 100 + 2 * 2 + 1 then r.b.a := 0;
	r.b.a := r.b.a + 2;
	b := b and b or b;
	if 3 + 1 = 2 + 2 * 0 + 2 then b := true;
	if b = true then b := false;
	if b then b := false;
	if z = "hello" then
		begin
			if z = "hello" then z := "if"
			else
				begin
					z := "else";
					m := m + 1;
				end
			; 
			m := 100 + 2 * 2 + 1;
		end
	else
		begin
			m := 200 + 4 * 4 + 2;
			z := "closeif";
		end
	;
end.
