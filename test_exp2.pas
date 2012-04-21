{ 
	This program is lexical and parsing error-free. 
	It has multi-declaration error.
}

program errorfree;
type
	s = string;
	in = integer;
                                        
var
	z : s;
	m : in;
begin
	m := (1 + 2 * 3) * (3 * 4 + 55);
end.
