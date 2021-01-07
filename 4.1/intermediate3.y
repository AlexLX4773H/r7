%{

	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>

	extern int yylex();
	void yyerror(char *s);
	
	int tempcount=0;
	int elsecount=0;
	//char id1[10]="";
	//char id2[10]="";
	
	//char expr01[50]="";

	char *id1;
	char *id2;
	char *expr01;
	extern FILE *yyout;				
%}

%union
{
	char id[30];
}
%token<id> IF THEN ELSE WHILE

%token<id> ID NUMBER 
%type<id> expr Z Y X

%left '-' '+'  
%left '*' '/'

%left '>' '<'

%start start 

%%
start : Z'\n' {	fclose(yyout); exit(0);	}

Z	:	ID '=' expr {	fprintf(yyout,"%s := %s\n",$1 , $3);	}
	| IF Y THEN ID '=' expr ELSE {elsecount=tempcount;} ID '=' expr {fprintf(yyout,"%s := %s\n",$1,$3);fprintf(yyout,"if %s %s %s then goto t1 else goto t%d\n",id1,expr01,id2,elsecount);}
	| WHILE X THEN ID '=' expr{fprintf(yyout,"%s := %s\n",$4 , $6);fprintf(yyout,"if %s %s %s then goto t1\n",id1,expr01,id2);}
	
Y	:	ID '<' NUMBER	{id1=$1;id2=$3;expr01=$1+"<"+$3;}
	|	ID '>' NUMBER	{id1=$1;id2=$3;expr01=$1+">"+$3;}
	
X	:	ID '<' NUMBER	{id1=$1;id2=$3;expr01=$1+"<"+$3;}
	|	ID '>' NUMBER	{id1=$1;id2=$3;expr01=$1+">"+$3;}

	
	
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

