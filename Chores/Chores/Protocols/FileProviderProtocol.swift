import Foundation

protocol FileProviderProtocol {
    func shared() -> FileProviderProtocol
    func urls(for: FileManager.SearchPathDirectory, in: FileManager.SearchPathDomainMask) -> [URL]
    func fileExists(atPath: String) -> Bool
}

extension FileManager: FileProviderProtocol {
    func shared() -> FileProviderProtocol {
        return FileManager.default
    }
}
