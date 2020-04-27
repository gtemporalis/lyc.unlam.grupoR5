%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include <errno.h>
#include "y.tab.h"

int yystopparser=0;
char * yytext;
                
FILE  *yyin;

%}

%token VAR
%token DEC
%token AS
%token ENDVAR
%token BEGINP
%token ENDP
%token DOS_PUNTOS
%token CORCH_ABIER
%token CORCH_CERR
%token INTEGER
%token STRING
%token FLOAT
%token REAL
%token COMA
%token ID 
%token ASIG
%token SUMA
%token RESTA
%token MULTIPLICACION
%token DIVISION
%token CONST_REAL
%token CONST_STR
%token CONST_INT
%token PA
%token PC
%token IF
%token THEN
%token ELSE
%token ENDIF
%token COMP_IGUAL
%token COMP_DIST
%token MENOR
%token MAYOR
%token COMP_MENIG
%token COMP_MAYIG
%token AND
%token OR
%token NOT
%token REPEAT
%token ENDREPEAT 
%token DIV
%token PUT
%token GET
%token DO
%token DEFAULT
%token CASE
%token ENDDO
%%
programa:   
		 declaracion inicio				{printf("\nCOMPILACION ok\n");}	
  ;
  
declaracion: VAR definiciones ENDVAR	{printf("Regla 1 - DECLARACION :VAR DEFINICIONES ENDVAR\n");}  
;

definiciones:definicion 				{printf("Regla 2 - DEC DEFINICIONES AS DEFINICION\n");} 
			|definiciones definicion 	{printf("Regla 3 - DEC DEFINICIONES AS DEFINICIONES DEC DEFINICION AS\n");} 
	;
definicion:DEC CORCH_ABIER lista_id CORCH_CERR AS CORCH_ABIER lista_tipo_dato CORCH_CERR 
										{printf("Regla 4 - DEC CORCH_ABIER LISTA_ID CORCH_CERR AS CORCH_ABIER LISTA_TIPO_DATO CORCH_CERR \n");}
	;           
inicio:	BEGINP lista_sentencias ENDP 	{printf("Regla 5 - INICIO:BEGIN LISTA_SENTENCIAS ENDP\n");} 
	;
lista_sentencias:sentencia 					 {printf("Regla 6 - LISTA_SENTENCIAS:SENTENCIA\n");}
				|lista_sentencias sentencia  {printf("Regla 7 - LISTA_SENTENCIAS: LISTA_SENTENCIAS ENTENCIA\n");}
;
sentencia:asignacion 						{printf("Regla 8 - SENTENCIA:ASIGNACION\n");}
          |asignacionmult					{printf("Regla 9 - SENTENCIA:ASIGNACIONMULT\n");}
		      |decision		  {printf("Regla 10 - SENTENCIA:DECISION\n");}
		      |interacion     {printf("Regla 11 - SENTENCIA:INTERACION\n");}
		      |entsal         {printf("Regla 12 - SENTENCIA:ENTSAL\n");}
          |case           {printf("Regla 55 - SENTENCIA:CASE\n");}

;

case: DO ID casesm DEFAULT ENDDO {printf("Regla 56 - SENTENCIA:CASE SIMPLE O MULTIPLE\n");}
;
casesm: CASE condicion  {printf("Regla 57 - CASE SIMPLE\n");} 
| casesm CASE condicion {printf("Regla 58 - CASE DOBLE\n");} 
;

asignacion: ID ASIG expresion 				{printf("Regla 14 - ASIGNACION:ID ASIG EXPRESION\n");}	 
            | asignacion ASIG expresion 				{printf("Regla 54 - ASIGNACION MULTIPLE:ID ASIG ... EXPRESION\n");}	        
;
asignacionmult:CORCH_ABIER lista_id CORCH_CERR ASIG CORCH_ABIER expresiones CORCH_CERR 
											{printf("Regla 15 - CORCH_ABIER lista_id CORCH_CERR ASIG CORCH_ABIER expresiones CORCH_CERR\n");}
;	  
lista_tipo_dato: tipo_dato					{printf("Regla 16 - DATO:TIPO_DATO\n");}
                |tipo_dato COMA lista_tipo_dato {printf("Regla 17 - LISTA_TIPO_DATO: LISTA_TIPO_DATO COMA LISTA_TIPO_DATO\n");}
; 
tipo_dato:INTEGER 				        {printf("Regla 18 - TIPO_DATO:INTEGER\n");}
          |STRING 						{printf("Regla 19 - TIPO_DATO:STRING\n");}
		  |FLOAT						{printf("Regla 20 - TIPO_DATO:FLOAT\n");}
