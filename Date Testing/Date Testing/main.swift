import Foundation

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-DD"
    return formatter
}

var date1 = Date(timeIntervalSinceReferenceDate: 500)
let date2 = Date(timeIntervalSinceReferenceDate: 1100500)

let calendar = Calendar.current

print(date1)
date1 += 5
print(date1)

var components = DateComponents()
components.hour = 0
calendar.
