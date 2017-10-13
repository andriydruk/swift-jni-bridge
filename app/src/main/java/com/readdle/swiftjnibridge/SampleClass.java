package com.readdle.swiftjnibridge;

import com.google.protobuf.ByteString;
import com.google.protobuf.InvalidProtocolBufferException;

import android.support.annotation.Nullable;

import java.nio.ByteBuffer;

public class SampleClass {

    @Nullable String dataSourceId;

    long pkInt;
    byte pkInt8;
    short pkInt16;
    int pkInt32;
    long pkInt64;
    boolean pkBool;

    @Nullable String string1;
    @Nullable String string2;
    @Nullable String string3;
    @Nullable String string4;
    @Nullable String string5;
    @Nullable String string6;

    @Override
    public String toString() {
        return "SampleClass{" +
                "dataSourceId='" + dataSourceId + '\'' +
                ", pkInt=" + pkInt +
                ", pkInt8=" + pkInt8 +
                ", pkInt16=" + pkInt16 +
                ", pkInt32=" + pkInt32 +
                ", pkInt64=" + pkInt64 +
                ", pkBool=" + pkBool +
                ", string1='" + string1 + '\'' +
                ", string2='" + string2 + '\'' +
                ", string3='" + string3 + '\'' +
                ", string4='" + string4 + '\'' +
                ", string5='" + string5 + '\'' +
                ", string6='" + string6 + '\'' +
                '}';
    }

    // Constructor for JNI
    private SampleClass(String dataSourceId, long pkInt, byte pkInt8, short pkInt16, int pkInt32, long pkInt64, boolean pkBool,
                        String string1, String string2, String string3, String string4, String string5, String string6) {
        this.dataSourceId = dataSourceId;
        this.pkInt = pkInt;
        this.pkInt8 = pkInt8;
        this.pkInt16 = pkInt16;
        this.pkInt32 = pkInt32;
        this.pkInt64 = pkInt64;
        this.pkBool = pkBool;
        this.string1 = string1;
        this.string2 = string2;
        this.string3 = string3;
        this.string4 = string4;
        this.string5 = string5;
        this.string6 = string6;
    }

    // Return retained pointer to Swift object
    public long toSwift() {
        return toSwift(dataSourceId, pkInt, pkInt8, pkInt16, pkInt32, pkInt64, pkBool, string1, string2, string3, string4, string5, string6);
    }

    private native long toSwift(String dataSourceId, long pkInt, byte pkInt8, short pkInt16, int pkInt32, long pkInt64, boolean pkBool,
                                String string1, String string2, String string3, String string4, String string5, String string6);

    public static native long createSwiftSampleClassProto(byte[] array);

    private static Object createSampleClassProto(ByteBuffer buffer) {
        ByteString byteString = ByteString.copyFrom(buffer);
        try {
            return DataModel.SampleClassProto.parseFrom(byteString);
        } catch (InvalidProtocolBufferException e) {
            e.printStackTrace();
            return null;
        }
    }
}
