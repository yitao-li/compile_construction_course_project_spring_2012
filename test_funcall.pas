{ 
	This program is error-free.
}

program errorfree;
type
	s = string;
	in = integer;
var
	z : in;
	m : in;

function foo(a : in) : in; 
begin
   a := a + 1;
   foo := a 	
end;

function bar(a : in) : in; 
begin
   a := a + a;
   bar := a 	
end;

begin
	z := foo(6 * 5);
	z := foo(3) * z;
	z := foo(1) * bar(2);
	z := foo(1) * bar(2 * foo(3) * z);
	z := foo(foo(foo(0))) * foo(0);
	z := bar(6) * foo(2);
	z := bar(6) * bar(2);
	m := z * 5 * bar(1);
end.
