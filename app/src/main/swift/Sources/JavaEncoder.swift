//
//  JavaEncoder.swift
//  jniBridge
//
//  Created by Andrew on 10/14/17.
//

import Foundation
import CoreFoundation
import java_swift

public enum JavaEncoderError: Error {
    case cantCreateObject(String)
}

fileprivate let JavaHashMapClassname = "java/util/HashMap"
fileprivate let JavaHashMapSig = "Ljava/util/HashMap;"

fileprivate let JavaStringClassname = "java/lang/String"
fileprivate let JavaStringSig = "Ljava/lang/String;"

fileprivate struct JNIStorageObject {
    let sig: String
    let javaClass: String?
    let javaObject: jobject
    
    var isDisctionary: Bool {
        return sig == JavaHashMapSig
    }
}

/// `JavaEncoder` facilitates the encoding of `Encodable` values into JSON.
open class JavaEncoder: Encoder {

    // MARK: Properties
    
    /// The path to the current point in encoding.
    public var codingPath: [CodingKey]
    
    /// Contextual user-provided information for use during encoding.
    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }
    
    fileprivate let package: String
    fileprivate var javaObjects: [JNIStorageObject]
    
    // MARK: - Constructing a JSON Encoder
    /// Initializes `self` with default strategies.
    public init(forPackage: String) {
        self.codingPath = [CodingKey]()
        
        self.package = forPackage
        self.javaObjects = [JNIStorageObject]()
    }
    
    deinit {
        NSLog("JavaEncoder deinit cleanup")
    }
    
    // MARK: - Encoding Values
    /// Encodes the given top-level value and returns its JSON representation.
    ///
    /// - parameter value: The value to encode.
    /// - returns: A new `Data` value containing the encoded JSON data.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    open func encode<T : Encodable>(_ value: T) throws -> jobject {
        let storage = try self.pushInstance(value)
        let javaObject = JNI.api.NewLocalRef(JNI.env, storage.javaObject)!
        try value.encode(to: self)
        return javaObject
    }
    
    // MARK: - Encoder Methods
    public func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
        let storage = self.popInstance()
        let javaObject = storage.javaObject
        
        if storage.isDisctionary {
            let container = JavaHashMapContainer<Key>(referencing: self, codingPath: self.codingPath, javaObject: javaObject)
            return KeyedEncodingContainer(container)
        }
        else {
            let container = JavaObjectContainer<Key>(referencing: self, codingPath: self.codingPath, javaClass: storage.javaClass!, javaObject: javaObject)
            return KeyedEncodingContainer(container)
        }
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        let storage = self.popInstance()
        return JavaArrayContainer(referencing: self, codingPath: self.codingPath, arrayObject: storage.javaObject)
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        return JavaSingleValueEncodingContainer(encoder: self)
    }
}

// MARK: - Encoding Containers
fileprivate class JavaObjectContainer<K : CodingKey> : KeyedEncodingContainerProtocol {
    
    typealias Key = K
    
    // MARK: Properties
    /// A reference to the encoder we're writing to.
    private let encoder: JavaEncoder
    
    private var javaClass: String
    private var javaObject: jobject
    
    /// The path of coding keys taken to get to this point in encoding.
    private(set) public var codingPath: [CodingKey]
    
    // MARK: - Initialization
    /// Initializes `self` with the given references.
    fileprivate init(referencing encoder: JavaEncoder, codingPath: [CodingKey], javaClass: String, javaObject: jobject) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.javaClass = javaClass
        self.javaObject = javaObject
    }
    
    deinit {
        NSLog("Deinit \(javaClass)")
        JNI.api.DeleteLocalRef(JNI.env, javaObject)
    }
    
    // MARK: - KeyedEncodingContainerProtocol Methods
    public func encodeNil(forKey key: Key) throws {
        // Ignoring
    }
    
    public func encode(_ value: Bool, forKey key: Key) throws {
        let filed = try getJavaField(forClass: javaClass, field: key.stringValue, sig: "Z")
        JNI.api.SetBooleanField(JNI.env, javaObject, filed, jboolean(value ? JNI_TRUE : JNI_FALSE))
    }
    
    public func encode(_ value: Int, forKey key: Key) throws {
        let filed = try getJavaField(forClass: javaClass, field: key.stringValue, sig: "J")
        JNI.api.SetLongField(JNI.env, javaObject, filed, Int64(value))
    }
    public func encode(_ value: Int8, forKey key: Key) throws {
        let filed = try getJavaField(forClass: javaClass, field: key.stringValue, sig: "B")
        JNI.api.SetByteField(JNI.env, javaObject, filed, value)
    }
    public func encode(_ value: Int16, forKey key: Key) throws {
        let filed = try getJavaField(forClass: javaClass, field: key.stringValue, sig: "S")
        JNI.api.SetShortField(JNI.env, javaObject, filed, value)
    }
    public func encode(_ value: Int32, forKey key: Key) throws {
        let filed = try getJavaField(forClass: javaClass, field: key.stringValue, sig: "I")
        JNI.api.SetIntField(JNI.env, javaObject, filed, jint(value))
    }
    public func encode(_ value: Int64, forKey key: Key) throws {
        let filed = try getJavaField(forClass: javaClass, field: key.stringValue, sig: "J")
        JNI.api.SetLongField(JNI.env, javaObject, filed, value)
    }
    
    public func encode(_ value: String, forKey key: Key) throws {
        let filed = try getJavaField(forClass: javaClass, field: key.stringValue, sig: "Ljava/lang/String;")
        var locals = [jobject]()
        JNI.check(JNI.api.SetObjectField(JNI.env, javaObject, filed, value.localJavaObject(&locals)), &locals)
    }
    
    public func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
        let object = try self.encoder.pushInstance(value)
        let filed = try getJavaField(forClass: self.javaClass, field: key.stringValue, sig: object.sig)
        JNI.api.SetObjectField(JNI.env, self.javaObject, filed, object.javaObject)
        try value.encode(to: self.encoder)
    }
    
    public func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        preconditionFailure("Not implemented: nestedContainer")
    }
    
    public func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        preconditionFailure("Not implemented: nestedUnkeyedContainer")
    }
    
    public func superEncoder() -> Encoder {
        preconditionFailure("Not implemented: superEncoder")
    }
    
    public func superEncoder(forKey key: Key) -> Encoder {
        preconditionFailure("Not implemented: superEncoder")
    }
}


