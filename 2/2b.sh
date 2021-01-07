lex b1.l
yacc -d b2.y
gcc lex.yy.c y.tab.c -w
./a.out