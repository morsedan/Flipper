import Foundation

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "M/d/yy"
    return formatter
}

var date1 = Date(timeIntervalSinceReferenceDate: 500)
let date2 = Date(timeIntervalSinceReferenceDate: 1100500)

let calendar = Calendar.current

print(date1)
date1 += 5
print(date1)

var components = DateComponents()
components.day = 40
let newDate = Calendar.current.date(byAdding: components, to: date1)!
let newComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
let otherDate = Calendar.current.date(from: newComponents)!

print(dateFormatter.string(from: date1))
print(dateFormatter.string(from: newDate))
print(dateFormatter.string(from: otherDate))