// MARK: - Encoding Containers
fileprivate class JavaHashMapContainer<K : CodingKey> : KeyedEncodingContainerProtocol {
    
    typealias Key = K
    
    // MARK: Properties
    /// A reference to the encoder we're writing to.
    private let encoder: JavaEncoder
    
    private var javaObject: jobject
    private var javaPutMethod: jmethodID?
    
    /// The path of coding keys taken to get to this point in encoding.
    private(set) public var codingPath: [CodingKey]
    
    // MARK: - Initialization
    /// Initializes `self` with the given references.
    fileprivate init(referencing encoder: JavaEncoder, codingPath: [CodingKey], javaObject: jobject) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.javaObject = javaObject
    }
    
    deinit {
        NSLog("Deinit hashmap")
        JNI.api.DeleteLocalRef(JNI.env, javaObject)
    }
    
    // MARK: - KeyedEncodingContainerProtocol Methods
    public func encodeNil(forKey key: Key) throws {
        // Ignoring
    }
    
    public func encode(_ value: String, forKey key: Key) throws {
        var locals = [jobject]()
        var args = [jvalue]()
        args.append(jvalue(l: key.stringValue.localJavaObject(&locals)))
        args.append(jvalue(l: value.localJavaObject(&locals)))
        //TODO: clear locals here
        _ = JNIMethod.CallObjectMethod(object: self.javaObject,
                                   methodName: "put",
                                   methodSig: "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;",
                                   methodCache: &javaPutMethod,
                                   args: &args, locals: &locals)
    }
    
    public func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
        if value is String {
            try self.encode(value as! String, forKey: key)
            return
        }

        let object = try self.encoder.pushInstance(value)
        var locals = [jobject]()
        var args = [jvalue]()
        args.append(jvalue(l: key.stringValue.localJavaObject(&locals)))
        args.append(jvalue(l: object.javaObject))
        
        //TODO: clear locals here
        _ = JNIMethod.CallObjectMethod(object: self.javaObject,
                                   methodName: "put",
                                   methodSig: "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;",
                                   methodCache: &javaPutMethod,
                                   args: &args, locals: &locals)
        
        try value.encode(to: self.encoder)
    }
    
    public func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        preconditionFailure("Not implemented: nestedContainer")
    }
    
    public func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        preconditionFailure("Not implemented: nestedUnkeyedContainer")
    }
    
    public func superEncoder() -> Encoder {
        preconditionFailure("Not implemented: superEncoder")
    }
    
    public func superEncoder(forKey key: Key) -> Encoder {
        preconditionFailure("Not implemented: superEncoder")
    }
}

