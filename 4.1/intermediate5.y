%{

	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>

	extern int yylex();
	void yyerror(char *s);
	
	int tempcount=0;
	int exe1=0;
	int count=0;
	
	char ex1[20];

	extern FILE *yyout;				
%}

%union
{
	char id[30];
}
%token<id> IF THEN ELSE WHILE

%token<id> ID NUMBER 
%type<id> expr Y

%left '-' '+'  
%left '*' '/'
%start start 

%%
start : ID '=' expr'\n' {	fprintf(yyout,"%s := %s\n",$1 , $3); fclose(yyout); exit(0);	}
	| IF  Y  THEN ID '=' expr ELSE {exe1=count+1;count+=1;fprintf(yyout,"%d:\t",count);fprintf(yyout,"%s := %s\n",$4 , $6);fprintf(yyout,"else goto %d\n",exe1);} ID '=' expr'\n' {count+=1;fprintf(yyout,"%d:\t",count);fprintf(yyout,"%s := %s\n",$1 , $3); fclose(yyout); exit(0);}
	| WHILE ID '<' NUMBER THEN ID '=' expr'\n'{count+=1;fprintf(yyout,"%d:\t",count);fprintf(yyout,"%s := %s\n",$6 , $8);fprintf(yyout,"while %s < %s goto 1\n",$2,$4); fclose(yyout); exit(0);}
	| WHILE ID '>' NUMBER THEN ID '=' expr'\n'{count+=1;fprintf(yyout,"%d:\t",count);fprintf(yyout,"%s := %s\n",$6 , $8);fprintf(yyout,"while %s > %s goto 1\n",$2,$4); fclose(yyout); exit(0);}
	
Y	:	ID '<' NUMBER	{fprintf(yyout,"if %s < %s goto 1\n",$1,$3);strcpy($1,ex1);}
	|	ID '>' NUMBER	{fprintf(yyout,"if %s > %s goto 1\n",$1,$3);}

expr : expr '+' expr	{ 	
     				tempcount+=1;
     				count+=1;
     				fprintf(yyout,"%d:\t",count);
     				fprintf(yyout,"t%d := %s + %s\n",tempcount,$1,$3);	
				sprintf($$,"t%d",tempcount);
			}
     |	 expr '-' expr  {       
				tempcount+=1;count+=1;
     				fprintf(yyout,"%d:\t",count);
                                fprintf(yyout,"t%d := %s - %s\n",tempcount,$1,$3);
                                sprintf($$,"t%d",tempcount);
                        }
     |   expr '*' expr  {      
				tempcount+=1;count+=1;
     				fprintf(yyout,"%d:\t",count);
                                fprintf(yyout,"t%d := %s * %s\n",tempcount,$1,$3);
                                sprintf($$,"t%d",tempcount);
                        } 
      |  expr '/' expr  {       
				tempcount+=1;count+=1;
     				fprintf(yyout,"%d:\t",count);
                                fprintf(yyout,"t%d := %s / %s\n",tempcount,$1,$3);
                                sprintf($$,"t%d",tempcount);
                        }
     | '(' expr ')'	{
				tempcount+=1;count+=1;
     				fprintf(yyout,"%d:\t",count);
				fprintf(yyout,"t%d := %s\n",tempcount,$2);
				sprintf($$,"t%d",tempcount);
			}
     | '-' ID           {
				tempcount+=1;count+=1;
     				fprintf(yyout,"%d:\t",count);	
				fprintf(yyout,"t%d := -%s\n",tempcount,$2);
				sprintf($$,"t%d",tempcount);
			}
     | '-' NUMBER       {
				tempcount+=1;count+=1;
     				fprintf(yyout,"%d:\t",count);	
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

