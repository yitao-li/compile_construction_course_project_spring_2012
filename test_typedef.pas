{ 
	This program is lexical and parsing error-free.
}

program errorfree;
type
	s = string;
	r = record
		a,b : integer;
		c   : s
	end;
	y = array[1..10] of r;
	
var
	z : s;

function foo1(a : integer) : r; 
begin
   a := 0
end;

function foo2(a : integer; c : string) : y; 
begin
   while a do
       bar()
end;

function foo3(a, b : integer) : s; forward;

begin
	z := foo3(3)
end.