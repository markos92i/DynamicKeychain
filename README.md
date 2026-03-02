# DynamicKeychain

This library allows you to access keychain as easy as if it was @AppStorage, allowing you to store and retrieve values, use them directly in your view as it supports MVVM.

Supported value types: Bool Int, Float, Double, String, Date, Data, enums (Raw: Int, String, Codable)
Supports both optional and non optional variables.

Example of Usage

Swift 
```
import DynamicKeychain

struct YourView: View {
    @Keychain("password") var password: String = ""

    var body: some View {        
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("password in keychain")

                Text(password)
            }
        }
    }
}
```

You can create a wrapper to access programatically to those variables if you want
Swift
```
struct Defaults {
    static let shared = Defaults()
    @AppStorage("app.device.theme") var appTheme: Theme = .system
    @Keychain("user.session.email") var email: String = ""
}
```

Or directly access via KeychainStore
Swift
```
KeychainStore.shared.save("access_token", ...)
let token = KeychainStore.shared.load(["access_token"])
KeychainStore.shared.delete(["access_token"])
```
