
import java_swift
import Foundation
import Dispatch

public class ComplexClass: Encodable {
    
    public var sampleClass: SampleClass?
    public var stringNil: String?
    public var stringArray: [String] = ["first", "second", "third"]
    public var numberArray: [Int] = [1, 2, 3]

    public var objectArray = [SampleClass]()
    public var dictSampleClass = [String: SampleClass]()
    public var dictStrings = [String: String]()
    
}

@_silgen_name("Java_com_readdle_swiftjnibridge_MainActivity_createDataSource")
public func mainActivity_createDataSource( __env: UnsafeMutablePointer<JNIEnv?>, __this: jobject?)-> jobject? {
    return DataSource().toJava()
}

@_silgen_name("Java_com_readdle_swiftjnibridge_MainActivity_jniEncode")
public func mainActivity_jniEncode( __env: UnsafeMutablePointer<JNIEnv?>, __this: jobject?) -> jobject? {
    
    let dataSource = DataSource()
    
    let encodable = ComplexClass()
    encodable.sampleClass = dataSource.randomSampleObject()
    encodable.objectArray.append(dataSource.randomSampleObject())
    encodable.dictSampleClass["1"] = dataSource.randomSampleObject()
    encodable.dictStrings["1"] = "2"
    
    do {
        NSLog("TRY to encode with JavaEncoder")
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(encodable)
        NSLog(String(data: data, encoding: .utf8) ?? "(null)")
        
        let javaEncoder = JavaEncoder(forPackage: "com/readdle/swiftjnibridge")
        let object = try javaEncoder.encode(encodable)
        
        return object
    }
    catch let error as JNIError {
        error.throw()
        return nil
    }
    catch let error {
        NSLog("Unkwnon error: \(error)")
        return nil
    }
}

public func convertToJavaJSON<T: Encodable>( _ encodable: T)-> jstring? {
    let jsonEncoder = JSONEncoder()
    guard let jsonData = try? jsonEncoder.encode(encodable) else {
        return nil
    }
    // jsonData not null-terminated :(
    let jsonString = String(data: jsonData, encoding: .utf8)
    return JNI.api.NewStringUTF(JNI.env, jsonString)
}

public func parseFromJavaJSON<T: Decodable>(_ jsonString: jstring?) -> T? {
    var isCopy: jboolean = 0
    if let bytes = JNI.api.GetStringUTFChars(JNI.env, jsonString, &isCopy) {
        defer {
            JNI.api.ReleaseStringUTFChars(JNI.env, jsonString, bytes)
        }
        let size = JNI.api.GetStringUTFLength(JNI.env, jsonString)
        let data = Data(bytesNoCopy: UnsafeMutableRawPointer.init(mutating: bytes), count: Int(size), deallocator: Data.Deallocator.none)
        let decoder = JSONDecoder()
        if let decodable = try? decoder.decode(T.self, from: data) {
            return decodable
        }
    }
    return nil
}

extension JNICore {
    
    open func GlobalFindClass( _ name: UnsafePointer<Int8>,
                               _ file: StaticString = #file, _ line: Int = #line ) -> jclass? {
        guard let clazz: jclass = FindClass(name, file, line ) else {
            return nil
        }
        let result = api.NewGlobalRef(env, clazz)
        api.DeleteLocalRef(env, clazz)
        return result
    }
    
}
