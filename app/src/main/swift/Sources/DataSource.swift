//
//  Manager.swift
//  jniBridge
//
//  Created by Andrew on 10/11/17.
//

import Foundation
import java_swift
import SwiftProtobuf

public class DataSource {
    
    private let dataSourceId = UUID().uuidString
    
    public init() {
        NSLog("DataSource init: \(dataSourceId)")
    }
    
    deinit {
        NSLog("DataSource deinit: \(dataSourceId)")
    }
    
    public func notRandomSampleObject() -> SampleClass {
        let obj = SampleClass()
        
        obj.dataSourceId = self.dataSourceId
        
        obj.string1 =  "32327244-0710-430A-90D8-D2F57344403A"
        obj.string2 = "32327244-0710-430A-90D8-D2F57344403A"
        obj.string3 = "32327244-0710-430A-90D8-D2F57344403A"
        obj.string4 = "32327244-0710-430A-90D8-D2F57344403A"
        obj.string5 = "32327244-0710-430A-90D8-D2F57344403A"
        obj.string6 = "32327244-0710-430A-90D8-D2F57344403A"
        
        return obj
    }
    
    public func randomSampleObject() -> SampleClass {
        let obj = SampleClass()
        
        obj.dataSourceId = self.dataSourceId
        
        obj.string1 =  UUID().uuidString
        obj.string2 =  UUID().uuidString
        obj.string3 =  UUID().uuidString
        obj.string4 =  UUID().uuidString
        obj.string5 =  UUID().uuidString
        obj.string6 =  UUID().uuidString
        
        return obj
    }
    
    func notRandomSampleProtoObject() -> SampleClassProto {
        var obj = SampleClassProto()
        
        obj.dataSourceID = self.dataSourceId
        
        obj.pkInt = 64
        obj.pkInt8 = 8
        obj.pkInt16 = 16
        obj.pkInt32 = 32
        obj.pkInt64 = 64
        obj.pkBool = false
        
        obj.string1 =  "32327244-0710-430A-90D8-D2F57344403A"
        obj.string2 = "32327244-0710-430A-90D8-D2F57344403A"
        obj.string3 = "32327244-0710-430A-90D8-D2F57344403A"
        obj.string4 = "32327244-0710-430A-90D8-D2F57344403A"
        obj.string5 = "32327244-0710-430A-90D8-D2F57344403A"
        obj.string6 = "32327244-0710-430A-90D8-D2F57344403A"
        
        return obj
    }
    
    func randomSampleProtoObject() -> SampleClassProto {
        var obj = SampleClassProto()
        
        obj.dataSourceID = self.dataSourceId
        
        obj.pkInt = 64
        obj.pkInt8 = 8
        obj.pkInt16 = 16
        obj.pkInt32 = 32
        obj.pkInt64 = 64
        obj.pkBool = false
        
        obj.string1 =  UUID().uuidString
        obj.string2 =  UUID().uuidString
        obj.string3 =  UUID().uuidString
        obj.string4 =  UUID().uuidString
        obj.string5 =  UUID().uuidString
        obj.string6 =  UUID().uuidString
        
        return obj
    }
    
    public func updateSampleObject(_ sampleObject: SampleClass) {
        NSLog("updateSampleObject: \(sampleObject.dataSourceId ?? "(null)") \(sampleObject.pkInt) \(sampleObject.pkInt8) \(sampleObject.pkInt16) \(sampleObject.pkInt32) \(sampleObject.pkInt64)")
    }
    
    public func updateSampleObjects(_ sampleObject: [SampleClass]) {
        // Do nothing
    }
    
}

fileprivate let javaClass = JNI.GlobalFindClass("com/readdle/swiftjnibridge/DataSource")
fileprivate let javaSwiftPointerFiled = JNI.api.GetFieldID(JNI.env, javaClass!, "swiftPointer", "J")
fileprivate let javaConstructor = JNI.api.GetMethodID(JNI.env, javaClass!, "<init>", "(J)V");

// MARK: Java extension
extension DataSource {
    
    // MARK: Shared class
    public func toJava() -> jobject? {
        // Unbalanced retain
        let pointer = Unmanaged.passRetained(self).toOpaque()
        
        var locals = [jobject]()
        var args = [jvalue].init(repeating: jvalue(), count: 1)
        args[0] = JNIType.toJava(value: jlong(Int(bitPattern: pointer)), locals: &locals)
        
        var cls = javaClass
        var constructor = javaConstructor
        
        let object = JNIMethod.NewObject(className: "com/readdle/swiftjnibridge/DataSource",
                                         classCache: &cls,
                                         methodSig: "(J)V",
                                         methodCache: &constructor,
                                         args: &args,
                                         locals: &locals)
        
        return object
    }
    
    @_silgen_name("Java_com_readdle_swiftjnibridge_DataSource_swiftRelease")
    public static func release( __env: UnsafeMutablePointer<JNIEnv?>, this: jobject?) {
        guard let pointer = UnsafeRawPointer(bitPattern: Int(JNI.api.GetLongField(JNI.env, this, javaSwiftPointerFiled))) else {
            return
        }
        // Unbalanced release
        return Unmanaged<DataSource>.fromOpaque(pointer).release()
    }
    
