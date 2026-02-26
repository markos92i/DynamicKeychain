//
//  KeychainAccesibility.swift
//  Randstad Empleo
//
//  Created by Marcos del Castillo Camacho on 23/1/25.
//  Copyright © 2025 SNGULAR. All rights reserved.
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
