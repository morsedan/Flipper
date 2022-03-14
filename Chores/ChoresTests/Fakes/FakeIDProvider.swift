@testable import Chores
import Foundation

class FakeIDProvider: IDProviderProtocol {
    enum FakeID {
        static let one = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        static let two = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
        static let three = UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
    }
    
    /// uuidToReturn: must be a string using the following format: "12345678-1234-1234-123456789012"
    var uuidToReturn: UUID = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    func uuid() -> UUID {
        return uuidToReturn
    }
}
