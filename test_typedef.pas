program errorfree;
type
	i = integer;
	int = i;
	j = i;
	k = int;
	l = int;
	h = l;
	s = string;
	rs = s;
	r = record
		a,b : integer;
		c   : s
	end;
	y = array[1..10] of r;
	R = record
		u,v : l;
		str : string
	end;
	S = record
		uu, vv : i;
		str1 : string;
		str2 : rs
	end;
var
	z : s;
	rec : r;
	REc : R;
	SS : S;

function foo1(a : integer) : r; 
begin
   REc := rec;
   SS := rec;
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
