//
//  KeychainAccesibility.swift
//  DynamicKeychain
//
//  Created by Marcos del Castillo Camacho on 23/03/2026.
//

import Foundation

public enum KeychainAccesibility: Sendable {
    case whenUnlocked
    case afterFirstUnlock
    case whenPasscodeSet
    case whenUnlockedThisDeviceOnly
    
    var secAccessibility: CFString {
        switch self {
        case .whenUnlocked: kSecAttrAccessibleWhenUnlocked
        case .afterFirstUnlock: kSecAttrAccessibleAfterFirstUnlock
        case .whenPasscodeSet: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        case .whenUnlockedThisDeviceOnly: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        }
    }
}
