{ 
	This program is error-free.
}

program errorfree;
type
	s = string;
	integer = int;
	in = integer;
var
	z : in;
	m : in;

function foo(a : in) : in; 
begin
   a := a + 1;
   foo := a 	
end;

procedure bar(x : int);
begin
   x := x * x;
   x := x + 1; 	
end;

begin
	m := foo(1) + foo(2) * (foo(3) + foo(4));
end.
