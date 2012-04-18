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
	{z : in;  {error: multiple declaration}

function foo(x : integer) : string; forward;

begin
	z := "";
	m := 7;
      {p := m; {error: undeclared variable}	
end.
