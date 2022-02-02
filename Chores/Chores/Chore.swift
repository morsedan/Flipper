import Foundation

enum ChoreStatus: Codable, Equatable {
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

enum ChoreFrequency: Codable, Equatable {
    case daily
    case weekly
    case monthly
    case quarterly
    case yearly
}

struct ChoreOccurrence: Codable, Equatable {
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
