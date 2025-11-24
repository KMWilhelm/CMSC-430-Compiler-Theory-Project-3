// CMSC 430 Compiler Theory and Design
// Project 3 Skeleton
// UMGC CITE
// Summer 2023

// This file contains type definitions and the function
// definitions for the evaluation functions

#include <vector>

typedef char *CharPtr;

enum Operators
{
    ADD,
    SUBTRACT,
    MULTIPLY,
    DIVIDE,
    REMAINDER,
    EXPONENT,
    NEGATE,
    LESS,
    LESS_EQUAL,
    GREATER,
    GREATER_EQUAL,
    EQUAL,
    NOT_EQUAL,
    AND,
    OR,
    NOT
};

double evaluateArithmetic(double left, Operators operator_, double right);
double evaluateUnary(double value, Operators operator_);
double evaluateRelational(double left, Operators operator_, double right);
double fold(bool direction, Operators operator_, vector<double> *list);
