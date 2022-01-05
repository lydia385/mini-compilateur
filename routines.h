#include <stdio.h>
#include <stdlib.h>
#include<string.h>
typedef struct element{
 char name[20];
 char type[20]; // i=int , f=float
 char nature; // v=var , c=cste 
 struct element *next;
}element;

typedef struct element *Liste;
Liste list=NULL;

void push_end(char n[],char ty,char nat){
    Liste tete, temp;
    tete = (struct element*)malloc(sizeof(struct element));
    if(list == NULL )
    {
        list = tete;
        strcpy(list->name,n);
        if(ty=='i'){ strcpy(list->type,"Pint");  }
        else if(ty=='f'){strcpy(list->type,"Pfloat");}  
        list->nature= nat;
        list->next = NULL;
        return;
    }
    temp = list;
    while(temp->next != NULL)
    {
        temp = temp->next;
    }
        temp->next = tete;
        strcpy(tete->name,n);
        if(ty=='i'){strcpy(tete->type,"Pint");}
        else if(ty=='f'){strcpy(tete->type,"Pfloat");}
        tete->nature= nat;
        tete->next = NULL;
        }
Liste search (char name[]){
   Liste l = list;
    while((l!= NULL) && (strcmp(l->name,name) != 0)){
           l = l->next;}
   return l;
}
void push(char name[],char ty,int nat)
    {
     if (search(name) == NULL) push_end(name,ty,nat); 
     else {
         printf("erreur : double declaration de %s \n", name);
     }
     }
     

void display()
{
    struct element *tete;
    tete = list;
    if(tete == NULL)
    {
        printf("La liste est vide.");
    }
    else
    {
     printf("\n/=========Table des symboles =============/\n");
     printf("_____________________________________\n");
     printf("|      Nom      |   Type  |  nature |    \n");
     printf("_____________________________________\n");
     while(tete != NULL)
     {
         printf("|%14s |%8s | %7c |  \n",tete->name,tete->type,tete->nature);
         tete = tete->next;
     }
     printf("_____________________________________\n");
    }
}