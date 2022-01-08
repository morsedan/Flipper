import Foundation

class ChoreController {
    var chores: [Chore] = []
    var doers: [ChoreDoer] = []
    
    // MARK: Chores
    func addChore(_ choreTitle: String, frequency: ChoreFrequency, startDate: Date) {
        let chore = Chore(title: choreTitle, id: UUID(), status: .unclaimed, frequency: frequency, startDate: startDate)
        chores.append(chore)
    }
    
    func deleteChore(_ chore: Chore) {
        guard let choreIndex = chores.firstIndex(of: chore) else { return }
        chores.remove(at: choreIndex)
    }
    
    // TODO: Move doer to it's own controller.
    // MARK: Doers
    func addDoer(_ doerName: String) {
        let doer = ChoreDoer(name: doerName)
        doers.append(doer)
    }
    
    func deleteDoer(_ doer: ChoreDoer) {
        guard let doerIndex = doers.firstIndex(of: doer) else { return }
        doers.remove(at: doerIndex)
    }
}
