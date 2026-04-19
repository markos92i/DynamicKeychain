//
//  KeychainError.swift
//  Randstad Empleo
//
//  Created by Marcos del Castillo Camacho on 23/1/25.
//  Copyright © 2025 SNGULAR. All rights reserved.
//

import Foundation

public enum KeychainError: Error, Sendable {
    case saveError
    case readError
    case conversionError
    case unexpectedData
}
