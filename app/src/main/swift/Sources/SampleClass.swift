
import Foundation
import java_swift
import CoreFoundation

public class SampleClass: Codable {
    
    var dataSourceId: String?
    
    var pkInt: Int = 64         // jlong
    var pkInt8: Int8 = 8        // jbyte
    var pkInt16: Int16 = 16     // jshort
    var pkInt32: Int32 = 32     // jint
    var pkInt64: Int64 = 64     // jlong
    var pkBool: Bool = false    // jboolean
    
    var string1: String?        // jstring?
    var string2: String?        // jstring?
    var string3: String?        // jstring?
    var string4: String?        // jstring?
    var string5: String?        // jstring?
    var string6: String?        // jstring?
    
    public init() {

    }
    
}

// MARK: JNI extension
extension SampleClass {
    
    static var javaClass = JNI.GlobalFindClass("com/readdle/swiftjnibridge/SampleClass")
    static var javaConstructor = JNI.api.GetMethodID(JNI.env, SampleClass.javaClass!, "<init>",
                                                     "(Ljava/lang/String;JBSIJZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    static var javaConstructor2 = JNI.api.GetMethodID(JNI.env, SampleClass.javaClass!, "<init>", "()V");
    
    static let javaDataSourceId = JNI.api.GetFieldID(JNI.env, javaClass, "dataSourceId", "Ljava/lang/String;")
    static let javaPkInt = JNI.api.GetFieldID(JNI.env, javaClass, "pkInt", "J")
    static let javaPkInt8 = JNI.api.GetFieldID(JNI.env, javaClass, "pkInt8", "B")
    static let javaPkInt16 = JNI.api.GetFieldID(JNI.env, javaClass, "pkInt16", "S")
    static let javaPkInt32 = JNI.api.GetFieldID(JNI.env, javaClass, "pkInt32", "I")
    static let javaPkInt64 = JNI.api.GetFieldID(JNI.env, javaClass, "pkInt64", "J")
    static let javaPkBool = JNI.api.GetFieldID(JNI.env, javaClass, "pkBool", "Z")
    static let javaString1 = JNI.api.GetFieldID(JNI.env, javaClass, "string1", "Ljava/lang/String;")
    static let javaString2 = JNI.api.GetFieldID(JNI.env, javaClass, "string2", "Ljava/lang/String;")
    static let javaString3 = JNI.api.GetFieldID(JNI.env, javaClass, "string3", "Ljava/lang/String;")
    static let javaString4 = JNI.api.GetFieldID(JNI.env, javaClass, "string4", "Ljava/lang/String;")
    static let javaString5 = JNI.api.GetFieldID(JNI.env, javaClass, "string5", "Ljava/lang/String;")
    static let javaString6 = JNI.api.GetFieldID(JNI.env, javaClass, "string6", "Ljava/lang/String;")
    
    @_silgen_name("Java_com_readdle_swiftjnibridge_SampleClass_toSwift")
    public static func toSwift2(_ env: UnsafeMutablePointer<JNIEnv?>,
                               _ this: jobject?,
                               _ dataSourceId: jstring?,
                               _ pkInt: jlong,
                               _ pkInt8: jbyte,
                               _ pkInt16: jshort,
                               _ pkInt32: jint,
                               _ pkInt64: jlong,
                               _ pkBool: jboolean,
                               _ string1: jstring?,
                               _ string2: jstring?,
                               _ string3: jstring?,
                               _ string4: jstring?,
                               _ string5: jstring?,
                               _ string6: jstring?) -> jlong {
        
        let sample = SampleClass()
        
        sample.dataSourceId = JNIType.toSwift(type: String.self, from: dataSourceId, consume: false)

        sample.pkInt = Int(JNIType.toSwift(type: Int64.self, from: pkInt))
        sample.pkInt8 = JNIType.toSwift(type: Int8.self, from: pkInt8)
        sample.pkInt16 = JNIType.toSwift(type: Int16.self, from: pkInt16)
        sample.pkInt32 = JNIType.toSwift(type: Int32.self, from: pkInt32)
        sample.pkInt64 = JNIType.toSwift(type: Int64.self, from: pkInt64)
        sample.pkBool = JNIType.toSwift(type: Bool.self, from: pkBool)

        sample.string1 = JNIType.toSwift(type: String.self, from: string1, consume: false)
        sample.string2 = JNIType.toSwift(type: String.self, from: string2, consume: false)
        sample.string3 = JNIType.toSwift(type: String.self, from: string3, consume: false)
        sample.string4 = JNIType.toSwift(type: String.self, from: string4, consume: false)
        sample.string5 = JNIType.toSwift(type: String.self, from: string5, consume: false)
        sample.string6 = JNIType.toSwift(type: String.self, from: string6, consume: false)

        return jlong(Int(bitPattern: Unmanaged.passRetained(sample).toOpaque()))
    }
    
    public convenience init(javaObject: jobject?) {
        self.init()
        
        self.dataSourceId = String(javaObject: JNI.api.GetObjectField(JNI.env, javaObject, SampleClass.javaDataSourceId))
        
        self.pkInt = Int(JNI.api.GetLongField(JNI.env, javaObject, SampleClass.javaPkInt))
        self.pkInt8 = JNI.api.GetByteField(JNI.env, javaObject, SampleClass.javaPkInt8)
        self.pkInt16 = JNI.api.GetShortField(JNI.env, javaObject, SampleClass.javaPkInt16)
        self.pkInt32 = Int32(JNI.api.GetIntField(JNI.env, javaObject, SampleClass.javaPkInt32))
        self.pkInt64 = JNI.api.GetLongField(JNI.env, javaObject, SampleClass.javaPkInt64)
        self.pkBool = JNI.api.GetBooleanField(JNI.env, javaObject, SampleClass.javaPkBool) == JNI_TRUE
        
        self.string1 = String(javaObject: JNI.api.GetObjectField(JNI.env, javaObject, SampleClass.javaString1))
        self.string2 = String(javaObject: JNI.api.GetObjectField(JNI.env, javaObject, SampleClass.javaString2))
        self.string3 = String(javaObject: JNI.api.GetObjectField(JNI.env, javaObject, SampleClass.javaString3))
        self.string4 = String(javaObject: JNI.api.GetObjectField(JNI.env, javaObject, SampleClass.javaString4))
        self.string5 = String(javaObject: JNI.api.GetObjectField(JNI.env, javaObject, SampleClass.javaString5))
        self.string6 = String(javaObject: JNI.api.GetObjectField(JNI.env, javaObject, SampleClass.javaString6))
    }
    
    
    public func toJava() -> jobject? {
        var locals = [jobject]()
//        var args = [jvalue]()
//        args.append(JNIType.toJava(value: self.dataSourceId, locals: &locals))
//
//        args.append(JNIType.toJava(value: self.pkInt, locals: &locals))
//        args.append(JNIType.toJava(value: self.pkInt8, locals: &locals))
//        args.append(JNIType.toJava(value: self.pkInt16, locals: &locals))
//        args.append(JNIType.toJava(value: self.pkInt32, locals: &locals))
//        args.append(JNIType.toJava(value: self.pkInt64, locals: &locals))
//        args.append(JNIType.toJava(value: self.pkBool, locals: &locals))
//
//        args.append(JNIType.toJava(value: self.string1, locals: &locals))
//        args.append(JNIType.toJava(value: self.string2, locals: &locals))
//        args.append(JNIType.toJava(value: self.string3, locals: &locals))
//        args.append(JNIType.toJava(value: self.string4, locals: &locals))
//        args.append(JNIType.toJava(value: self.string5, locals: &locals))
//        args.append(JNIType.toJava(value: self.string6, locals: &locals))
//
//        let object: jobject? = JNIMethod.NewObject(className: "com/readdle/swiftjnibridge/SampleClass",
//                                         classCache: &SampleClass.javaClass,
//                                         methodSig: "(Ljava/lang/String;JBSIJZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
//                                         methodCache: &SampleClass.javaConstructor,
//                                         args: &args,
//                                         locals: &locals)
//        return object
        
        let object: jobject? = JNI.api.NewObjectA(JNI.env, SampleClass.javaClass, SampleClass.javaConstructor2, nil)

        JNI.api.SetObjectField(JNI.env, object, SampleClass.javaDataSourceId, self.dataSourceId?.localJavaObject(&locals))
        
        JNI.api.SetLongField(JNI.env, object, SampleClass.javaPkInt, Int64(self.pkInt))
        JNI.api.SetByteField(JNI.env, object, SampleClass.javaPkInt8, self.pkInt8)
        JNI.api.SetShortField(JNI.env, object, SampleClass.javaPkInt16, self.pkInt16)
        JNI.api.SetIntField(JNI.env, object, SampleClass.javaPkInt32, jint(self.pkInt32))
        JNI.api.SetLongField(JNI.env, object, SampleClass.javaPkInt64, self.pkInt64)
        JNI.api.SetBooleanField(JNI.env, object, SampleClass.javaPkBool, jboolean(self.pkBool ? JNI_TRUE : JNI_FALSE))

        JNI.api.SetObjectField(JNI.env, object, SampleClass.javaString1, self.string1?.localJavaObject(&locals))
        JNI.api.SetObjectField(JNI.env, object, SampleClass.javaString2, self.string2?.localJavaObject(&locals))
        JNI.api.SetObjectField(JNI.env, object, SampleClass.javaString3, self.string3?.localJavaObject(&locals))
        JNI.api.SetObjectField(JNI.env, object, SampleClass.javaString4, self.string4?.localJavaObject(&locals))
        JNI.api.SetObjectField(JNI.env, object, SampleClass.javaString5, self.string5?.localJavaObject(&locals))
        JNI.api.SetObjectField(JNI.env, object, SampleClass.javaString6, self.string6?.localJavaObject(&locals))

        return JNI.check(object, &locals)
    }
    
}

// MARK: PROTO extension
extension SampleClassProto {
    
