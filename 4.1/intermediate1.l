%{
	#include<stdio.h>
	#include "y.tab.h"
%}

%%

if                 {return IF;}
then               {return THEN;}
else               {return ELSE;}
while		{return WHILE;}

[0-9]+	{ strcpy(yylval.id,yytext); return NUMBER; }
[a-z]+	{ strcpy(yylval.id,yytext); return ID;	   }
[+|\-|*|\/|(|)|\=]	{ return *yytext;	}
[\n]			{ return *yytext;	}
[\<|\>]			{ return *yytext;	}
%%

int yywrap()
{
	return 1;
}
