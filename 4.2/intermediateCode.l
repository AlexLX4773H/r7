%{
	#include<stdio.h>
	#include "y.tab.h"
%}

%%
"for"      { strcpy(yylval.id,yytext); return FOR;    }
"while"    { strcpy(yylval.id,yytext); return WHILE;  }             
"if"       { strcpy(yylval.id,yytext); return IF;     }          
"then"     { strcpy(yylval.id,yytext); return THEN;   }            
"else"     { strcpy(yylval.id,yytext); return ELSE;   }                  
"<="     { strcpy(yylval.id,yytext); return LE;     }    
">="     { strcpy(yylval.id,yytext); return GE;     }   
"=="     { strcpy(yylval.id,yytext); return EQ;     }
[0-9]+	 { strcpy(yylval.id,yytext); return NUMBER; }
[a-z]+	 { strcpy(yylval.id,yytext); return ID;	    } 
[+|\-|*|\/|(|)|\=]	{                return *yytext;}  
[\n]			    {                return *yytext;}
[\t]			    {                return *yytext;}
[ ]			        {                return *yytext;}
[;]			        {                return *yytext;}
%%

int yywrap()
{
	return 1;
}
