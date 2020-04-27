%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"

FILE  *yyin;

int i=0;
int k=0;

void crearTabladeSimbolosEnUnArchivo();
void guardarLexemas(char *,int);
void guardarTabladeSimbolo(char *);
int buscar(char *);
void capturaTipo(char *);


typedef struct {
       		    char nombre[50]; /* El nombre hace referencia al lexema del token*/
                char tipoDato[100];				
                char  valor[30];	
				char longitud[25];
	            } tsimbolos;
				
/*Se especifica un limite de 100 registros para el tamaño de la tabla de simbolos
 tal que pueda guardar hasta 100 lexemas.*/
tsimbolos ts[100];

%}

%option noyywrap  
%option yylineno 

DIGITO [0-9]
LETRA  [a-zA-Z]
ID     {LETRA}({LETRA}|{DIGITO}|"_")*
CONST_INT       {DIGITO}+
CONST_REAL		{DIGITO}+"."{DIGITO}+|{DIGITO}*"."{DIGITO}+|{DIGITO}+"."{DIGITO}*
COMILLAS	   	"\""
ESPACIO			" "
CONST_STR       {COMILLAS}({LETRA}|{DIGITO}|{ESPACIO}|_|@|%)*{COMILLAS}
COMENT_SIMPLE	"**/"({LETRA}|{DIGITO}|_|{ESPACIO}|":"|"="|"."|"+"|"("|")"|"["|"]"|",")*"/**"
COMENT_DOBLE	"**/"({LETRA}|{DIGITO}|_|{ESPACIO}|":"|"="|"."|"+"|"("|")"|"["|"]"|","|{COMENT_SIMPLE})*"/**"


FLOAT			"FLOAT"|"float"|"Float"
INTEGER			"INTEGER"|"integer"|"Integer"
STRING			"STRING"|"string"|"String"

IF     "IF"|"if"
ENDIF   "endif"|"ENDIF"
THEN       "THEN"|"then"
ELSE       "ELSE"|"else"
REPEAT  "repeat"|"REPEAT"
ENDREPEAT "endrepeat"|"ENDREPEAT"
DIV "/"|"DIV"|"div"
DO "DO" | "do"
CASE "CASE" | "case"
DEFAULT "DEFAULT" | "default"
ENDDO   "ENDDO" | "enddo"

AND "AND"|"and"
OR "OR"|"or"
NOT "NOT"|"not"
PUT "PUT"|"put"
GET "GET"|"get"

%%

"VAR"			{ return VAR; }
"DEC"			{ return DEC; }
"AS"			{ return AS; }
"ENDVAR"		{ return ENDVAR; }
"BEGINP"		{ return BEGINP; }
"ENDP"			{ return ENDP; }
"DO"			{ return DO; }
"CASE"			{ return CASE; }
"DEFAULT"		{ return DEFAULT; }
"ENDDO"			{ return ENDDO; }

{FLOAT}			{capturaTipo(yytext); return FLOAT; }
{INTEGER}		{capturaTipo(yytext);return INTEGER; }
{STRING}		{capturaTipo(yytext);return STRING;}
{IF}			{ return IF; }
{THEN}			{ return THEN; }
{ELSE}			{ return ELSE; }
{ENDIF}			{ return ENDIF; }
{AND}      	 	{ return AND; }
{OR}        	{ return OR; }
{NOT}       	{ return NOT; }
{ENDIF}			{ return ENDIF; }
{REPEAT}        { return REPEAT; }
{ENDREPEAT}     { return ENDREPEAT; }

			
{DIV}	    { return DIV; }
{PUT}	    { return PUT; }
{GET}	    { return GET; }
{COMENT_SIMPLE}	{  }
{COMENT_DOBLE}	{  }

"=="		{ return COMP_IGUAL; }
"!="		{ return COMP_DIST; }
"<"			{ return MENOR; }
">"			{ return MAYOR; }
"<="		{ return COMP_MENIG; }
">="		{ return COMP_MAYIG; }



{CONST_STR}		{
                    int longitud=strlen(yytext);
					if(longitud <= 30)
					{
					 guardarLexemas(yytext,1);
                     return CONST_STR;
					 }
					else{
						printf("Error. Se ha excedido del rango establecido para las constantes String.Programa Finlizado\n");
						printf("Pulse una tecla para cerrar la consola\n");
						system ("Pause");
						exit(1);
					} 
			    }
				

{CONST_INT}		{	int num = atoi(yytext); 
					
					/*Un entero de 16 bits puede almacenar (65536) valores diferentes*/
					if(num >= 0 && num <= 65536){
						
						 guardarLexemas(yytext,2);
						  
						return CONST_INT; 
					}
					else	{
						printf("Error. Se ha excedido del rango establecido para las constantes Enteras.Programa Finlizado.\n");
						printf("Pulse una tecla para cerrar la consola\n");
						system ("Pause");
						exit(1);
					} 
				}
				
