lex a1.l
yacc -d a2.y
gcc lex.yy.c y.tab.c -w
./a.out