%{

	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>

	extern int yylex();
	void yyerror(char *s);
	
	int tempcount=0;
    int Lcount=1;
    int Scount=1;
    int k=0;
    int L=0;
    int flag=0;
    int assignflag=0;
    int Forflag=0;

	extern FILE *yyout;				
%}

%union
{
	char id[30];
}
%token<id> ID NUMBER WHILE GE LE FOR IF THEN ELSE EQ
%type<id> expr 
%type<id> cond

%left '-' '+'  
%left '*' '/'
%start start 

%%
start : ID '=' expr'\n' {	
                            fprintf(yyout,"%s := %s\n",$1 , $3); 
                            fclose(yyout); 
                            exit(0);	
                        }
     |
         WHILE '(' cond ')''\n'expr'\n' {
                                    L = --Lcount;
                                    fprintf(yyout,"goto L%d : \n",L);
                                    fprintf(yyout,"L%d : \n",Scount);
                                    fclose(yyout);
                                    exit(0);
                                 }
     |   IF {flag = 1;}'(' cond ')' '\n' expr '\n' ELSE '\n' expr '\n' {
                                    L = --Lcount;
                                    fprintf(yyout,"L%d : \n",Scount);
                                    fclose(yyout);
                                    exit(0);
                                 }
     |   FOR {Forflag = 1;}'(' expr {fprintf(yyout,"L%d :\n",Lcount++);}';' cond ';' expr {fprintf(yyout,"goto L%d : \nL%d : \n",L+1,L+3);}')' '\n' expr{fprintf(yyout,"goto L%d : \n",L+4);}'\n' {
                                    L = --Lcount;
                                    fprintf(yyout,"L%d : \n",Scount);
                                    fclose(yyout);
                                    exit(0);
                                }

cond : expr GE expr	        { 	    if((flag != 1) && (Forflag != 1 )){
                                    fprintf(yyout,"L%d :\n",Lcount++);}
                                    tempcount+=1;
     				                fprintf(yyout,"t%d := %s \n",tempcount,$1);	
                                    k = tempcount + 1;
                                    fprintf(yyout,"t%d := %s \n",k,$3); 
                                    fprintf(yyout,"t%d = not t%d\n",tempcount,k);
                                    fprintf(yyout,"if t%d goto L%d\n",tempcount,Lcount);
                                    if(Forflag == 1){
                                    fprintf(yyout,"goto L%d\n",Lcount+1);
                                    fprintf(yyout,"L%d :\n",Lcount+2);
                                    Forflag = 0;
                                    }
                                    tempcount+=1;
				                    sprintf($$,"t%d",tempcount);
                                    Scount = tempcount;
			                    }
     | expr LE expr         { 	
                                    if((flag != 1) && (Forflag != 1 )){
                                    printf("%d,%d",flag,Forflag);
                                    fprintf(yyout,"L%d :\n",Lcount++);}
                                    tempcount+=1;
     				                fprintf(yyout,"t%d := %s \n",tempcount,$1);	
                                    k = tempcount + 1;
                                    fprintf(yyout,"t%d := %s \n",k,$3); 
                                    fprintf(yyout,"t%d = not t%d\n",tempcount,k);
                                    fprintf(yyout,"if t%d goto L%d\n",tempcount,Lcount);
                                    if(Forflag == 1){
                                    fprintf(yyout,"goto L%d\n",Lcount+1);
                                    fprintf(yyout,"L%d :\n",Lcount+2);
                                    Forflag = 0;
                                    }
                                    tempcount+=1;
				                    sprintf($$,"t%d",tempcount);
                                    Scount = tempcount;
			                    }
     | expr EQ expr         { 	
                                    if((flag != 1) && (Forflag != 1 )){
                                    fprintf(yyout,"L%d :\n",Lcount++);}
                                    tempcount+=1;
     				                fprintf(yyout,"t%d := %s \n",tempcount,$1);	
                                    k = tempcount + 1;
                                    fprintf(yyout,"t%d := %s \n",k,$3); 
                                    fprintf(yyout,"t%d = not t%d\n",tempcount,k);
                                    fprintf(yyout,"if t%d goto L%d\n",tempcount,Lcount);
                                    if(Forflag == 1){
                                    fprintf(yyout,"goto L%d\n",Lcount+1);
                                    fprintf(yyout,"L%d :\n",Lcount+2);
                                    Forflag = 0;
                                    }
                                    tempcount+=1;
				                    sprintf($$,"t%d",tempcount);
                                    Scount = tempcount;
			                    }
