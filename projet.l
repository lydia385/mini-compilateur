%{
  #include<stdio.h>
  #include<string.h>
  #include "projetSynt_.tab.h" 
int  nbligne = 1;
int  col = 0;
 extern YYSTYPE yylval;
%}
lettres [a-z]
chiffres [0-9]
idf [a-z]("_"|[a-z]|{chiffres})([a-z]|{chiffres})+
int1  "-"?{chiffres}+
float1 "-"?({chiffres}+)(".")({chiffres}+)
NL (\r\n)|(\n)
SPACES [ \t]+
TEXT ({chiffres}|{lettres})
Type (Pfloat)|(Pint)

FC \/\*
DC \*\/
comment1 \/\*(.|\n)*\*\/
comment2 \/\/.*\n

%%
@define    {col=col+yyleng;return define;}
Program    {col=col+yyleng;return program;}
PDEC       {col=col+yyleng;return pdec;}
PINST      {col=col+yyleng;return pinst;}
{Type}       {col=col+yyleng;yylval.car=yytext[1];return Type;}
     
Begin      {col=col+yyleng;return begin;}
End        {col=col+yyleng;return end;}
FOR        {col=col+yyleng;return for1;}
WHILE      {col=col+yyleng;return while1;}
DO         {col=col+yyleng;return do1;}
IF         {col=col+yyleng;return if1;}
ELSE       {col=col+yyleng;return else1;}
ENDELSE    {col=col+yyleng;return endelse;}
ENDFOR     {col=col+yyleng;return endfor;}
{int1}     {yylval.num=atoi(yytext);
        if ( (yylval.num>-32769)&&(yylval.num<32768)) 
        {yylval.num=atoi(yytext);col=col+yyleng; return int1;}
        else printf("erreur lexicale la valeur de l'entier depasse la plage specifiee"); return int1;}
{float1}   {yylval.numf=atof(yytext);return float1;}
{idf}      {if (yyleng<=12) {yylval.str=strdup(yytext);return idf;} }
":"        {col+=yyleng;return dpt;}
"-"        {col+=yyleng;return moins;}
"+"        {col+=yyleng;return plus;}
"="        {col+=yyleng;return eg;}
"*"        {col+=yyleng;return etoile;}
"/"        {col+=yyleng;return div1;}
"<="       {col+=yyleng;return infeg;}
"<--"      {col+=yyleng;return affe;}
"<"        {col+=yyleng;return inf;}
">"        {col+=yyleng;return sup;}
"=="       {col+=yyleng;return egeg;}
">="       {col+=yyleng;return supeg;}
"!="       {col+=yyleng;return noteg;}
" &  "        {col+=yyleng;return et;}
" | "        {col+=yyleng;return ou;}
";"        {col+=yyleng;return ptveg;}
")"        {col+=yyleng;return pf;}
"("        {col+=yyleng;return pd;}
{NL}       { nbligne++;col=0;}
{SPACES}   { col+= yyleng;   }

{comment1} {char* str = yytext;
            int i = 0;
            char *pch=strchr(str,'\n');
            while (pch!=NULL) {
                  i++;
                  pch=strchr(pch+1,'\n');
                  }
            nbligne+=i;
            col=0;
            }
{comment2} {nbligne++; col=0;}
.        {printf("erreur lexiqual ligne %d collone %d \n",nbligne,col);col+=yyleng;}
%%
int yywrap(void)
{
return 0;
}