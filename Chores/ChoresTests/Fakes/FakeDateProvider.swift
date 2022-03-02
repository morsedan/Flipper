@testable import Chores
import Foundation

class FakeDateProvider: DateProviderProtocol {
    var dateToReturn: Date = Date()
    func date() -> Date {
        return dateToReturn
    }
}
