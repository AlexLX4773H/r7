%{

	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>

	extern int yylex();
	void yyerror(char *s);
	
	int tempcount=0;
	int elsecount=0;
	char id1[10]="";
	char id2[10]="";
	
	char expr01[50]="";

	extern FILE *yyout;				
%}

%union
{
	char id[30];
}
%token<id> IF THEN ELSE WHILE

%token<id> ID NUMBER 
%type<id> expr Z

%left '-' '+'  
%left '*' '/'



%start start

%%
start : Z'\n' {	fclose(yyout); exit(0);	}

Z	:	ID '=' expr {	fprintf(yyout,"%s := %s\n",$1 , $3);	}
	| IF ID '<' NUMBER THEN ID '=' expr ELSE {id1=$2;id2=$4;elsecount=tempcount;} ID '=' expr {fprintf(yyout,"%s := %s\n",$1,$2);fprintf(yyout,"if %s less %s then goto t1 else goto t%d\n",id1,id2,elsecount);}
	| IF ID '>' NUMBER THEN ID '=' expr ELSE {id1=$2;id2=$4;elsecount=tempcount;} ID '=' expr {fprintf(yyout,"%s := %s\n",$1,$2);fprintf(yyout,"if %s greater %s then goto t1 else goto t%d\n",id1,id2,elsecount);}
	| WHILE ID '<' NUMBER THEN {id1=$2;id2=$4;} ID '=' expr{fprintf(yyout,"%s := %s\n",$1 , $2);fprintf(yyout,"if %s less %s then goto t1\n",id1,id2);}
	| WHILE ID '>' NUMBER THEN {id1=$2;id2=$4;} ID '=' expr{fprintf(yyout,"%s := %s\n",$1 , $2);fprintf(yyout,"if %s great %s then goto t1\n",id1,id2);}
	
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

