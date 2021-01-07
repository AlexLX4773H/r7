%{

	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>

	extern int yylex();
	void yyerror(char *s);
	
	int tempcount=0;
	int exe1=0;

	extern FILE *yyout;				
%}

%union
{
	char id[30];
}
%token<id> IF THEN ELSE WHILE

%token<id> ID NUMBER 
%type<id> expr Y X

%left '-' '+'  
%left '*' '/'
%start start 

%%
start : ID '=' expr'\n' {	fprintf(yyout,"%s := %s\n",$1 , $3); fclose(yyout); exit(0);	}
	| IF  Y  THEN ID '=' expr ELSE {exe1=tempcount+1;fprintf(yyout,"else goto t%d\n",exe1);} ID '=' expr'\n' {fprintf(yyout,"%s := %s\n",$1 , $3); fclose(yyout); exit(0);}
	| WHILE X THEN ID '=' expr'\n'{fprintf(yyout,"%s := %s\n",$1 , $3); fclose(yyout); exit(0);}
	
Y	:	ID '<' NUMBER	{fprintf(yyout,"if %s < %s then goto t1\n",$1,$3);}
	|	ID '>' NUMBER	{fprintf(yyout,"if %s > %s then goto t1\n",$1,$3);}
	
X	:	ID '<' NUMBER	{fprintf(yyout,"while %s < %s then goto t1\n",$1,$3);}
	|	ID '>' NUMBER	{fprintf(yyout,"while %s > %s then goto t1\n",$1,$3);}

expr : expr '+' expr	{ 	
     				tempcount+=1;
     				fprintf(yyout,"t%d := %s + %s\n",tempcount,$1,$3);	
				sprintf($$,"t%d",tempcount);
			}
     |	 expr '-' expr  {       
				tempcount+=1;
                                fprintf(yyout,"t%d := %s - %s\n",tempcount,$1,$3);
                                sprintf($$,"t%d",tempcount);
                        }
     |   expr '*' expr  {      
				tempcount+=1;
                                fprintf(yyout,"t%d := %s * %s\n",tempcount,$1,$3);
                                sprintf($$,"t%d",tempcount);
                        } 
      |  expr '/' expr  {       
				tempcount+=1;
                                fprintf(yyout,"t%d := %s / %s\n",tempcount,$1,$3);
                                sprintf($$,"t%d",tempcount);
                        }
     | '(' expr ')'	{
				tempcount+=1;
				fprintf(yyout,"t%d := %s\n",tempcount,$2);
				sprintf($$,"t%d",tempcount);
			}
     | '-' ID           {
				tempcount+=1;	
				fprintf(yyout,"t%d := -%s\n",tempcount,$2);
				sprintf($$,"t%d",tempcount);
			}
     | '-' NUMBER       {
				tempcount+=1;	
				fprintf(yyout,"t%d := -%s\n",tempcount,$2);
				sprintf($$,"t%d",tempcount);
			}

   

     | 	ID 		{;}
     |	NUMBER		{;}  


%%


void yyerror(char *s)
{
	fprintf(stdout,"Error generating code");
}

int main()
{
	yyout = fopen("output.txt","w");
	yyparse();
}