    static var javaClass = JNI.GlobalFindClass("com/readdle/swiftjnibridge/SampleClass")
    static var javaConstructor = JNI.api.GetStaticMethodID(JNI.env, SampleClass.javaClass, "createSampleClassProto",
                                                                      "(Ljava/nio/ByteBuffer;)Ljava/lang/Object;")
    
    init?(byteArray: jarray?) {
        var isCopied: jboolean = 0
        let byteCount = JNI.api.GetArrayLength(JNI.env, byteArray)
        let bytes = JNI.api.GetByteArrayElements(JNI.env, byteArray, &isCopied)
        let data = Data(bytesNoCopy: bytes!, count: Int(byteCount), deallocator: Data.Deallocator.none)
        guard let proto = try? SampleClassProto(serializedData: data) else {
            return nil
        }
        self = proto
    }
    
    func toJava() -> jobject? {
        guard var data = try? self.serializedData() else {
            return nil
        }
        let size = data.count
        return data.withUnsafeMutableBytes({ (pointer: UnsafeMutablePointer<Int8>) -> jobject? in
            var args = [jvalue]()
            args.append(jvalue.init(l: JNI.api.NewDirectByteBuffer(JNI.env, UnsafeMutableRawPointer(pointer), jlong(size))))
            let result = args.withUnsafeBufferPointer({
                return JNI.api.CallStaticObjectMethodA(JNI.env, SampleClassProto.javaClass, SampleClassProto.javaConstructor, $0.baseAddress)
            })
            JNI.api.DeleteLocalRef(JNI.env, args[0].l)
            return result
        })
    }
}