expr :   expr '+' expr	        { 	
     				                tempcount+=1;
     				                fprintf(yyout,"t%d := %s + %s\n",tempcount,$1,$3);	
                                    if(assignflag != 1){
                                    if(flag == 1){fprintf(yyout,"goto L%d :\n",Lcount);flag=0;}
                                    if(Forflag == 1){fprintf(yyout,"goto L%d :\n",Lcount);Forflag = 0;}}
				                    sprintf($$,"t%d",tempcount);
			                    }
     |	 expr '-' expr          {       
				                    tempcount+=1;
                                    fprintf(yyout,"t%d := %s - %s\n",tempcount,$1,$3);
                                    if(assignflag != 1){
                                    if(flag == 1){fprintf(yyout,"goto L%d :\n",Lcount);flag=0;}
                                    if(Forflag == 1){fprintf(yyout,"goto L%d :\n",Lcount);Forflag = 0;}}
                                    sprintf($$,"t%d",tempcount);
                                }
     |   expr '*' expr          {      
				                    tempcount+=1;
                                    fprintf(yyout,"t%d := %s * %s\n",tempcount,$1,$3);
                                    if(assignflag != 1){
                                    if(flag == 1){fprintf(yyout,"goto L%d :\n",Lcount);flag=0;}
                                    if(Forflag == 1){fprintf(yyout,"goto L%d :\n",Lcount);Forflag = 0;}}
                                    sprintf($$,"t%d",tempcount);
                                } 
      |  expr '/' expr          {       
				                    tempcount+=1;
                                    fprintf(yyout,"t%d := %s / %s\n",tempcount,$1,$3);
                                    if(assignflag != 1){
                                    if(flag == 1){fprintf(yyout,"goto L%d :\n",Lcount);flag=0;}
                                    if(Forflag == 1){fprintf(yyout,"goto L%d :\n",Lcount);Forflag = 0;}}
                                    sprintf($$,"t%d",tempcount);
                                }
      |  expr '='{assignflag = 1;} expr          {       
                                    fprintf(yyout,"%s := t%d \n",$1,tempcount);
                                    if(flag == 1){fprintf(yyout,"goto L%d :\n",Lcount+1);fprintf(yyout,"L%d :\n",Lcount);flag=0;}
                                    assignflag = 0;
                                    sprintf($$,"t%d",tempcount);
                                }
     | '(' expr ')'	            {
				                    tempcount+=1;
				                    fprintf(yyout,"t%d := %s\n",tempcount,$2);
                                    if(assignflag != 1){
                                    if(flag == 1){fprintf(yyout,"goto L%d :\n",Lcount);flag=0;}
                                    if(Forflag == 1){fprintf(yyout,"goto L%d :\n",Lcount);Forflag = 0;}}
				                    sprintf($$,"t%d",tempcount);
			                    }
     | '-' ID                   {
				                    tempcount+=1;	
				                    fprintf(yyout,"t%d := -%s\n",tempcount,$2);
				                    sprintf($$,"t%d",tempcount);
			                    }
     | '-' NUMBER               {
				                    tempcount+=1;	
				                    fprintf(yyout,"t%d := -%s\n",tempcount,$2);
				                    sprintf($$,"t%d",tempcount);
                                }

     | 	ID 		                {;}
     |	NUMBER		            {;}  

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
