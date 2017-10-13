package com.readdle.swiftjnibridge;


public class DataSource {

    // Address of retained swift object
    private long swiftPointer = 0; // nil

    // Private constructor should be called from JNI
    private DataSource(long swiftPointer) {
        this.swiftPointer = swiftPointer;
    }

    // Make unbalance release of swift object
    public native void swiftRelease();

    public void release() {
        this.swiftRelease();
        this.swiftPointer = 0; // nil
    }

    public native SampleClass getObject();
    public native String getObjectWithJSON();

    public void updateObject(SampleClass object) {
        updateObject(object.toSwift());
    }

    public void updateObjects(SampleClass[] objects) {
        long[] swiftObjects = new long[objects.length];
        for (int i = 0; i < objects.length; i++) {
            swiftObjects[i] = objects[i].toSwift();
        }
        updateObjects(swiftObjects);
    }

    public native void updateProtoObject(byte[] array);

    // Return 1000 object for performance measuring
    public native SampleClass[] getObjects();
    public native String getObjectsWithJSON();

    public native void updateObjectWithJSON(String jsonObject);
    public native void updateObjectsWithJSON(String[] jsonObject);

    public native DataModel.SampleClassProto getProtoObject();

    // Private API for internal usage
    private native void updateObject(long retainedPointer);
    private native void updateObjects(long[] objects);

}
