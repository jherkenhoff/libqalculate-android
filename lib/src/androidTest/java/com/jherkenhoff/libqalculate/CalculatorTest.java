package com.jherkenhoff.libqalculate;

import static org.junit.Assert.assertEquals;

import android.util.Log;

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
        assertEquals(res, "2");
    }
}
