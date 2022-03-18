import XCTest
@testable import Chores

class ChoreControllerTests: XCTestCase {
    var choreController: ChoreController!
    
    var fileProvider: FakeFileProvider!
    var calendar: FakeCalendar!
    var dateProvider: FakeDateProvider!
    var idProvider: FakeIDProvider!

    override func setUpWithError() throws {
        
        fileProvider = FakeFileProvider()
        calendar = FakeCalendar()
        dateProvider = FakeDateProvider()
        idProvider = FakeIDProvider()
        
        choreController = ChoreController(
            fileProvider: fileProvider,
            calendar: calendar,
            dateProvider: dateProvider,
            idProvider: idProvider
        )
    }

    override func tearDownWithError() throws {
        choreController = nil
        
        fileProvider = nil
        calendar = nil
        dateProvider = nil
        idProvider = nil
    }

    func testAddChore() throws {
        // Given
        XCTAssertEqual(choreController.allChores.count, 0)
        let id1 = FakeIDProvider.FakeID.one
        let expectedChore1 = TestChore(title: "Cook", choreID: id1, status: .unclaimed, frequency: .daily, startDate: Date(timeIntervalSinceReferenceDate: 500))
        let id2 = FakeIDProvider.FakeID.two
        let expectedChore2 = TestChore(title: "Run away", choreID: id2, status: .unclaimed, frequency: .daily, startDate: Date(timeIntervalSinceReferenceDate: 9000))

        // When
        idProvider.uuidToReturn = id2
        choreController.addChore("Run away", frequency: .daily, startDate: Date(timeIntervalSinceReferenceDate: 9000))
        idProvider.uuidToReturn = id1
        choreController.addChore("Cook", frequency: .daily, startDate: Date(timeIntervalSinceReferenceDate: 500))
        
        // Then
        XCTAssertTrue(testChores(choreController.allChores, equalTo: [expectedChore1, expectedChore2]))
        XCTAssertTrue(testChores(choreController.todaysChores, equalTo: []))
    }
    
    func testDeleteChore() {
    }
    
    func testClaimChore() {
        
    }
    
    func testCompleteChore() {
        
    }
    
    func testChooseDateForChore() {
        
    }
    
    func testTodaysChores() {
        let oneDay: TimeInterval = 60 * 60 * 24
        calendar.fakeDateForToday = Date(timeIntervalSinceReferenceDate: (oneDay + 1))
        let choreForYesterday = Chore(title: "yesterday", choreID: FakeIDProvider.FakeID.one, status: .unclaimed, frequency: .daily, startDate: Date(timeIntervalSinceReferenceDate: 1))
        let choreForToday = Chore(title: "today", choreID: FakeIDProvider.FakeID.two, status: .unclaimed, frequency: .daily, startDate: Date(timeIntervalSinceReferenceDate: (oneDay + 5)))
        let choreForTomorrow = Chore(title: "tomorrow", choreID: FakeIDProvider.FakeID.three, status: .unclaimed, frequency: .daily, startDate: Date(timeIntervalSinceReferenceDate: (oneDay + oneDay + 10)))
        
        choreController.allChores = [choreForYesterday, choreForToday, choreForTomorrow]
        
        XCTAssertEqual(choreController.todaysChores, [choreForToday])
    }
    
    
    
    func testAddDoer() {
        XCTAssertEqual(choreController.doers.count, 0)
        let expectedDoer1 = TestChoreDoer(name: "Munchkin")
        let expectedDoer2 = TestChoreDoer(name: "Worker")
        
        choreController.addDoer("Worker")
        choreController.addDoer("Munchkin")
        
        XCTAssertTrue(testDoers(choreController.doers, equalTo: [expectedDoer1, expectedDoer2]))
    }
    
    func testDeleteDoer() {
        choreController.addDoer("Worker")
        choreController.addDoer("Munchkin")
        let doer1 = choreController.doers[0]
        let doer2 = choreController.doers[1]
        
        choreController.deleteDoer(doer1)
        
        XCTAssertEqual(choreController.doers, [doer2])
    }
}

extension ChoreControllerTests {
    
    struct TestChore {
        let title: String
        let choreID: UUID
        var status: ChoreStatus
        let frequency: ChoreFrequency
        var startDate: Date
        var history: [ChoreOccurrence] = []
    }
    
    struct TestChoreDoer {
        let name: String
    }
    
    func testChores(_ actualChores: [Chore], equalTo expectedChores: [TestChore]) -> Bool {
        guard actualChores.count == expectedChores.count else {
            XCTFail("The number of actualChores (\(actualChores.count)) is not the same as the number of expectedChores\(expectedChores.count)")
            return false
        }
        
        var stillTrue = true
        for index in 0..<actualChores.count {
            let actualChore = actualChores[index]
            let expectedChore = expectedChores[index]
            
            if actualChore.title != expectedChore.title {
                XCTFail("Titles do not match: got \"\(actualChore.title)\", expected \"\(expectedChore.title)\"")
                stillTrue = false
            }
            if actualChore.choreID != expectedChore.choreID {
                XCTFail("ID's do not match: got \"\(actualChore.choreID)\", expected \"\(expectedChore.choreID)\"")
                stillTrue = false
            }
            if actualChore.status != expectedChore.status {
                XCTFail("Status' do not match: got \"\(actualChore.status)\", expected \"\(expectedChore.status)\"")
                stillTrue = false
            }
            if actualChore.frequency != expectedChore.frequency {
                XCTFail("Frequencies do not match: got \"\(actualChore.frequency)\", expected \"\(expectedChore.frequency)\"")
                stillTrue = false
            }
            if actualChore.startDate != expectedChore.startDate {
                XCTFail("Start dates do not match: got \"\(actualChore.startDate)\", expected \"\(expectedChore.startDate)\"")
                stillTrue = false
            }
            if actualChore.history != expectedChore.history {
                XCTFail("Histories do not match: got \"\(actualChore.history)\", expected \"\(expectedChore.history)\"")
                stillTrue = false
            }
        }
        return stillTrue
    }
    
    func testDoers(_ actualDoers: [ChoreDoer], equalTo expectedDoers: [TestChoreDoer]) -> Bool {
        guard actualDoers.count == expectedDoers.count else {
            XCTFail("The number of actualDoers (\(actualDoers.count)) is not the same as the number of expectedDoers (\(expectedDoers.count))")
            return false
        }
        for index in 0..<actualDoers.count {
            XCTAssertEqual(actualDoers[index].name, expectedDoers[index].name)
        }
        return true
    }
}
