import Foundation

protocol CalendarProtocol {
    func isDateInToday(_: Date) -> Bool
    func startOfDay(for: Date) -> Date
    func date(byAdding: DateComponents, to: Date, wrappingComponents: Bool) -> Date?
    // TODO: Add static DateFormatter
}

extension CalendarProtocol {
    func date(byAdding dateComponents: DateComponents, to date: Date, wrappingComponents: Bool = false) -> Date? {
        return self.date(byAdding: dateComponents, to: date, wrappingComponents: wrappingComponents)
    }
}

extension Calendar: CalendarProtocol { }