{CONST_REAL}	{	double num = atof(yytext);

					/* Un Float de 32 bits puede almacenar 0 hasta 4.294.967.295 valores diferentes*/
					double cotaMayor = (3.4)*(exp(38));
					
					if(num >= 0 && num <= cotaMayor){
					 guardarLexemas(yytext,3);
					 
						return CONST_REAL; 
					}
					else{
						printf("Error. Se ha excedido del rango establecido para las constantes Flotantes.Programa Finalizado\n");
				 		system ("Pause");
						exit(2);
					}
				}

{ID}   			{	double num = atof(yytext);

					/* Un entero puede almacenar entre -32768 y 32767 valores diferentes*/
					double cotaMenor = -32768;
					double cotaMayor = 32767;
					
					if(num >= cotaMenor && num <= cotaMayor){
					 guardarLexemas(yytext,0);
					 	return ID; 
					}
					else{
						printf("Error. Se ha excedido del rango establecido por los enteros.Programa Finlizado\n");
				 		system ("Pause");
						exit(2);
					}
				}

","			{ return COMA;}
":="		{ return ASIG; }
":"			{ return DOS_PUNTOS; }
"["			{ return CORCH_ABIER; }
"]"			{ return CORCH_CERR; }
","			{ return COMA; }
"+"			{ return SUMA; }
"-"			{ return RESTA; }
"*"			{ return MULTIPLICACION; }
"/"|"DIVISION"	{ return DIVISION; }
"("			{ return PA; }
")"			{ return PC; }


"\n"      		
"\t"
" "	
"\r\n" 
%%

void crearTablaDeSimbolosEnUnArchivo()
{
FILE* arch; 
int x;
 
    arch = fopen("ts.txt", "w+");
	
	if (!arch){
		printf("Error. No se pudo crear el archivo ts.txt");
	exit(1);
	}
	fprintf(arch,"%-23s%-15s%-28s%8s\n","Nombre","TIPODATO","VALOR","LONGITUD");
	for(x=0;x<i;x++){

	fprintf(arch,"%-23s%-15s%-20s%8s",ts[x].nombre,ts[x].tipoDato,ts[x].valor,ts[x].longitud);
	fprintf(arch,"\n");
	}
    
	 fclose(arch);    
}
 
void guardarLexemas(char *nombre,int val)
{
  
     if(val==0)
	{
      
	   if(buscar(nombre)!=0)
	   {
	      strcpy(ts[i].nombre,nombre);
		  i++;//incremento para conocer la cantidad de id que hay en la ctes
	   } 
	 
	
	}
    if(val==1)
	{
	    char *s=nombre;
		*s++;//adelanto el puntero para que no tome la 1eras comillas
		int n=strlen(nombre)-2;//le resto 2 para que no copie las comillas (iniciales y finales)
		strncpy(nombre,s,n);
		while(n > 1)//llevo el puntero hasta la posicion que debe finalizar el string 
		{
			n--;
		    s++;
		}
	    memset(s, '\0',n);//marco el fin del string
		
	  if(buscar(nombre)!=0)
	  {
	   
	   strcpy(ts[i].nombre,"_");
       strcat(ts[i].nombre,nombre);;
	   strcpy(ts[i].valor,nombre);
	   itoa(strlen(nombre),ts[i].longitud,10);	
        i++;//incremento para conocer la cantidad de id que hay en la ctes				   
      }
	
	} 
   if(val==2)
	{

    if(buscar(nombre)!=0)
	 {
	   strcpy(ts[i].nombre,"_");
       strcat(ts[i].nombre,nombre);
	   strcpy(ts[i].valor,nombre);
	 
	    i++;//incremento para conocer la cantidad de id que hay en la ctes
      }
			
    
	}
     if(val==3)
	{

    if(buscar(nombre)!=0)
	 {
	   strcpy(ts[i].nombre,"_");
       strcat(ts[i].nombre,nombre);
	   strcpy(ts[i].valor,nombre);
	   i++;//incremento para conocer la cantidad de id que hay en la ctes
      }
			
    
	}	
	      
}

/*Recorro la tabla buscando si existe el lexema, caso contrario lo guarda en la tabla si retorna 1*/

int buscar(char * nombre)
{
 int x;
 
  for(x=0;x<i;x++){ 
  if(strcmp(ts[x].nombre,nombre)==0)  
   return 0;  
  }
   return 1;
}



void capturaTipo(char * tvar)
 {
	strcpy(ts[k].tipoDato,tvar);
	k++;
}