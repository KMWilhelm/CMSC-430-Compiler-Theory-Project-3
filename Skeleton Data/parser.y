/* Name: Katrina Wilhelm
 *  Date: 11/5/2025
 *  CMSC 430 Project 2
 *  This file contains the bison parser for the language as described in the instructions
 */

%{

#include <iostream>
#include <cmath>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);
double extract_element(CharPtr list_name, double subscript);

Symbols<double> scalars;
Symbols<vector<double>*> lists;
double result;

%}

%define parse.error verbose

%union {
	CharPtr iden;
	Operators oper;
	double value;
	vector<double>* list;
}

%token <iden> IDENTIFIER

%token <value> INT_LITERAL CHAR_LITERAL REAL_LITERAL

%token <oper> ADDOP MULOP REMOP EXPOP NEGOP ANDOP RELOP OROP NOTOP

%token ARROW

%token BEGIN_ CASE CHARACTER ELSE END ENDSWITCH FUNCTION INTEGER IS LIST OF OTHERS
	RETURNS SWITCH WHEN ELSIF ENDFOLD ENDIF FOLD IF LEFT REAL RIGHT THEN

%type <value> body statement_ statement cases case expression term primary
	 condition relation

%type <list> list expressions

%%

function:	
	function_header optional_variable body ';' {result = $3;} ;

function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';' 
	| error ';' 
	; 
	

type:
	INTEGER |
	REAL |
	CHARACTER 
	;

optional_parameters:
  /* empty */
  | parameters
;

parameters:
    parameter
  | parameters ',' parameter
;

parameter:
    IDENTIFIER ':' type
;
	
optional_variable:
	/* empty */
	| optional_variable variable 
	;
    
variable:	
	IDENTIFIER ':' type IS statement ';' {scalars.insert($1, $5);}; |
	IDENTIFIER ':' LIST OF type IS list ';' {lists.insert($1, $7);} ;

list:
	'(' expressions ')' {$$ = $2;} ;

expressions:
	expressions ',' expression {$1->push_back($3); $$ = $1;} |  
	expression {$$ = new vector<double>(); $$->push_back($1);}

body:
	BEGIN_ statement_ END  {$$ = $2;};

statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
    
statement:
	expression |
	WHEN condition ',' expression ':' expression {$$ = $2 ? $4 : $6;} |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH 
	{$$ = !isnan($4) ? $4 : $7;} |
	IF condition THEN statement_ elsif_clauses ELSE statement_ ENDIF |
	FOLD direction operator list_choice ENDFOLD 
;

cases:
	cases case {$$ = !isnan($1) ? $1 : $2;} |
	%empty {$$ = NAN;};
	
case:
	CASE INT_LITERAL ARROW statement ';' {$$ = $<value>-2 == $2 ? $4 : NAN;}
	| error ';'
	;

elsif_clauses:
	%empty 
	| ELSIF condition THEN statement_ elsif_clauses
	;

direction:
    LEFT
  	| RIGHT
	;

operator: 
	ADDOP
	| MULOP
	;

list_choice: 
	list 
	| IDENTIFIER 
	;

condition:
	condition OROP and_condition {$$ = $1 && $2;}
  	| and_condition ;

  and_condition:
    and_condition ANDOP not_condition
  	| not_condition ;

not_condition:
    NOTOP not_condition
  	| relation ;

relation:
	'(' condition ')'  {$$ = $2;}
  	| expression RELOP expression {$$ = evaluateRelational($1, $2, $3);};

expression:
	expression ADDOP term {$$ = evaluateArithmetic($1, $2, $3);} |
	term ;
      
term:
	term MULOP power |
	term REMOP power |
    power ;

power:
	factor EXPOP power |
    factor ;

factor:
    NEGOP factor |
    primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	CHAR_LITERAL |
	REAL_LITERAL |
	IDENTIFIER '(' expression ')' {$$ = extract_element($1, $3); } |
	IDENTIFIER {if (!scalars.find($1, $$)) appendError(UNDECLARED, $1);};

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

double extract_element(CharPtr list_name, double subscript) {
	vector<double>* list; 
	if (lists.find(list_name, list))
		return (*list)[subscript];
	appendError(UNDECLARED, list_name);
	return NAN;
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 
