import EventKit
import Foundation

let store = EKEventStore()
let semaphore = DispatchSemaphore(value: 0)
var granted = false

if #available(macOS 14.0, *) {
    store.requestFullAccessToEvents { g, _ in granted = g; semaphore.signal() }
} else {
    store.requestAccess(to: .event) { g, _ in granted = g; semaphore.signal() }
}
semaphore.wait()

guard granted else { exit(0) }

let now = Date()
let endOfDay = Calendar.current.startOfDay(for: now).addingTimeInterval(86400)
let predicate = store.predicateForEvents(withStart: now, end: endOfDay, calendars: nil)
let events = store.events(matching: predicate).sorted { $0.startDate < $1.startDate }

if let next = events.first {
    let fmt = DateFormatter()
    fmt.dateFormat = "HH:mm"
    print("\(next.title ?? "") @ \(fmt.string(from: next.startDate))")
}
