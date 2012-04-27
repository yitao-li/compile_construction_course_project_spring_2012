{
	Use this program to test your lexer
}
	
program lexer_test;

type
  int = integer;

var
  i, j : integer;
  b : boolean;

function foo(x : integer) : integer; forward;

procedure bar(x : int); forward;

begin
  for i := 0 to 3 do i := i + 1;
  for j := 0 to 4 do i := i + 1;  {j is not declared}
end.

