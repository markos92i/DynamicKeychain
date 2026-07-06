# DynamicKeychain

![Swift 6.3](https://img.shields.io/badge/Swift-6.3-F05138?logo=swift&logoColor=white)
![iOS 18+](https://img.shields.io/badge/iOS-18%2B-007AFF)
![SPM](https://img.shields.io/badge/SPM-Compatible-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow)

Access the iOS Keychain as easily as `@AppStorage`. A property wrapper that stores and retrieves values from the Keychain with full SwiftUI binding support.

## Features

- **`@Keychain` property wrapper** — Declarative keychain access, just like `@AppStorage`
- **SwiftUI reactive** — Values update views automatically when changed
- **Type-safe** — Supports `Bool`, `Int`, `Float`, `Double`, `String`, `Date`, `Data`, and enums (`RawRepresentable: Int/String`, `Codable`)
- **Optional & non-optional** — Both patterns supported
- **Access groups** — Share values between apps in the same group
- **Configurable accessibility** — Control when keychain items are accessible (e.g. `.whenUnlocked`)
- **Programmatic access** — Use `KeychainStore` directly when you don't need SwiftUI bindings

## Installation

Add DynamicKeychain to your project via Swift Package Manager:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/markos92i/DynamicKeychain.git", from: "1.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies** → paste the repository URL.

## Quick Start

```swift
import DynamicKeychain

struct LoginView: View {
    @Keychain("user.session.token") var token: String = ""
    @Keychain("user.biometric.enabled") var biometricEnabled: Bool = false

    var body: some View {
        Toggle("Use Face ID", isOn: $biometricEnabled)
    }
}
```

## Usage

### Basic (non-optional with default)

```swift
@Keychain("password") var password: String = ""
@Keychain("loginCount") var loginCount: Int = 0
```

### Optional values

```swift
@Keychain("refreshToken") var refreshToken: String?
@Keychain("lastLogin") var lastLogin: Date?
```

### Shared between apps (access group)

```swift
let sharedStore = KeychainStore(
    accessibility: .whenUnlocked,
    accessGroup: "ABCDE12345.com.example.shared"
)

@Keychain("sharedToken", store: sharedStore) var sharedToken: String?
```

### As a centralized defaults container

```swift
struct SecureDefaults {
    static let shared = SecureDefaults()

    @Keychain("user.session.email") var email: String = ""
    @Keychain("user.session.token") var token: String?
    @Keychain("user.pin") var pin: String = ""
}
```

### Programmatic access (without SwiftUI)

```swift
// Save
KeychainStore.shared.save("access_token", value: jwtString)

// Load
let token: String? = KeychainStore.shared.load("access_token")

// Delete
KeychainStore.shared.delete(["access_token", "refresh_token"])
```

## Supported Types

| Type | Optional | Non-optional |
|------|----------|-------------|
| `String` | ✓ | ✓ |
| `Int` | ✓ | ✓ |
| `Float` | ✓ | ✓ |
| `Double` | ✓ | ✓ |
| `Bool` | ✓ | ✓ |
| `Date` | ✓ | ✓ |
| `Data` | ✓ | ✓ |
| `enum` (RawRepresentable) | ✓ | ✓ |
| `Codable` | ✓ | ✓ |

## Requirements

| Requirement | Version |
|------------|---------|
| Swift | 6.3+ |
| iOS | 18.0+ |
| Xcode | 26+ |

## License

DynamicKeychain is available under the MIT license. See the [LICENSE](LICENSE) file for details.
