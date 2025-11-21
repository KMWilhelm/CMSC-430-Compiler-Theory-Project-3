/* Name: Katrina Wilhelm
 *  Date: 10/26/2025
 *  CMSC 430 Project 2
 *  This file contains flex input file
 *  
 */


%{
#include <cstdio>
#include <string>
#include <vector>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

static int hex_to_int(const char* s) {
    int v = 0;
    while (*s) {
        char c = *s++;
        int d;
        if (c >= '0' && c <= '9') d = c - '0';
        else if (c >= 'a' && c <= 'f') d = 10 + (c - 'a');
        else if (c >= 'A' && c <= 'F') d = 10 + (c - 'A');
        else break;
        v = (v << 4) + d; // v = v*16 + digit
    }
    return v;
}

static int char_to_int(const char* yytext) {
    // yytext looks like: 'a' or '\n' or '\f' etc.
    if (yytext[1] == '\\') {
        switch (yytext[2]) {
            case 'n': return '\n';   
            case 't': return '\t';   
            case 'r': return '\r';   
            case 'f': return '\f';  
            case 'b': return '\b';   
            case '\\': return '\\';  
            case '\'': return '\'';  
            case '\"': return '\"';  
            case 'a': return '\a';   
            case 'v': return '\v';   
            default:  return yytext[2]; 
        }
    } else {
        return yytext[1]; // ordinary character
    }
}
%}

%option noyywrap

ws		[ \t\r]+
comment		("//".*|--.*)\n
line		[\n]
id  [A-Za-z]([A-Za-z0-9]|_[A-Za-z0-9]|__([A-Za-z0-9]))*
digit		[0-9]
dec		{digit}+
hex         \#[0-9A-Fa-f]+
char    \'([^\\'\n]|\\[btnrf])\'
punc		[\(\),:;]
real    [0-9]*\.[0-9]+([eE][+-]?[0-9]+)?
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }
"+"		   { ECHO; yylval.oper = ADD; return(ADDOP); }
"-"         { ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"      	{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"         { ECHO; yylval.oper = DIVIDE; return(MULOP); }
"%"         { ECHO; yylval.oper = REMAINDER; return(REMOP); }
"^"		   { ECHO; yylval.oper = EXPONENT; return(EXPOP); }
"~"		   { ECHO; yylval.oper = NEGATE; return(NEGOP); }
"&"		   { ECHO; yylval.oper = AND; return(ANDOP); }

"=>"		{ ECHO; return(ARROW); }
"|"			{ ECHO; return(OROP); }
"!"			{ ECHO; return(NOTOP); }
">="        { ECHO; return(RELOP); }
"<="        { ECHO; return(RELOP); }
"<>"        { ECHO; return(RELOP); }
"/="        { ECHO; return(RELOP); }
"="         { ECHO; return(RELOP); }
">"         { ECHO; return(RELOP); }
"<"         { ECHO; return(RELOP); }
begin		{ ECHO; return(BEGIN_); }
case		{ ECHO; return(CASE); }
character	{ ECHO; return(CHARACTER); }
end		{ ECHO; return(END); }
endswitch	{ ECHO; return(ENDSWITCH); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
list		{ ECHO; return(LIST); }
of		{ ECHO; return(OF); }
others		{ ECHO; return(OTHERS); }
returns		{ ECHO; return(RETURNS); }
switch		{ ECHO; return(SWITCH); }
when		{ ECHO; return(WHEN); }
else		{ ECHO; return(ELSE); }
elsif		{ ECHO; return(ELSIF); }
endfold		{ ECHO; return(ENDFOLD); }
endif		{ ECHO; return(ENDIF); }
fold		{ ECHO; return(FOLD); }
if			{ ECHO; return(IF); }
left		{ ECHO; return(LEFT); }
real		{ ECHO; return(REAL); }
right		{ ECHO; return(RIGHT); }
then		{ ECHO; return(THEN); }


{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{real}      { ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
{hex}    { ECHO; yylval.value = (double)hex_to_int(yytext + 1); return(INT_LITERAL); }
{dec}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{char}	{ ECHO; yylval.value = (double)char_to_int(yytext); return CHAR_LITERAL; }
{punc}		{ ECHO; return(yytext[0]); }
.			{ ECHO; appendError(LEXICAL, yytext); }


%%

