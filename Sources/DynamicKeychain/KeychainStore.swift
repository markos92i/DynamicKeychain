//
//  KeychainStore.swift
//  Randstad Empleo
//
//  Created by Marcos del Castillo Camacho on 23/1/25.
//  Copyright © 2025 SNGULAR. All rights reserved.
//

import Foundation

public struct KeychainStore: Sendable {
    public static let shared = KeychainStore()
    
    private let accesibility: KeychainAccesibility
    private let bundleIdentifier = Bundle.main.bundleIdentifier

    public init(accesibility: KeychainAccesibility = .whenUnlocked) {
        self.accesibility = accesibility
    }
    
    public func load(_ key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleIdentifier as Any,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessible as String: accesibility.secAccessibility
        ]
        
        var result: AnyObject?
        let status = KeychainStatus(status: SecItemCopyMatching(query as CFDictionary, &result))
                
        do {
            switch status {
            case .success:
                guard let data = result as? Data else { throw KeychainStatus.unexpectedError }
                
                return data
            case .itemNotFound:
                print("OSStatus error:[\(status.rawValue)] \(status.description)")
                return nil
            default:
                if status != .userCanceled {
                    print("OSStatus error:[\(status.rawValue)] \(status.description)")
                }

                throw status
            }
        } catch {
            return nil
        }
    }

    public func save(_ key: String, _ data: Data) {
        print("save: \(key)")
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleIdentifier as Any,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: accesibility.secAccessibility
        ]
        
        let status = KeychainStatus(status: SecItemAdd(query as CFDictionary, nil))
        
        if status == .duplicateItem {
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: bundleIdentifier as Any,
                kSecAttrAccount as String: key,
                kSecAttrAccessible as String: accesibility.secAccessibility
            ]
            
            let attributes: [String: Any] = [
                kSecValueData as String: data,
            ]
            
            SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
        }
    }
    
    public func delete(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleIdentifier as Any,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    public func delete(_ keys: [String]) {
        for key in keys { delete(key) }
    }

    public func deleteAll() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleIdentifier as Any
        ]

        SecItemDelete(query as CFDictionary)
    }
}
