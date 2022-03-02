@testable import Chores
import Foundation

class FakeFileProvider: FileProviderProtocol {
    func shared() -> FileProviderProtocol {
        return self
    }
    
    var urls: [URL] = []
    func urls(for: FileManager.SearchPathDirectory, in: FileManager.SearchPathDomainMask) -> [URL] {
        return urls
    }
    
    var fileDoesExists: Bool = false
    func fileExists(atPath: String) -> Bool {
        return fileDoesExists
    }
}
