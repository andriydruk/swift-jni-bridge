package com.readdle.swiftjnibridge;

import java.util.Arrays;
import java.util.HashMap;

public class ComplexClass {

    public SampleClass sampleClass;
    public String stringNil;
    public String[] stringArray;
    public long[] numberArray;

    public SampleClass[] objectArray;
    public HashMap<String, SampleClass> dictSampleClass;
    public HashMap<String, String> dictStrings;

    @Override
    public String toString() {
        return "ComplexClass{" +
                "sampleClass=" + sampleClass +
                ", stringNil='" + stringNil + '\'' +
                ", stringArray=" + Arrays.toString(stringArray) +
                ", numberArray=" + Arrays.toString(numberArray) +
                ", objectArray=" + Arrays.toString(objectArray) +
                ", dictSampleClass=" + dictSampleClass +
                ", dictStrings=" + dictStrings +
                '}';
    }
}
