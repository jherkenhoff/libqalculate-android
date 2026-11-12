package com.jherkenhoff.libqalculate;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import android.system.ErrnoException;
import android.system.Os;

import org.junit.Before;
import org.junit.Test;

public class CalculatorTest {
    @Before
    public void loadLibrary() {
        System.loadLibrary("qalculate_swig");
    }
    @Test
    public void testBasicCalculation() {
        Calculator calc = new Calculator();
        String res = calc.calculateAndPrint("1+1");
        assertEquals("2", res);
    }
    @Test
    public void testExchangeRatesUserPath() throws ErrnoException {
        Os.setenv("QALCULATE_USER_DIR", "/MyCustomPath", true);

        Calculator calc = new Calculator();
        String filename = calc.getExchangeRatesFileName(1);
        assertEquals("/MyCustomPath/eurofxref-daily.xml", filename);
    }
    @Test
    public void testUnitDowncast() {
        Calculator calc = new Calculator();
        calc.loadGlobalDefinitions();

        Unit meterUnit = calc.getUnit("meter");
        assertNotNull(meterUnit);
        assertEquals("com.jherkenhoff.libqalculate.Unit", meterUnit.getClass().getName());

        Unit voltUnit = calc.getUnit("volt");
        assertNotNull(voltUnit);
        assertEquals("com.jherkenhoff.libqalculate.AliasUnit", voltUnit.getClass().getName());
    }
    @Test
    public void testVariableDowncast() {
        Calculator calc = new Calculator();
        calc.loadGlobalDefinitions();

        Variable piVariable = calc.getVariable("pi");
        assertNotNull(piVariable);
        assertEquals("com.jherkenhoff.libqalculate.KnownVariable", piVariable.getClass().getName());

        Variable xVariable = calc.getVariable("x");
        assertNotNull(xVariable);
        assertEquals("com.jherkenhoff.libqalculate.UnknownVariable", xVariable.getClass().getName());
    }
    @Test
    public void testMathFunctionDowncast() {
        Calculator calc = new Calculator();
        calc.loadGlobalDefinitions();

        MathFunction sinFunction = calc.getFunction("sin");
        assertNotNull(sinFunction);
        assertEquals("com.jherkenhoff.libqalculate.MathFunction", sinFunction.getClass().getName());

        MathFunction atomFunction = calc.getFunction("atom");
        assertNotNull(atomFunction);
        assertEquals("com.jherkenhoff.libqalculate.DataSet", atomFunction.getClass().getName());
    }
}