    private static func swiftObject(_ this: jobject?) -> DataSource? {
        guard let pointer = UnsafeRawPointer(bitPattern: Int(JNI.api.GetLongField(JNI.env, this, javaSwiftPointerFiled))) else {
            return nil
        }
        return Unmanaged<DataSource>.fromOpaque(pointer).takeUnretainedValue()
    }
    
    // MARK: JNI construction
    @_silgen_name("Java_com_readdle_swiftjnibridge_DataSource_getObject")
    public static func getObject( __env: UnsafeMutablePointer<JNIEnv?>, this: jobject?)-> jobject? {
        return swiftObject(this)?.randomSampleObject().toJava()
    }
    
    @_silgen_name("Java_com_readdle_swiftjnibridge_DataSource_updateObject")
    public static func updateObject( __env: UnsafeMutablePointer<JNIEnv?>, this: jobject?, retainedPointer: jlong)  {
        if let pointer = UnsafeRawPointer(bitPattern: Int(retainedPointer)){
            let object = Unmanaged<SampleClass>.fromOpaque(pointer).takeRetainedValue()
            swiftObject(this)?.updateSampleObject(object)
        }
    }
    
    @_silgen_name("Java_com_readdle_swiftjnibridge_DataSource_getObjects")
    public static func getObjects( __env: UnsafeMutablePointer<JNIEnv?>, this: jobject?)-> jarray? {
        guard let swiftSelf = swiftObject(this),
            let result = JNI.api.NewObjectArray(JNI.env, 1000, SampleClass.javaClass, nil) else {
                return nil
        }
        for i in 0 ..< 1000 {
            JNI.api.SetObjectArrayElement(JNI.env, result, jsize(i), swiftSelf.notRandomSampleObject().toJava())
        }
        return result
    }
    
    @_silgen_name("Java_com_readdle_swiftjnibridge_DataSource_updateObjects")
    public static func updateObjects( __env: UnsafeMutablePointer<JNIEnv?>, this: jobject?, retainedPointers: jlongArray)  {
        let count = Int(JNI.api.GetArrayLength(JNI.env, retainedPointers))
        var array = [SampleClass]()
        var isCopied: jboolean = 0
        let arrayPointer = JNI.api.GetLongArrayElements(JNI.env, retainedPointers, &isCopied)
        for i in 1 ..< count {
            if let pointer = UnsafeRawPointer(bitPattern: Int(arrayPointer!.advanced(by: i).pointee)){
                let object = Unmanaged<SampleClass>.fromOpaque(pointer).takeRetainedValue()
                array.append(object)
            }
        }
        swiftObject(this)?.updateSampleObjects(array)
    }
    
    // MARK: JSON
    @_silgen_name("Java_com_readdle_swiftjnibridge_DataSource_getObjectWithJSON")
    public static func getObjectWithJSON( __env: UnsafeMutablePointer<JNIEnv?>, this: jobject?)-> jstring? {
        return convertToJavaJSON(swiftObject(this)?.randomSampleObject())
    }
    
    @_silgen_name("Java_com_readdle_swiftjnibridge_DataSource_updateObjectWithJSON")
    public static func updateObjectWithJSON( __env: UnsafeMutablePointer<JNIEnv?>, this: jobject?, jsonString: jstring?)  {
        if let sampleObj: SampleClass = parseFromJavaJSON(jsonString) {
            swiftObject(this)?.updateSampleObject(sampleObj)
        }
    }
    
    @_silgen_name("Java_com_readdle_swiftjnibridge_DataSource_getObjectsWithJSON")
    public static func getObjectsWithJSON( __env: UnsafeMutablePointer<JNIEnv?>, this: jobject?)-> jstring? {
        guard let swiftSelf = swiftObject(this) else {
                return nil
        }
        let array = [SampleClass].init(repeating: swiftSelf.notRandomSampleObject(), count: 1000)
        return convertToJavaJSON(array)
    }
    
    @_silgen_name("Java_com_readdle_swiftjnibridge_DataSource_updateObjectsWithJSON")
    public static func updateObjectsWithJSON( __env: UnsafeMutablePointer<JNIEnv?>, this: jobject?, jsonStrings: jarray?)  {
        let count = Int(JNI.api.GetArrayLength(JNI.env, jsonStrings))
        var array = [SampleClass]()
        for i in 1 ..< count {
            if let sampleObj: SampleClass = parseFromJavaJSON(JNI.api.GetObjectArrayElement(JNI.env, jsonStrings, i)) {
                array.append(sampleObj)
            }
        }
        swiftObject(this)?.updateSampleObjects(array)
    }
    
    // MARK: PROTO
    @_silgen_name("Java_com_readdle_swiftjnibridge_DataSource_getProtoObject")
    public static func getProtoObject( __env: UnsafeMutablePointer<JNIEnv?>, this: jobject?) -> jobject? {
        return swiftObject(this)?.notRandomSampleProtoObject().toJava()
    }
    
    @_silgen_name("Java_com_readdle_swiftjnibridge_DataSource_updateProtoObject")
    public static func updateProtoObject( __env: UnsafeMutablePointer<JNIEnv?>, this: jobject?, _ byteArray: jarray?) {
        if let proto = SampleClassProto.init(byteArray: byteArray) {
            NSLog("updateProtoObject: \(proto.dataSourceID)")
        }
    }

}
