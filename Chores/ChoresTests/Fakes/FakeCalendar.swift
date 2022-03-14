@testable import Chores
import Foundation

class FakeCalendar: CalendarProtocol {
    var fakeDateForToday: Date = Date(timeIntervalSinceReferenceDate: 0)
    func isDateInToday(_ date: Date) -> Bool {
        return Calendar.current.isDate(date, inSameDayAs: fakeDateForToday)
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
