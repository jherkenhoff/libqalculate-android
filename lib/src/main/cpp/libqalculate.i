%module libqalculate

%{
#include "libqalculate/qalculate.h"
%}

%include "std_string.i"
%include "std_vector.i"
%include "cpointer.i"

// va_list is not supported by SWIG (http://swig.org/Doc1.3/Varargs.html#Varargs_nn8)
%ignore Calculator::message(MessageType mtype, int message_category, const char *TEMPLATE, va_list ap);

%ignore MathStructure::set;
%ignore Number::setInternal;
%ignore CompositeUnit::get;

%extend CompositeUnit {
    Unit *getUnit(size_t index) const {
        return self->get(index);
    }
    int getExponent(size_t index) const {
        int e = 1;
        self->get(index, &e, NULL);
        return e;
    }
    Prefix *getPrefix(size_t index) const {
        Prefix *p = NULL;
        self->get(index, NULL, &p);
        return p;
    }
}

// Custom typemaps for Unit, Variable and Mathfunction for proper downcasting
%typemap(javaout) Unit *, Unit &, Unit* const&  {
    long cPtr = $jnicall;
    if (cPtr == 0) return null;

    UnitSubtype subtype = UnitSubtype.swigToEnum($imclassname.Unit_subtype(cPtr, null));

    if (subtype == UnitSubtype.SUBTYPE_ALIAS_UNIT)
        return new AliasUnit(cPtr, $owner);
    else if (subtype == UnitSubtype.SUBTYPE_COMPOSITE_UNIT)
        return new CompositeUnit(cPtr, $owner);
    else
        return new Unit(cPtr, $owner);
}

%typemap(javaout) Variable *, Variable &, Variable* const& {
    long cPtr = $jnicall;
    if (cPtr == 0) return null;

    VariableSubtype subtype = VariableSubtype.swigToEnum($imclassname.Variable_subtype(cPtr, null));

    if (subtype == VariableSubtype.SUBTYPE_UNKNOWN_VARIABLE)
        return new UnknownVariable(cPtr, $owner);
    else if (subtype == VariableSubtype.SUBTYPE_KNOWN_VARIABLE)
        return new KnownVariable(cPtr, $owner);
    else
        return new Variable(cPtr, $owner);
}

%typemap(javaout) Prefix *, Prefix &, Prefix* const& {
    long cPtr = $jnicall;
    if (cPtr == 0) return null;

    PrefixType subtype = PrefixType.swigToEnum($imclassname.Prefix_type(cPtr, null));

    if (subtype == PrefixType.PREFIX_DECIMAL)
        return new DecimalPrefix(cPtr, $owner);
    else if (subtype == PrefixType.PREFIX_BINARY)
        return new BinaryPrefix(cPtr, $owner);
    else if (subtype == PrefixType.PREFIX_NUMBER)
        return new NumberPrefix(cPtr, $owner);
    else
        return new Prefix(cPtr, $owner);
}

%typemap(javaout) MathFunction *, MathFunction &, MathFunction* const& {
    long cPtr = $jnicall;
    if (cPtr == 0) return null;

    FunctionSubtype subtype = FunctionSubtype.swigToEnum($imclassname.MathFunction_subtype(cPtr, null));

    if (subtype == FunctionSubtype.SUBTYPE_USER_FUNCTION)
        return new UserFunction(cPtr, $owner);
    else if (subtype == FunctionSubtype.SUBTYPE_DATA_SET)
        return new DataSet(cPtr, $owner);
    else
        return new MathFunction(cPtr, $owner);
}

%template(IntVector) std::vector<int>;
%template(StringVector) std::vector<std::string>;
%template(MathStructureVector) std::vector<MathStructure>;
%template(VariableVector) std::vector<Variable*>;
%template(UnitVector) std::vector<Unit*>;
%template(MathFunctionVector) std::vector<MathFunction*>;
%template(PrefixVector) std::vector<Prefix*>;
%template(DecimalPrefixVector) std::vector<DecimalPrefix*>;
%template(BinaryPrefixVector) std::vector<BinaryPrefix*>;
%template(ExpressionItemVector) std::vector<ExpressionItem*>;
%template(ExpressionNameVector) std::vector<ExpressionName>;

%include <libqalculate/includes.h>
%include <libqalculate/ExpressionItem.h>
%include <libqalculate/Variable.h>
%include <libqalculate/Number.h>
%include <libqalculate/Calculator.h>
%include <libqalculate/MathStructure.h>
%include <libqalculate/Function.h>
%include <libqalculate/DataSet.h>
%include <libqalculate/Prefix.h>
%include <libqalculate/Unit.h>