;          
lista_id:ID   { printf("Regla 21 - LISTA_ID:ID\n");}
         |ID  COMA lista_id  { printf("Regla 22- LISTA_ID:ID COMA LISTA_ID\n");}
;

entsal: PUT CONST_STR   {printf("Regla 23 - ENTSAL CONST_STR\n");}
       |PUT ID          {printf("Regla 24 - ENTSAL ID\n");}
       |GET ID           {printf("Regla 25 - ENTSAL ID\n");}
;
expresiones: expresion COMA expresiones  	{printf("Regla 26 - EXPRESIONES: EXPRESION COMA EXPRESIONES \n");}
			|expresion						{printf("Regla 27 - EXPRESIONES: EXPRESION \n");}
;
decision:IF condicion THEN lista_sentencias ENDIF  {printf("Regla 28 - CONDICION: IF CONDICION THEN LISTA_SENTENCIAS ENDIF\n");}
         |IF condicion THEN lista_sentencias ELSE lista_sentencias ENDIF
             {printf("Regla 29 - CONDICION: IF CONDICION THEN LISTA_SENTENCIAS ELSE LISTA_SENTENCIAS ENDIF\n");}		 
;
condicion:condicion_simple {printf("Regla 30 - CONDICION: CONDICION_SIMPLE\n");}
          |condicion_doble {printf("Regla 31 - CONDICION: CONDICION_DOBLE\n");}
		  |NOT condicion_simple  {printf("Regla 32 - CONDICION:NOT CONDICION_SIMPLE\n");}
;
condicion_simple:expresion MAYOR expresion  {printf("Regla 33 - CONDICION_SIMPLE: EXPRESION MAYOR EXPRESION\n");}
                |expresion MENOR expresion  {printf("Regla 34 - CONDICION_SIMPLE: EXPRESION MENOR EXPRESION\n");}
                |expresion COMP_DIST expresion {printf("Regla 35 - CONDICION_SIMPLE: EXPRESION COMP_DIST EXPRESION\n");}
                |expresion COMP_IGUAL expresion {printf("Regla 36- CONDICION_SIMPLE: EXPRESION COMP_IGUAL EXPRESION\n");}
                |expresion COMP_MAYIG expresion {printf("Regla 37 - CONDICION_SIMPLE: EXPRESION COMP_MAYIG EXPRESION\n");}
                |expresion COMP_MENIG expresion {printf("Regla 38 - CONDICION_SIMPLE: EXPRESION COMP_MENIG EXPRESION\n");}
;
condicion_doble:condicion_simple AND condicion_simple {printf("Regla 39 - CONDICION_DOBLE: CONDICION_SIMPLE AND CONDICION_SIMPLE\n");}
                |condicion_simple OR condicion_simple {printf("Regla 40 - CONDICION_DOBLE: CONDICION_SIMPLE OR CONDICION_SIMPLE\n");}

;
interacion:REPEAT condicion lista_sentencias ENDREPEAT   {printf("Regla 41 - INTERACION: REPEAT CONDICION LISTA_SENTENCIAS ENDREPEAT\n");}      
;  

expresion: termino 							{printf("Regla 42 - EXPRESION:TERMINO\n"); }
          |expresion SUMA termino			{printf("Regla 43 - EXPRESION:EXPRESION SUMA TERMINO\n"); }
		  |expresion RESTA termino 			{printf("Regla 44 - EXPRESION:EXPRESION RESTA TERMINO\n");}
		  |expresion MULTIPLICACION termino            {printf("Regla 45 - EXPRESION:EXPRESION MULTIPLICACION TERMINO\n");}
		  |expresion DIV termino            {printf("Regla 46 - EXPRESION:EXPRESION DIV TERMINO\n");}

;
termino:factor 								{printf("Regla 47 - TERMINO:FACTOR\n");}
       |termino MULTIPLICACION factor 		{printf("Regla 48 - TERMINO:TERMINO MULTIPLICACION FACTOR\n");}
	   |termino DIVISION factor 					{printf("Regla 49 - TERMINO:TERMINO DIVISION FACTOR\n");}
		
;
factor: ID 									{printf("Regla 50 - FACTOR:ID\n");}
       |CONST_INT 							{printf("Regla 51 - FACTOR:CONST_INT\n");}
	   |CONST_REAL 							{printf("Regla 52 - FACTOR:CONST_REAL\n");}
	   |CONST_STR  							{printf("Regla 53 - FACTOR:CONST_STR\n");}


%%

int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {

	yyparse();
	 crearTablaDeSimbolosEnUnArchivo();
  }
  fclose(yyin);
  return 0;
}
int yyerror(void)
{
     printf("Syntax Error\n");
	 system ("Pause");
	 exit (1);
}
