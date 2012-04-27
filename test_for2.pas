{
	Use this program to test your lexer
}
	
program lexer_test;

type
	int = integer;

var
	i, j, k : integer;
	b : boolean;

function foo(x : integer) : integer; forward;

procedure bar(x : int); forward;

begin
	for i := 0 to 1 + 1 do
		begin
			i := i + 2;
			bar(i + 3 * 4);
			if foo(5 + i) = 6 then i := i + 7;
			for j := 8 * (8 + 8) to (9 + 9) * 9 do
				for k := 10 to 11 do i := j + 12;  {j is not declared}
			;
		end
	;
end.

