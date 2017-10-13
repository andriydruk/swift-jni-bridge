
import java_swift
import Foundation
import Dispatch

@_silgen_name("Java_com_readdle_swiftjnibridge_MainActivity_createDataSource")
public func mainActivity_createDataSource( __env: UnsafeMutablePointer<JNIEnv?>, __this: jobject?)-> jobject? {
    return DataSource().toJava()
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
