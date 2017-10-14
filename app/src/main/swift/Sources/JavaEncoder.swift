//
//  JavaEncoder.swift
//  jniBridge
//
//  Created by Andrew on 10/14/17.
//

import Foundation
import CoreFoundation

/// `JavaEncoder` facilitates the encoding of `Encodable` values into JSON.
open class JavaEncoder {

    
    /// Contextual user-provided information for use during encoding.
    open var userInfo: [CodingUserInfoKey : Any] = [:]
    
    // MARK: - Constructing a JSON Encoder
    /// Initializes `self` with default strategies.
    public init() {}
    
    // MARK: - Encoding Values
    /// Encodes the given top-level value and returns its JSON representation.
    ///
    /// - parameter value: The value to encode.
    /// - returns: A new `Data` value containing the encoded JSON data.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    open func encode<T : Encodable>(_ value: T) throws -> Data? {
        let encoder = _JavaEncoder()
        try value.encode(to: encoder)
        NSLog("CodePath: \(encoder.codingPath)")
        return nil
    }
}

// MARK: - _JavaEncoder
fileprivate class _JavaEncoder : Encoder {
    // MARK: Properties
    
    /// The path to the current point in encoding.
    public var codingPath: [CodingKey]
    
    /// Contextual user-provided information for use during encoding.
    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }
    
    // MARK: - Initialization
    /// Initializes `self` with the given top-level encoder options.
    fileprivate init(codingPath: [CodingKey] = []) {
        //self.storage = _JSONEncodingStorage()
        self.codingPath = codingPath
    }
    
    // MARK: - Encoder Methods
    public func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
        NSLog("container<Key> keyedBy: \(keyedBy.self) \(self.codingPath)")
        
        let container = JavaKeyedEncodingContainer<Key>(referencing: self, codingPath: self.codingPath)
        return KeyedEncodingContainer(container)
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        NSLog("unkeyedContainer")
        return JavaUnkeyedEncodingContainer(referencing: self, codingPath: self.codingPath)
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        return self
    }
}

// MARK: - Encoding Containers
fileprivate struct JavaKeyedEncodingContainer<K : CodingKey> : KeyedEncodingContainerProtocol {
    typealias Key = K
    
    // MARK: Properties
    /// A reference to the encoder we're writing to.
    private let encoder: _JavaEncoder
    
    /// The path of coding keys taken to get to this point in encoding.
    private(set) public var codingPath: [CodingKey]
    
    // MARK: - Initialization
    /// Initializes `self` with the given references.
    fileprivate init(referencing encoder: _JavaEncoder, codingPath: [CodingKey]) {
        self.encoder = encoder
        self.codingPath = codingPath
    }
    
    // MARK: - KeyedEncodingContainerProtocol Methods
    public mutating func encodeNil(forKey key: Key)               throws {
        
    }
    public mutating func encode(_ value: Bool, forKey key: Key)   throws {
        NSLog("Encode \(value) forKey: \(key.stringValue)")
    }
    public mutating func encode(_ value: Int, forKey key: Key)    throws {
        NSLog("Encode \(value) forKey: \(key.stringValue)")
    }
    public mutating func encode(_ value: Int8, forKey key: Key)   throws {
        NSLog("Encode \(value) forKey: \(key.stringValue)")
    }
    public mutating func encode(_ value: Int16, forKey key: Key)  throws {
        NSLog("Encode \(value) forKey: \(key.stringValue)")
    }
    public mutating func encode(_ value: Int32, forKey key: Key)  throws {
        NSLog("Encode \(value) forKey: \(key.stringValue)")
    }
    public mutating func encode(_ value: Int64, forKey key: Key)  throws {
        NSLog("Encode \(value) forKey: \(key.stringValue)")
    }
    public mutating func encode(_ value: UInt, forKey key: Key)   throws {

    }
    public mutating func encode(_ value: UInt8, forKey key: Key)  throws {

    }
    public mutating func encode(_ value: UInt16, forKey key: Key) throws {

    }
    public mutating func encode(_ value: UInt32, forKey key: Key) throws {
        
    }
    public mutating func encode(_ value: UInt64, forKey key: Key) throws {
        
    }
    public mutating func encode(_ value: String, forKey key: Key) throws {
        NSLog("Encode \(value) forKey: \(key.stringValue)")
    }
    
    mutating func encodeIfPresent(_ value: String?, forKey key: K) throws {
        NSLog("Encode \(value ?? "(null)") forKey: \(key.stringValue)")
    }
    
    public mutating func encode(_ value: Float, forKey key: Key)  throws {
        // Since the float may be invalid and throw, the coding path needs to contain this key.
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
    }
    
    public mutating func encode(_ value: Double, forKey key: Key) throws {
        // Since the double may be invalid and throw, the coding path needs to contain this key.
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
    }
    
    public mutating func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
        NSLog("place where you should creat jobject and push to stack")
        //TODO: place where you should creat jobject and push to stack
        try value.encode(to: self.encoder)
    }
    
    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let dictionary = NSMutableDictionary()
        
        self.codingPath.append(key)
        defer { self.codingPath.removeLast() }
        
        let container = JavaKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath)
        return KeyedEncodingContainer(container)
    }
    
    public mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        self.codingPath.append(key)
        defer { self.codingPath.removeLast() }
        return JavaUnkeyedEncodingContainer(referencing: self.encoder, codingPath: self.codingPath)
    }
    
    public mutating func superEncoder() -> Encoder {
        return self.encoder
    }
    
    public mutating func superEncoder(forKey key: Key) -> Encoder {
        return self.encoder
    }
}

