//
//  RegistrationViewModelTests.swift
//  DemoNewTests
//
//  Created by 吴伟 on 6/3/24.
//

import XCTest
@testable import DemoNew

final class RegistrationViewModelTests: XCTestCase {
    
    func testSubmitFormSuccess() {
        let exp = XCTestExpectation(description: "test Create User Success")
        let viewModel: RegistrationViewModel! = RegistrationViewModel(api: MockSuccessApiClient())
        viewModel.submitForm { state in
            XCTAssertTrue(state)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
    
    func testSubmitFormFail() {
        let exp = XCTestExpectation(description: "test Create User Error")
        let viewModel: RegistrationViewModel! = RegistrationViewModel(api: MockErrorApiClient())
        viewModel.submitForm { state in
            XCTAssertFalse(state)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }

}
