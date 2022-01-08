import Foundation

enum ChoreStatus {
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
}

enum ChoreFrequency {
    case daily
    case weekly
    case monthly
    case quarterly
    case yearly
}

struct ChoreOccurence {
    let date: Date
    let doer: ChoreDoer
    let status: ChoreStatus
}

struct Chore: Equatable {
    let title: String
    let id: UUID
    var status: ChoreStatus
//    var claimedBy: ChoreDoer?
    let frequency: ChoreFrequency
    let startDate: Date
    var history: [ChoreOccurence] = []
    
    
    static func == (lhs: Chore, rhs: Chore) -> Bool {
        return lhs.id == rhs.id
    }
}
