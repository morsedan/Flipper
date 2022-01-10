import Foundation

class ChoreController {
    var allChores: [Chore] = []
    var todaysChores: [Chore] {
        let calendar = Calendar.current
        var chores = allChores.filter { chore in
            calendar.isDateInToday(chore.startDate)
        }
        var completedChores = allChores.filter { chore in
            guard let occurrence = chore.history.last else { return false }
            return calendar.isDateInToday(occurrence.date) && !calendar.isDateInToday(chore.startDate)
        }
        for (index, chore) in completedChores.enumerated() {
            if let occurrence = chore.history.last,
               let doer = occurrence.status.doer {
                completedChores[index].status = .done(doer: doer)
            }
        }
        chores.append(contentsOf: completedChores)
        return chores.sorted { $0.title < $1.title }
    }
    var doers: [ChoreDoer] = []
    
    init() {
        loadFromPersistentStore()
    }
    
    // MARK: Chores
    func addChore(_ choreTitle: String, frequency: ChoreFrequency, startDate: Date) {
        let chore = Chore(title: choreTitle, choreID: UUID(), status: .unclaimed, frequency: frequency, startDate: startDate)
        allChores.append(chore)
        allChores.sort { $0.title < $1.title }
        saveToPersistentStore()
    }
    
    func deleteChore(_ chore: Chore) {
        guard let choreIndex = allChores.firstIndex(of: chore) else { return }
        allChores.remove(at: choreIndex)
        saveToPersistentStore()
    }
    
    func claimChore(_ chore: Chore, forChoreID choreID: UUID) -> Chore {
        guard let index = allChores.firstIndex(of: chore),
              let doer = doers.first(where: { possibleDoer in
                  possibleDoer.choreDoerID == choreID
              }) else { return chore }
        let choreOccurence = ChoreOccurrence(date: Date(), doer: doer, status: .claimed(doer: doer))
        allChores[index].status = .claimed(doer: doer)
        allChores[index].history.append(choreOccurence)
        saveToPersistentStore()
        return allChores[index]
    }
    
    func completeChore(_ chore: Chore) -> Chore {
        guard let index = todaysChores.firstIndex(of: chore),
              let doer = chore.status.doer else { return chore }
        let choreOccurence = ChoreOccurrence(date: Date(), doer: doer, status: .done(doer: doer))
        allChores[index].status = .done(doer: doer)
        allChores[index].history.append(choreOccurence)
        allChores[index].status = .unclaimed
        setNewDateForChore(atIndex: index)
        saveToPersistentStore()
        return allChores[index]
    }
    
    func setNewDateForChore(atIndex index: Int) {
        let chore = allChores[index]
        let startDate = chore.startDate
        var components = DateComponents()
        switch chore.frequency {
        case .daily:
            components.day = 1
        case .weekly:
            components.day = 7
        case .monthly:
            components.month = 1
        case .quarterly:
            components.month = 3
        case .yearly:
            components.year = 1
        }
        guard let newDate = Calendar.current.date(byAdding: components, to: startDate) else { return }
        allChores[index].startDate = newDate
        allChores[index].status = .unclaimed
    }
    
    // TODO: Move doer to it's own controller.
    // MARK: Doers
    func addDoer(_ doerName: String) {
        let doer = ChoreDoer(name: doerName, choreDoerID: UUID())
        doers.append(doer)
        saveToPersistentStore()
    }
    
    func deleteDoer(_ doer: ChoreDoer) {
        guard let doerIndex = doers.firstIndex(of: doer) else { return }
        doers.remove(at: doerIndex)
        saveToPersistentStore()
    }
    
    // MARK: Persistance
    private var choresFileURL: URL? {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return dir.appendingPathComponent("chores.plist")
    }
    
    private var doersFileURL: URL? {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return dir.appendingPathComponent("doers.plist")
    }
    
    private func saveToPersistentStore() {
        guard let choreFileURL = choresFileURL,
              let doersFileURL = doersFileURL else { return }
        
        do{
            let encoder = PropertyListEncoder()
            let choreData = try encoder.encode(allChores)
            let doerData = try encoder.encode(doers)
            try choreData.write(to: choreFileURL)
            try doerData.write(to: doersFileURL)
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    private func loadFromPersistentStore() {
        let fm = FileManager.default
        guard let choresFileURL = choresFileURL,
              fm.fileExists(atPath: choresFileURL.path),
              let doersFileURL = doersFileURL,
              fm.fileExists(atPath: doersFileURL.path) else { return }
        
        do{
            let choreData = try Data(contentsOf: choresFileURL)
            let doerData = try Data(contentsOf: doersFileURL)
            let decoder = PropertyListDecoder()
            allChores = try decoder.decode([Chore].self, from: choreData).sorted { $0.title < $1.title }
            
            for (index, chore) in allChores.enumerated() {
                while allChores[index].startDate < Calendar.current.startOfDay(for: Date()) {
                    print("setting date")
                    setNewDateForChore(atIndex: index)
                }
            }
            doers = try decoder.decode([ChoreDoer].self, from: doerData)
        } catch {
            print("Error loading data: \(error)")
        }
    }
}
