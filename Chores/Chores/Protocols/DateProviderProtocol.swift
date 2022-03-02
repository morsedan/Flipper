import Foundation

protocol DateProviderProtocol {
    func date() -> Date
}

class DateProvider: DateProviderProtocol {
    func date() -> Date {
        return Date()
    }
}
