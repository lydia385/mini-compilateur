%{
#include<stdio.h>
#include "routines.h"
extern int  nbligne;
extern int col;
int yyparse();
int yylex();
int yyerror(char *s);
char natureidf;
char vType='n';
char sauvOP[20];
int vInt;
float vFloat;
char typeidf;
char tempidf[20];
FILE *yyin;
%}
%start S 
%union {
int num;
float numf;
char car;
char* str;
}  
%token dpt moins plus etoile inf sup egeg infeg supeg noteg et ou ptveg eg begin '|'
%token pf pd affe while1 for1 do1 else1 <car>Type endfor endelse program pdec define if1 div1 end pinst
%token <str>idf <str>com <num>int1 <numf>float1 

%%
S: program idf pdec listedec pinst begin listeinst end  { printf ("\n programme syntaxiquement juste");YYACCEPT ;};
listedec : dec listedec 
    | define decConst ptveg listedec 
    | ;
decConst : Type idf eg value {
    
    if($1!=vType){
        printf("Symentic error : you are trying to assing type %s to %s : %s a la ligen %d , la colonne %d\n",vType=='i'?"Pint":"Pfloat",$2,$1=='i'?"Pint":"Pfloat",nbligne,col);
        }else if($1 =='i')push($2,'i','c'); 
        else push($2,'f','c'); 
    
    }

dec : idf decOp dpt Type ptveg 
{ 
push($1,$4,'v');
if (search(tempidf) == NULL )
    {
        push(tempidf,$4,'v');
    }
}
decOp: ou idf decOp { strcpy(tempidf,$2);} | ;

listeinst : aff ptveg listeinst
    | boucle listeinst
    | cond listeinst 
    | ;
 
value: int1 {vType='i'; vInt=$1;}|float1{vType='f'; vFloat=$1;};
operant : idf 
{
    if (search($1)  == NULL)
    {
         printf("Symentic error : NON DECLAREE a la ligen %d , la colonne %d\n",nbligne,col);
    }
}
    | value ;
    
aff : idf affe operant exarth  {
    if (search($1)  == NULL)
    {
         printf("Symentic error : NON DECLAREE a la ligen %d , la colonne %d\n",nbligne,col);
    }
    else {

        if (search($1)->type[1]  != vType)
        {
            printf("Symentic error : you are trying to assing type %s to %s la ligen %d , la colonne %d\n",vType=='i'?"Pint":"Pfloat",$1,nbligne,col);
        }

        if (search($1)->nature  == 'c')
        {
            printf("Symentic error : you are trying to change the value of a const la ligen %d , la colonne %d\n",nbligne,col);
        }
    }

} ;

exarth : operations operant exarth 
    |  { 
        if((strcmp(sauvOP,"/")==0) & (vInt == 0 || vFloat ==0)){
            printf("erreur :division par zero a la ligen %d , la colonne %d\n",nbligne,col);
        }
    }
operations : moins
    | etoile
    | plus
    | div1 {strcpy(sauvOP,"/");}

 
boucle : for1 idf affe operant while1 operant do1 listeinst endfor
{
    if (search($2)  == NULL)
    {
         printf("Symentic error : NON DECLAREE a la ligen %d , la colonne %d\n",nbligne,col);
    }
    else {

        if (search($2)->type[1]  != vType)
        {
            printf("%c",search($2)->type[0]);
            printf("Symentic error : you are trying to assing type %s to %s \n",vType=='i'?"Pint":"Pfloat",$2);
        }
    }
}

cond : do1 listeinst if1 pd explg pf ElseCond;
ElseCond: else1 listeinst endelse
    | ;
explg : pd explg pf
    | noteg pd explg pf
    | expcmp explgOP
    | ;

explgOP : 
    | ou explg
    | et explg;
expcmp : operant cmpType operant ;
cmpType: sup 
    | inf 
    | egeg 
    | infeg 
    | supeg;
%% 
int yyerror(char* msg)
{printf("%s ligne %d et colonne %d \n",msg,nbligne,col);
return 0;
}
int main(int argc, char *argv[])  {
yyin = fopen(argv[1], "r");
    if (yyin == NULL)
        printf("File doesn't exist");
    else{
        
        yyparse();
    }
     display();
return 0;

}