//
//  Keychain.swift
//  DynamicKeychain
//
//  Created by Marcos del Castillo Camacho on 23/03/2026.
//

import SwiftUI

@propertyWrapper public struct Keychain<T: Sendable>: DynamicProperty, Sendable {
    private let key: String
    private let store: KeychainStore

    @State private var defaultValue: T
    
    public var wrappedValue: T {
        get { (try? Keychain<T>.decode(store.load(key) ?? Data())) ?? defaultValue }
        nonmutating set {
            var hasValue = false
            if T.self is ExpressibleByNilLiteral.Type {
                if "\(newValue)" != "nil" { hasValue = true }
            } else {
                hasValue = true
            }

            if hasValue {
                try? store.save(key, Keychain<T>.encode(newValue))
            } else {
                store.delete(key)
            }
            defaultValue = newValue
        }
    }
    
    public var projectedValue: Binding<T> { .init(get: { wrappedValue }, set: { wrappedValue = $0 }) }
    
    private init(wrappedValue: T, key: String, store: KeychainStore = .shared) {
        self.key = key
        self.store = store
        if let value = store.load(key) {
            _defaultValue = State(initialValue: (try? Keychain<T>.decode(value)) ?? wrappedValue)
        } else {
            _defaultValue = State(initialValue: wrappedValue)
        }
    }

    public init(wrappedValue: T, _ key: String, store: KeychainStore = .shared) where T == Bool {
        self.init(wrappedValue: wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: T, _ key: String, store: KeychainStore = .shared) where T == Int {
        self.init(wrappedValue: wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: T, _ key: String, store: KeychainStore = .shared) where T == Float {
        self.init(wrappedValue: wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: T, _ key: String, store: KeychainStore = .shared) where T == Double {
        self.init(wrappedValue: wrappedValue, key: key, store: store)
    }
    
    public init(wrappedValue: T, _ key: String, store: KeychainStore = .shared) where T == String {
        self.init(wrappedValue: wrappedValue, key: key, store: store)
    }
        
    public init(wrappedValue: T, _ key: String, store: KeychainStore = .shared) where T == Date {
        self.init(wrappedValue: wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: T, _ key: String, store: KeychainStore = .shared) where T == Data {
        self.init(wrappedValue: wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: T, _ key: String, store: KeychainStore = .shared) where T: RawRepresentable, T.RawValue == Int {
        self.init(wrappedValue: wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: T, _ key: String, store: KeychainStore = .shared) where T: RawRepresentable, T.RawValue == String {
        self.init(wrappedValue: wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: T, _ key: String, store: KeychainStore = .shared) where T: RawRepresentable, T.RawValue == Codable {
        self.init(wrappedValue: wrappedValue, key: key, store: store)
    }

    
    private static func encode(_ value: T) throws -> Data {
        switch value {
        case let codable as Codable: try JSONEncoder().encode(codable)
        case let storable as DataConvertible: storable.data
        case let representable as any RawRepresentable where representable.rawValue is Int:
            withUnsafeBytes(of: representable.rawValue) { Data($0) }
        case let representable as any RawRepresentable where representable.rawValue is String:
            withUnsafeBytes(of: representable.rawValue) { Data($0) }
        default: throw KeychainError.conversionError
        }
    }
        
    private static func decode(_ data: Data) throws -> T {
        if let type = T.self as? DataConvertible.Type, let value = type.init(data: data) as? T {
            return value
        } else if let type = T.self as? Codable.Type {
            return try JSONDecoder().decode(type, from: data) as! T
        } else if let type = T.self as? any RawRepresentable<Int>.Type {
            var value: Int = 0
            guard data.count == MemoryLayout.size(ofValue: value) else { throw KeychainError.conversionError }
            _ = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
            guard let result = type.init(rawValue: value) as? T else { throw KeychainError.conversionError }
            return result
        } else if let type = T.self as? any RawRepresentable<String>.Type {
            var value: String = ""
            guard data.count == MemoryLayout.size(ofValue: value) else { throw KeychainError.conversionError }
            _ = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
            guard let result = type.init(rawValue: value) as? T else { throw KeychainError.conversionError }
            return result
        }  else if let optionalType = T.self as? AnyOptional.Type {
            if let type = optionalType.wrappedType as? any RawRepresentable<Int>.Type {
                var value: Int = 0
                guard data.count == MemoryLayout.size(ofValue: value) else { throw KeychainError.conversionError }
                _ = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
                guard let result = type.init(rawValue: value) as? T else { throw KeychainError.conversionError }
                return result
            } else if let type = optionalType.wrappedType as? any RawRepresentable<String>.Type {
                var value: String = ""
                guard data.count == MemoryLayout.size(ofValue: value) else { throw KeychainError.conversionError }
                _ = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
                guard let result = type.init(rawValue: value) as? T else { throw KeychainError.conversionError }
                return result
            }
        }

        throw KeychainError.conversionError
    }
}

extension Keychain where T: ExpressibleByNilLiteral {
    private init(key: String, store: KeychainStore = .shared) {
        self.key = key
        self.store = store
        if let value = store.load(key), let decoded = try? Keychain<T>.decode(value) {
            _defaultValue = State(initialValue: decoded)
        } else {
            _defaultValue = State(initialValue: nil)
        }
    }

    public init(_ key: String, store: KeychainStore = .shared) where T == Bool? {
        self.init(key: key, store: store)
    }

    public init(_ key: String, store: KeychainStore = .shared) where T == Int? {
        self.init(key: key, store: store)
    }

    public init(_ key: String, store: KeychainStore = .shared) where T == Float? {
        self.init(key: key, store: store)
    }

    public init(_ key: String, store: KeychainStore = .shared) where T == Double? {
        self.init(key: key, store: store)
    }
    
    public init(_ key: String, store: KeychainStore = .shared) where T == String? {
        self.init(key: key, store: store)
    }
    
    public init(_ key: String, store: KeychainStore = .shared) where T == Date? {
        self.init(key: key, store: store)
    }

    public init(_ key: String, store: KeychainStore = .shared) where T == Data? {
        self.init(key: key, store: store)
    }

    public init<R>(_ key: String, store: KeychainStore = .shared) where T == R?, R: RawRepresentable, R.RawValue == Int {
        self.init(key: key, store: store)
    }
    
    public init<R>(_ key: String, store: KeychainStore = .shared) where T == R?, R: RawRepresentable, R.RawValue == String {
        self.init(key: key, store: store)
    }
    
    public init<R>(_ key: String, store: KeychainStore = .shared) where T == R?, R: RawRepresentable, R.RawValue == Codable {
        self.init(key: key, store: store)
    }
}

// MARK: DataConvertible: Protocol to transform to and from Data
protocol DataConvertible {
    init?(data: Data)
    var data: Data { get }
}

extension DataConvertible where Self: Numeric {
    init?(data: Data) {
        var value: Self = 0
        guard data.count == MemoryLayout.size(ofValue: value) else { return nil }
        _ = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
        self = value
    }

    var data: Data { withUnsafeBytes(of: self) { Data($0) } }
}

extension DataConvertible where Self: StringProtocol {
    init?(data: Data) {
        var value: Self = ""
        guard data.count == MemoryLayout.size(ofValue: value) else { return nil }
        _ = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
        self = value
    }

    var data: Data { withUnsafeBytes(of: self) { Data($0) } }
}

// MARK: AnyOptional: Protocol to check for Optional types
protocol AnyOptional {
    static var wrappedType: Any.Type { get }
}

extension Optional: AnyOptional {
    static var wrappedType: Any.Type { Wrapped.self }
}
