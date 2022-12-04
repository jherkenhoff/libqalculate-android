%module libqalculate
%{
#include "libqalculate/qalculate.h"
%}

%include "std_string.i"
%include "std_vector.i"
%include "pointer.i"

namespace std {
    %template(IntVector) vector<int>;
    %template(StringVector) vector<std::string>;
};

// va_list is not supported by SWIG (http://swig.org/Doc1.3/Varargs.html#Varargs_nn8)
%ignore Calculator::message(MessageType mtype, int message_category, const char *TEMPLATE, va_list ap);

//%include <libqalculate/includes.h>
%include <libqalculate/Calculator.h>
%include <libqalculate/ExpressionItem.h>
%include <libqalculate/Function.h>