fileprivate class JavaArrayContainer : UnkeyedEncodingContainer {
    // MARK: Properties
    /// A reference to the encoder we're writing to.
    private let encoder: JavaEncoder
    
    /// The path of coding keys taken to get to this point in encoding.
    private(set) public var codingPath: [CodingKey]
    
    /// The number of elements encoded into the container.
    public private(set) var count: Int = 0
    
    private let javaObject: jobject
    
    // MARK: - Initialization
    /// Initializes `self` with the given references.
    fileprivate init(referencing encoder: JavaEncoder, codingPath: [CodingKey], arrayObject: jobject) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.javaObject = arrayObject
    }
    
    deinit {
        NSLog("Deinit array")
        JNI.api.DeleteLocalRef(JNI.env, javaObject)
    }
    
    // MARK: - UnkeyedEncodingContainer Methods
    public func encodeNil() throws {  }
    
    public func encode(_ value: Int) throws {
        var value = jlong(value)
        JNI.api.SetLongArrayRegion(JNI.env, self.javaObject, jsize(count), 1, &value)
        count += 1
    }
    
    public func encode(_ value: String) throws {
        var locals = [jobject]()
        JNI.check(JNI.api.SetObjectArrayElement(JNI.env,
                                      self.javaObject,
                                      jsize(self.count),
                                      value.localJavaObject(&locals)), &locals)
        count += 1
    }
    
    public func encode<T : Encodable>(_ value: T) throws {
        if value is String {
            try self.encode(value as! String)
            return
        }
        if value is Int {
            try self.encode(value as! Int)
            return
        }

        let storeObject = try self.encoder.pushInstance(value)
        JNI.api.SetObjectArrayElement(JNI.env,
                                      self.javaObject,
                                      jsize(self.count),
                                      storeObject.javaObject)
        
        try value.encode(to: self.encoder)
        
        count += 1
    }
    
    public func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        preconditionFailure("Not implemented: nestedContainer")
    }
    
    public func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        preconditionFailure("Not implemented: nestedUnkeyedContainer")
    }
    
    public func superEncoder() -> Encoder {
        preconditionFailure("Not implemented: superEncoder")
    }
}

class JavaSingleValueEncodingContainer: SingleValueEncodingContainer {
    
    var codingPath: [CodingKey]
    let encoder: JavaEncoder
    
    init(encoder: JavaEncoder) {
        self.codingPath = [CodingKey]()
        self.encoder = encoder
    }
    
    public func encodeNil() throws {

    }
    
    public func encode<T : Encodable>(_ value: T) throws {
        try self.encoder.pushInstance(value)
        try value.encode(to: self.encoder)
    }
}

extension JavaEncoder {
    
    fileprivate func getFullClassName<T>(_ value: T) -> String{
        if value is [String: Encodable] {
            return JavaHashMapClassname
        }
        return package  + "/" + String(describing: type(of: value))
    }
    
    @discardableResult
    fileprivate func pushInstance<T: Encodable>(_ value: T) throws -> JNIStorageObject {
        NSLog("PushInstance: \(String(describing: type(of: value)))")
        let storage: JNIStorageObject
        if T.self == [String].self {
            let value = value as! [String]
            let javaClass = try getJavaClass(JavaStringClassname)
            guard let javaObject = JNI.api.NewObjectArray(JNI.env, jsize(value.count), javaClass, nil) else {
                throw JavaEncoderError.cantCreateObject("\(JavaStringClassname)[]")
            }
            //locals.append(javaObject)
            storage = JNIStorageObject(sig: "[L\(JavaStringClassname);", javaClass: nil, javaObject: javaObject)
        }
        else if T.self == [Int].self {
            let value = value as! [Int]
            guard let javaObject = JNI.api.NewLongArray(JNI.env, jsize(value.count)) else {
                throw JavaEncoderError.cantCreateObject("long[]")
            }
            //locals.append(javaObject)
            storage = JNIStorageObject(sig: "[J", javaClass: nil, javaObject: javaObject)
        }
        else if let value = value as? [Encodable] {
            let fullClassName = package  + "/" + String(describing: type(of: value[0]))
            NSLog("try to pushInstance \(fullClassName)[]")
            let javaClass = try getJavaClass(fullClassName)
            guard let javaObject = JNI.api.NewObjectArray(JNI.env, jsize(value.count), javaClass, nil) else {
                throw JavaEncoderError.cantCreateObject("\(fullClassName)[]")
            }
            //locals.append(javaObject)
            storage = JNIStorageObject(sig: "[L\(fullClassName);", javaClass: nil, javaObject: javaObject)
        }
        else {
            let fullClassName = getFullClassName(value)
            NSLog("try to pushInstance \(fullClassName)")
            let javaClass = try getJavaClass(fullClassName)
            let emptyContructor = try getJavaEmptyConstructor(forClass: fullClassName)
            guard let javaObject = JNI.api.NewObjectA(JNI.env, javaClass, emptyContructor, nil) else {
                throw JavaEncoderError.cantCreateObject(fullClassName)
            }
            //locals.append(javaObject)
            storage = JNIStorageObject(sig: "L\(fullClassName);", javaClass: fullClassName, javaObject: javaObject)
        }
        javaObjects.append(storage)
        return storage
    }
    
    fileprivate func popInstance() -> JNIStorageObject {
        guard let javaObject = self.javaObjects.popLast() else {
            preconditionFailure("No instances in stack")
        }
        return javaObject
    }
}
