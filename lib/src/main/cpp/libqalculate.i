%module libqalculate

%{
#include "libqalculate/qalculate.h"
%}

%include "std_string.i"
%include "std_vector.i"
%include "cpointer.i"

namespace std {
    %template(IntVector) vector<int>;
    %template(StringVector) vector<std::string>;
    %template(MathStructureVector) vector<MathStructure>;
    %template(VariableVector) vector<Variable*>;
    %template(UnitVector) vector<Unit*>;
    %template(MathFunctionVector) vector<MathFunction*>;
    %template(PrefixVector) vector<Prefix*>;
    %template(DecimalPrefixVector) vector<DecimalPrefix*>;
    %template(BinaryPrefixVector) vector<BinaryPrefix*>;
    %template(ExpressionItemVector) vector<ExpressionItem*>;
    %template(ExpressionNameVector) vector<ExpressionName>;
};

// va_list is not supported by SWIG (http://swig.org/Doc1.3/Varargs.html#Varargs_nn8)
%ignore Calculator::message(MessageType mtype, int message_category, const char *TEMPLATE, va_list ap);

%ignore MathStructure::set;
%ignore Number::setInternal;


%include <libqalculate/includes.h>
%include <libqalculate/Variable.h>
%include <libqalculate/Number.h>
%include <libqalculate/Calculator.h>
%include <libqalculate/MathStructure.h>
%include <libqalculate/ExpressionItem.h>
%include <libqalculate/Function.h>
%include <libqalculate/Prefix.h>
%include <libqalculate/Unit.h>
