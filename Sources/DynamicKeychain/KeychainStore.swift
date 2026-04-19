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
    private let accessGroup: String?
    
    public init(accesibility: KeychainAccesibility = .whenUnlocked, accessGroup: String? = nil) {
        self.accesibility = accesibility
        self.accessGroup = accessGroup
    }
    
    private func addAccessGroupIfNeeded(to query: [String: Any]) -> [String: Any] {
        var updatedQuery = query
        if let accessGroup {
            updatedQuery[kSecAttrAccessGroup as String] = accessGroup
        }
        return updatedQuery
    }
    
    public func load(_ key: String) -> Data? {
        let baseQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleIdentifier as Any,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessible as String: accesibility.secAccessibility
        ]
        let query = addAccessGroupIfNeeded(to: baseQuery)
        
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
        let baseQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleIdentifier as Any,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: accesibility.secAccessibility
        ]
        let query = addAccessGroupIfNeeded(to: baseQuery)

        let status = KeychainStatus(status: SecItemAdd(query as CFDictionary, nil))
        
        if status == .duplicateItem {
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: bundleIdentifier as Any,
                kSecAttrAccount as String: key,
                kSecAttrAccessible as String: accesibility.secAccessibility
            ]
            let updateQueryRes = addAccessGroupIfNeeded(to: updateQuery)

            let attributes: [String: Any] = [
                kSecValueData as String: data,
            ]
            
            SecItemUpdate(updateQueryRes as CFDictionary, attributes as CFDictionary)
        }
    }
    
    public func delete(_ key: String) {
        let baseQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleIdentifier as Any,
            kSecAttrAccount as String: key
        ]
        let query = addAccessGroupIfNeeded(to: baseQuery)

        SecItemDelete(query as CFDictionary)
    }
    
    public func delete(_ keys: [String]) {
        for key in keys { delete(key) }
    }

    public func deleteAll() {
        let baseQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleIdentifier as Any,
        ]
        let query = addAccessGroupIfNeeded(to: baseQuery)

        SecItemDelete(query as CFDictionary)
    }
}
