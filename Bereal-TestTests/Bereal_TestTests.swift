//
//  Bereal_TestTests.swift
//  Bereal-TestTests
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import XCTest
@testable import Bereal_Test

final class Bereal_TestTests: XCTestCase {

    override func setUpWithError() throws {
        UserDefaults.standard.set("noel", forKey: "username")
        UserDefaults.standard.set("foobar", forKey: "password")
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.set("", forKey: "username")
        UserDefaults.standard.set("", forKey: "password")
    }

    func testGetMe() async throws {
        let user = try? await BerealManager.shared.getMe()
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.firstName, "Noel")
        XCTAssertEqual(user?.lastName, "Flantier")
    }

    func testGetContent() async throws {
        let items = try? await BerealManager.shared.getContent(of: "4b8e41fd4a6a89712f15bbf102421b9338cfab11")
        XCTAssertNotNil(items)
    }
}
