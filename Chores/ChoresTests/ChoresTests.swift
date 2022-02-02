import XCTest
@testable import Chores

class ChoreControllerTests: XCTestCase {
    var choreController: ChoreController!

    override func setUpWithError() throws {
        choreController = ChoreController(fileProvider: FakeFileProvider())
    }

    override func tearDownWithError() throws {
        choreController = nil
    }

    func testAddChore() throws {
        // Given
        XCTAssertEqual(choreController.allChores.count, 0)
        let expectedChore1 = TestChore(title: "Cook", status: .unclaimed, frequency: .daily, startDate: Date(timeIntervalSinceReferenceDate: 500))
        let expectedChore2 = TestChore(title: "Run away", status: .unclaimed, frequency: .daily, startDate: Date(timeIntervalSinceReferenceDate: 9000))
        
        // When
        choreController.addChore("Run away", frequency: .daily, startDate: Date(timeIntervalSinceReferenceDate: 9000))
        choreController.addChore("Cook", frequency: .daily, startDate: Date(timeIntervalSinceReferenceDate: 500))
        
        // Then
        XCTAssertTrue(testChores(choreController.allChores, equalTo: [expectedChore1, expectedChore2]))
        XCTAssertTrue(testChores(choreController.todaysChores, equalTo: []))
    }
    
    func testAddDoer() {
        XCTAssertEqual(choreController.doers.count, 0)
        let expectedDoer1 = TestChoreDoer(name: "Munchkin")
        let expectedDoer2 = TestChoreDoer(name: "Worker")
        
        choreController.addDoer("Worker")
        choreController.addDoer("Munchkin")
        
        XCTAssertTrue(testDoers(choreController.doers, equalTo: [expectedDoer1, expectedDoer2]))
    }
}

extension ChoreControllerTests {
    
    struct TestChore {
        let title: String
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
            
            if actualChore.status != expectedChore.status {
                XCTFail(" do not match: got \"\(actualChore.status)\", expected \"\(expectedChore.status)\"")
                stillTrue = false
            }
            if actualChore.frequency != expectedChore.frequency {
                XCTFail(" do not match: got \"\(actualChore.frequency)\", expected \"\(expectedChore.frequency)\"")
                stillTrue = false
            }
            if actualChore.startDate != expectedChore.startDate {
                XCTFail(" do not match: got \"\(actualChore.startDate)\", expected \"\(expectedChore.startDate)\"")
                stillTrue = false
            }
            if actualChore.history != expectedChore.history {
                XCTFail(" do not match: got \"\(actualChore.history)\", expected \"\(expectedChore.history)\"")
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
