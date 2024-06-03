//
//  ApiClientTests.swift
//  DemoNewTests
//
//  Created by 吴伟 on 6/3/24.
//

import XCTest
@testable import DemoNew


final class ApiClientTests: XCTestCase {

    func testCreateUser() {
        let api = ApiClient()
        let exp = XCTestExpectation(description: "test Create User")
        api.createUser(user: .init(firstName: "firstName", lastName: "lastName", phone: "phone", email: "email", image: nil), completion: { error in
            XCTAssertNil(error)
            exp.fulfill()
        })
        wait(for: [exp], timeout: 5)
    }

}
