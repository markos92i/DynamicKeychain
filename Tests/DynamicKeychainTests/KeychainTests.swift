
import Foundation
import Testing
@testable import DynamicKeychain

@Suite
struct KeychainTests {
    @Test func withAccessGroupInt() async throws {
        let store = KeychainStore(accesibility: .whenUnlocked, accessGroup: "ABCDE12345.test.keychain.app")
        @Keychain("test.value.optional.bool", store: store) var value: Bool?
        
        value = true
        #expect(value == true)
        
        value = nil
        #expect(value == nil)
    }
    
    @Test func withAccessGroupString() async throws {
        let store = KeychainStore(accesibility: .whenUnlocked, accessGroup: "ABCDE12345.test.keychain.app")
        @Keychain("test.value.optional.string", store: store) var value: String?
        
        value = "Hello, World!"
        #expect(value == "Hello, World!")
        
        value = nil
        #expect(value == nil)
    }

    @Test func optionalBool() async throws {
        @Keychain("test.value.optional.bool") var value: Bool?
        
        value = true
        #expect(value == true)
        
        value = nil
        #expect(value == nil)
    }

    @Test func optionalInt() async throws {
        @Keychain("test.value.optional.int") var value: Int?
        
        value = 42
        #expect(value == 42)
        
        value = nil
        #expect(value == nil)
    }

    @Test func optionalString() async throws {
        @Keychain("test.value.optional.string") var value: String?

        value = "Hello, World!"
        #expect(value == "Hello, World!")
        
        value = nil
        #expect(value == nil)
    }
    
    @Test func optionalFloat() async throws {
        @Keychain("test.value.optional.float") var value: Float?

        value = 3.14
        #expect(value == 3.14)
        
        value = nil
        #expect(value == nil)
    }

    @Test func optionalDouble() async throws {
        @Keychain("test.value.optional.double") var value: Double?

        value = 3.14
        #expect(value == 3.14)
        
        value = nil
        #expect(value == nil)
    }

    @Test func optionalDate() async throws {
        @Keychain("test.value.optional.date") var value: Date?

        value = .init(timeIntervalSince1970: 1)
        #expect(value == .init(timeIntervalSince1970: 1))
        
        value = nil
        #expect(value == nil)
    }
    
    @Test func optionalData() async throws {
        @Keychain("test.value.optional.data") var value: Data?

        value = Data([1, 2, 3])
        #expect(value == Data([1, 2, 3]))
        
        value = nil
        #expect(value == nil)
    }

    @Test func optionalRawRepresentableInt() async throws {
        enum OptRawInt: Int {
            case case1 = 10000000
            case case2 = 20000000
        }
        
        @Keychain("test.value.optional.raw.int") var value: OptRawInt?
        
        value = .case1
        #expect(value == .case1)
        
        value = nil
        #expect(value == nil)
    }
    
    @Test func optionalRawRepresentableString() async throws {
        enum OptRawString: String {
            case case1 = "case1"
            case case2 = "case2"
        }
        
        @Keychain("test.value.optional.raw.string") var value: OptRawString?
        
        value = .case1
        #expect(value == .case1)
        
        value = nil
        #expect(value == nil)
    }

    
    
    @Test func defaultBool() async throws {
        @Keychain("test.value.default.bool") var value: Bool = true
        value = false
        #expect(value == false)
    }

    @Test func defaultInt() async throws {
        @Keychain("test.value.default.int") var value: Int = 42
        value = 84
        #expect(value == 84)
    }
    
    @Test func defaultString() async throws {
        @Keychain("test.value.default.string") var value: String = "Hello!"
        value = "Hello, World!"
        #expect(value == "Hello, World!")
    }
    
    @Test func defaultFloat() async throws {
        @Keychain("test.value.default.float") var value: Float = 3.14
        value = 6.28
        #expect(value == 6.28)
    }

    @Test func defaultDouble() async throws {
        @Keychain("test.value.default.double") var value: Double = 3.14
        value = 6.28
        #expect(value == 6.28)
    }
    
    @Test func defaultDate() async throws {
        @Keychain("test.value.default.date") var value: Date = .init(timeIntervalSince1970: 1)
        value = .init(timeIntervalSince1970: 100)
        #expect(value == .init(timeIntervalSince1970: 100))
    }

    @Test func defaultData() async throws {
        @Keychain("test.value.default.data") var value: Data = Data([1, 2, 3])
        value = Data([3, 4, 5])
        #expect(value == Data([3, 4, 5]))
    }
    
    @Test func defaultRawRepresentableInt() async throws {
        enum RawInt: Int {
            case case1 = 10000000
            case case2 = 20000000
        }
        
        @Keychain("test.value.default.raw.int") var value: RawInt = .case1
        value = .case2
        #expect(value == .case2)
    }
    
    @Test func defaultRawRepresentableString() async throws {
        enum RawString: String {
            case case1 = "case1"
            case case2 = "case2"
        }
        
        @Keychain("test.value.default.raw.string") var value: RawString = .case1
        value = .case2
        #expect(value == .case2)
    }
}
