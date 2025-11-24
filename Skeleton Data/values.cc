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
#include <vector>

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
		result = (right == 0.0) ? NAN : fmod(left, right);
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
		result = (left < right) ? 1.0 : 0.0;
		break;
	case LESS_EQUAL:
		result = (left <= right) ? 1.0 : 0.0;
		break;
	case GREATER:
		result = (left > right) ? 1.0 : 0.0;
		break;
	case GREATER_EQUAL:
		result = (left >= right) ? 1.0 : 0.0;
		break;
	case EQUAL:
		result = (left == right) ? 1.0 : 0.0;
		break;
	case NOT_EQUAL:
		result = (left != right) ? 1.0 : 0.0;
		break;
	default:
		break;
	}
	return result;
}

double fold(double direction, Operators operator_, vector<double> *list)
{
	if (!list || list->empty())
		return NAN;

	if (direction == 1.0)
	{
		double acc = (*list)[0];
		for (size_t i = 1; i < list->size(); ++i)
			acc = evaluateArithmetic(acc, operator_, (*list)[i]);
		return acc;
	}
	else
	{
		double acc = (*list)[list->size() - 1];
		for (int i = (int)list->size() - 2; i >= 0; --i)
			acc = evaluateArithmetic((*list)[i], operator_, acc);
		return acc;
	}
}
