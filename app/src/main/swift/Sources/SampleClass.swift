
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
                                                     "(Ljava/lang/String;JBSIJZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    
    @_silgen_name("Java_com_readdle_swiftjnibridge_SampleClass_toSwift")
    public static func toSwift(_ env: UnsafeMutablePointer<JNIEnv?>,
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
    
    public func toJava() -> jobject? {
        var locals = [jobject]()
        var args = [jvalue]()
        args.append(JNIType.toJava(value: self.dataSourceId, locals: &locals))
        
        args.append(JNIType.toJava(value: self.pkInt, locals: &locals))
        args.append(JNIType.toJava(value: self.pkInt8, locals: &locals))
        args.append(JNIType.toJava(value: self.pkInt16, locals: &locals))
        args.append(JNIType.toJava(value: self.pkInt32, locals: &locals))
        args.append(JNIType.toJava(value: self.pkInt64, locals: &locals))
        args.append(JNIType.toJava(value: self.pkBool, locals: &locals))
        
        args.append(JNIType.toJava(value: self.string1, locals: &locals))
        args.append(JNIType.toJava(value: self.string2, locals: &locals))
        args.append(JNIType.toJava(value: self.string3, locals: &locals))
        args.append(JNIType.toJava(value: self.string4, locals: &locals))
        args.append(JNIType.toJava(value: self.string5, locals: &locals))
        args.append(JNIType.toJava(value: self.string6, locals: &locals))
        
        let object: jobject? = JNIMethod.NewObject(className: "com/readdle/swiftjnibridge/SampleClass",
                                         classCache: &SampleClass.javaClass,
                                         methodSig: "(Ljava/lang/String;JBSIJZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                                         methodCache: &SampleClass.javaConstructor,
                                         args: &args,
                                         locals: &locals)
        
        return object
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
