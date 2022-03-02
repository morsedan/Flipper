import Foundation

protocol IDProviderProtocol {
    func uuid() -> UUID
}

class IDProvider: IDProviderProtocol {
    func uuid() -> UUID {
        return UUID()
    }
}
