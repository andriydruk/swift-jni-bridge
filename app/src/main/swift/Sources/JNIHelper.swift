//
//  JNIHelper.swift
//  jniBridge
//
//  Created by Andrew on 10/18/17.
//

import Foundation
import java_swift

public enum JNIError: Error {
    case classNotFoundException(String)
    case methodNotFoundException(String)
    case fieldNotFoundException(String)
}

fileprivate extension NSLock {
    
    func sync<T>(_ block: () throws -> T) throws -> T {
        self.lock()
        defer {
            self.unlock()
        }
        return try block()
    }
}
    
fileprivate var javaClasses = [String: jclass]()
fileprivate var javaMethods = [String: jmethodID]()
fileprivate var javaFields = [String: jmethodID]()

fileprivate let javaClassesLock = NSLock()
fileprivate let javaMethodLock = NSLock()
fileprivate let javaFieldLock = NSLock()

func getJavaClass(_ className: String) throws -> jclass {
    if let javaClass = javaClasses[className] {
        return javaClass
    }
    return try javaClassesLock.sync {
        if let javaClass = javaClasses[className] {
            return javaClass
        }
        guard let javaClass = JNI.GlobalFindClass(className) else {
            throw JNIError.classNotFoundException(className)
        }
        javaClasses[className] = javaClass
        return javaClass
    }
}

func getJavaEmptyConstructor(forClass className: String) throws -> jmethodID? {
    return try getJavaMethod(forClass: className, method: "<init>", sig: "()V")
}

func getJavaMethod(forClass className: String, method: String, sig: String) throws -> jmethodID {
    let key = className + method + sig
    let javaClass = try getJavaClass(className)
    if let methodID = javaMethods[key] {
        return methodID
    }
    return try javaMethodLock.sync {
        if let methodID = javaMethods[key] {
            return methodID
        }
        guard let javaMethodID = JNI.api.GetMethodID(JNI.env, javaClass, method, sig) else {
            throw JNIError.methodNotFoundException(className)
        }
        javaMethods[key] = javaMethodID
        return javaMethodID
    }
}

func getJavaField(forClass className: String, field: String, sig: String) throws -> jfieldID {
    let key = className + field + sig
    let javaClass = try getJavaClass(className)
    if let fieldID = javaFields[key] {
        return fieldID
    }
    return try javaFieldLock.sync({
        if let fieldID = javaFields[key] {
            return fieldID
        }
        guard let fieldID = JNI.api.GetFieldID(JNI.env, javaClass, field, sig) else {
            throw JNIError.fieldNotFoundException(className)
        }
        javaFields[key] = fieldID
        return fieldID
        
    })
}
