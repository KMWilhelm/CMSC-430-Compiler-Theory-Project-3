// CMSC 430 Compiler Theory and Design
// Project 3 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the bodies of the evaluation functions

#include <string>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

double evaluateArithmetic(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
	case ADD:
		result = left + right;
		break;
	case MULTIPLY:
		result = left * right;
		break;
	case SUBTRACT:
		result = left - right;
		break;
	case DIVIDE:
		result = left / right;
		break;
	case REMAINDER:
		result = fmod(left, right);
		break;
	case EXPONENT:
		result = pow(left, right);
		break;
	default:
		break;
	}
	return result;
}

double evaluateUnary(double value, Operators operator_)
{
	switch (operator_)
	{
	case NEGATE:
		return -value;
	default:
		return value;
	}
}

double evaluateRelational(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
	case LESS:
		result = left < right;
		break;
	case LESS_EQUAL:
		result = left <= right;
		break;
	case GREATER:
		result = left > right;
		break;
	case GREATER_EQUAL:
		result = left >= right;
		break;
	case EQUAL:
		result = left == right;
		break;
	case NOT_EQUAL:
		result = left != right;
		break;
	default:
		break;
	}
	return result;
}

double evaluateNot(double value)
{
	return (value == 0.0) ? 1.0 : 0.0;
}