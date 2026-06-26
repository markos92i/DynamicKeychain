//
//  KeychainError.swift
//  DynamicKeychain
//
//  Created by Marcos del Castillo Camacho on 23/03/2026.
//

import Foundation

public enum KeychainError: Error, Sendable {
    case saveError
    case readError
    case conversionError
    case unexpectedData
}
