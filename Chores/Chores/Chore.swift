import Foundation

enum ChoreStatus: Codable {
    case unclaimed
    case claimed(doer: ChoreDoer)
    case done(doer: ChoreDoer)
    
    var string: String {
        switch self {
        case .claimed(doer: let doer): return "Claimed (\(doer.name))"
        case .unclaimed: return "Unclaimed"
        case .done(doer: let doer): return "Done (\(doer.name))"
        }
    }
    
    var doer: ChoreDoer? {
        switch self {
        case .unclaimed: return nil
        case .claimed(let doer): return doer
        case .done(let doer): return doer
        }
    }
}

enum ChoreFrequency: Codable {
    case daily
    case weekly
    case monthly
    case quarterly
    case yearly
    
    var interval: Int {
        switch self {
        case .daily: return 86_400
        case .weekly: return 86_400 * 7
        case .monthly: return 0
        case .quarterly: return 0
        case .yearly: return 0
        }
    }
}

struct ChoreOccurrence: Codable {
    let date: Date
    let doer: ChoreDoer
    let status: ChoreStatus
}

struct Chore: Equatable, Codable {
    let title: String
    let choreID: UUID
    var status: ChoreStatus
    let frequency: ChoreFrequency
    var startDate: Date
    var history: [ChoreOccurrence] = []
    
    
    static func == (lhs: Chore, rhs: Chore) -> Bool {
        return lhs.choreID == rhs.choreID
    }
}