fileprivate struct JavaUnkeyedEncodingContainer : UnkeyedEncodingContainer {
    // MARK: Properties
    /// A reference to the encoder we're writing to.
    private let encoder: _JavaEncoder
    
    /// The path of coding keys taken to get to this point in encoding.
    private(set) public var codingPath: [CodingKey]
    
    /// The number of elements encoded into the container.
    public var count: Int {
        return 0
    }
    
    // MARK: - Initialization
    /// Initializes `self` with the given references.
    fileprivate init(referencing encoder: _JavaEncoder, codingPath: [CodingKey]) {
        self.encoder = encoder
        self.codingPath = codingPath
    }
    
    // MARK: - UnkeyedEncodingContainer Methods
    public mutating func encodeNil()             throws {  }
    public mutating func encode(_ value: Bool)   throws {  }
    public mutating func encode(_ value: Int)    throws {  }
    public mutating func encode(_ value: Int8)   throws {  }
    public mutating func encode(_ value: Int16)  throws {  }
    public mutating func encode(_ value: Int32)  throws {  }
    public mutating func encode(_ value: Int64)  throws {  }
    public mutating func encode(_ value: UInt)   throws {  }
    public mutating func encode(_ value: UInt8)  throws {  }
    public mutating func encode(_ value: UInt16) throws {  }
    public mutating func encode(_ value: UInt32) throws {  }
    public mutating func encode(_ value: UInt64) throws {  }
    public mutating func encode(_ value: String) throws {  }
    
    public mutating func encode(_ value: Float)  throws {  }
    public mutating func encode(_ value: Double) throws {  }
    
    public mutating func encode<T : Encodable>(_ value: T) throws {
        NSLog("Encode to array: \(value)")
        self.encoder.codingPath.append(JavaKey(index: self.count))
        defer { self.encoder.codingPath.removeLast() }
    }
    
    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        self.codingPath.append(JavaKey(index: self.count))
        defer { self.codingPath.removeLast() }
        
        let container = JavaKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath)
        return KeyedEncodingContainer(container)
    }
    
    public mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        self.codingPath.append(JavaKey(index: self.count))
        defer { self.codingPath.removeLast() }
        return JavaUnkeyedEncodingContainer(referencing: self.encoder, codingPath: self.codingPath)
    }
    
    public mutating func superEncoder() -> Encoder {
        return self.encoder
    }
}

extension _JavaEncoder : SingleValueEncodingContainer {
    // MARK: - SingleValueEncodingContainer Methods
    fileprivate func assertCanEncodeNewValue() {
        //precondition(self.canEncodeNewValue, "Attempt to encode value through single value container when previously value already encoded.")
    }
    
    public func encodeNil() throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: Bool) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: Int) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: Int8) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: Int16) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: Int32) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: Int64) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: UInt) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: UInt8) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: UInt16) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: UInt32) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: UInt64) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: String) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: Float) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode(_ value: Double) throws {
        assertCanEncodeNewValue()
    }
    
    public func encode<T : Encodable>(_ value: T) throws {
        assertCanEncodeNewValue()
    }
}

//===----------------------------------------------------------------------===//
// Shared Key Types
//===----------------------------------------------------------------------===//
fileprivate struct JavaKey : CodingKey {
    public var stringValue: String
    public var intValue: Int?
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    fileprivate init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
    
    fileprivate static let `super` = JavaKey(stringValue: "super")!
}

