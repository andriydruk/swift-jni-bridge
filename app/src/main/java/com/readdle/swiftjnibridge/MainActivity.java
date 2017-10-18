package com.readdle.swiftjnibridge;

import com.google.gson.Gson;

import android.os.Bundle;
import android.os.SystemClock;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;

import java.util.UUID;

public class MainActivity extends AppCompatActivity {

    static {
        System.loadLibrary("jniBridge");
    }

    private static final Gson sGson = new Gson();
    private DataSource mDataSource;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    @Override
    protected void onStart() {
        super.onStart();

        ComplexClass objEncoded = jniEncode();
        Log.d("Java", "JNI encoded:" + objEncoded.toString());

        mDataSource = createDataSource();

        SampleClass obj = mDataSource.getObject();
        Log.d("Java", "JNI read:" + obj.toString());

        String jsonString = mDataSource.getObjectWithJSON();
        obj = sGson.fromJson(jsonString, SampleClass.class);
        Log.d("Java", "JSON read:" + obj.toString());

        DataModel.SampleClassProto sampleClassProto = mDataSource.getProtoObject();
        Log.d("Java", "PROTO read:" + sampleClassProto.toString());

        obj.dataSourceId = UUID.randomUUID().toString();
        sampleClassProto = sampleClassProto.toBuilder().setDataSourceId(UUID.randomUUID().toString()).build();

        mDataSource.updateObject(obj);
        mDataSource.updateObjectWithJSON(sGson.toJson(obj));
        mDataSource.updateProtoObject(sampleClassProto.toByteArray());

        // ---------- Performance measuring ----------------------

        long clock = SystemClock.uptimeMillis();
        SampleClass[] objects = mDataSource.getObjects();
        Log.i("Java", "JNI read " + objects.length + " " + (SystemClock.uptimeMillis() - clock) + "ms");

        clock = SystemClock.uptimeMillis();
        mDataSource.updateObjects3(objects);
        Log.i("Java", "JNI write " + (SystemClock.uptimeMillis() - clock) + "ms");

        clock = SystemClock.uptimeMillis();
        jsonString = mDataSource.getObjectsWithJSON();
        objects = sGson.fromJson(jsonString, SampleClass[].class);
        Log.i("Java", "JSON read " + objects.length + " " + (SystemClock.uptimeMillis() - clock) + "ms");

        clock = SystemClock.uptimeMillis();
        // I use array of Strings instead of one String because of crash at Android Foundation
        // https://swift.sandbox.bluemix.net/#/repl/59e09ad0c214e559df18074f
        String[] jsonStrings = new String[objects.length];
        for (int i = 0; i < objects.length; i++) {
            jsonStrings[i] = sGson.toJson(objects[i]);
        }
        mDataSource.updateObjectsWithJSON(jsonStrings);
        Log.i("Java", "JSON write " + (SystemClock.uptimeMillis() - clock) + "ms");

        clock = SystemClock.uptimeMillis();
        DataModel.SampleClassProto[] protos = new DataModel.SampleClassProto[1000];
        for (int i = 0; i < protos.length; i++) {
            protos[i] = mDataSource.getProtoObject();
            assert protos[i] != null;
        }
        Log.i("Java", "PROTO read " + protos.length + " " + (SystemClock.uptimeMillis() - clock) + "ms");

        clock = SystemClock.uptimeMillis();
        for (int i = 0; i < protos.length; i++) {
            mDataSource.updateProtoObject(protos[i].toByteArray());
        }
        Log.i("Java", "PROTO write " + protos.length + " " + (SystemClock.uptimeMillis() - clock) + "ms");
    }

    @Override
    protected void onStop() {
        super.onStop();
        mDataSource.release();
    }

    public native DataSource createDataSource();
    public native ComplexClass jniEncode();

}
