%{
	FILE *fp, *fi;
%}


%%

"False"|"await"|"else"|"import"|"pass"|\None|"break"|"except"|"in"|"raise"|"True"|\class|"finally"|"is"|"return"|"and"|"for"|\continue|"lambda"|"try"|"as"|"def"|"from"|"nonlocal"|\while|"assert"|"del"|"global"|"not"|"async"|"range"|\with|"elif"|"if"|"or"|\yield|"print"     {   fprintf(fp," TOKEN <KEYWORD>     %s \n",yytext);	       }

"="         {   fprintf(fp," TOKEN <ASSIGN_OP>   %s \n",yytext);		   }
"+"         {   fprintf(fp," TOKEN <ADD_OP>      %s \n",yytext);		   }
"-"         {   fprintf(fp," TOKEN <SUB_OP>      %s \n",yytext);		   }
"*"         {   fprintf(fp," TOKEN <MUL_OP>      %s \n",yytext);		   }
"/"         {   fprintf(fp," TOKEN <DIV_OP>      %s \n",yytext);		   }
"%"         {   fprintf(fp," TOKEN <MOD_OP>      %s \n",yytext);		   }
"88"        {   fprintf(fp," TOKEN <EXP_OP>      %s \n",yytext);		   }

\".*\"      {   fprintf(fp," TOKEN <STRING>      %s \n",yytext);           }
"#"(.*)\n   { char *commenttext = strdup(yytext);commenttext[0]=' ' ; fprintf(fp," TOKEN <COMMENT>   %s \n",commenttext);          }
[(|)|:]       /*brackets & colon*/

\<= |
\>= |
\< |
\> |
==          { fprintf(fp," TOKEN <RELOP>       %s \n",yytext);  }

[0-9][0-9]* { fprintf(fp," TOKEN <NUMBER>      %s \n",yytext);	 }
[\n]        { fprintf(fp,"\n");					             }
[a-zA-Z]([a-zA-Z]|[0-9]|[_])* { fprintf(fp," TOKEN <IDENTIFIER>  %s \n",yytext); }

":exit"     { fclose(fp); exit(0); 			                        }
		
%%

int yywrap(){}

int main(int argc , char*argv[])
{
    fi = fopen("1py.txt","r+");
    if(!fi){
        printf("File not found");
        exit(0);
    }
    yyin = fi;
	fp = fopen("output.txt","w");
	yylex();
}

