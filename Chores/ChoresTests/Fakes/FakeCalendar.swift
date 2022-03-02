@testable import Chores
import Foundation

class FakeCalendar: CalendarProtocol {
    var dateInToday = false
    func isDateInToday(_: Date) -> Bool {
        return dateInToday
    }
    
    var startOfDayToReturn: Date = Date()
    func startOfDay(for: Date) -> Date {
        return startOfDayToReturn
    }
    
    var dateByAddingComponents: Date? = nil
    func date(byAdding dateComponents: DateComponents, to date: Date, wrappingComponents: Bool = false) -> Date? {
        return dateByAddingComponents
    }
}
