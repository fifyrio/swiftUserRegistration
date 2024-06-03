//
//  RegistrationViewControllerTests.swift
//  DemoNewTests
//
//  Created by 吴伟 on 6/3/24.
//

import XCTest
@testable import DemoNew

final class RegistrationViewControllerTests: XCTestCase {

    var controller: RegistrationViewController!
    var viewModel: RegistrationViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Initialize the viewModel
        viewModel = RegistrationViewModel(api: MockSuccessApiClient())
        controller = RegistrationViewController(viewModel: viewModel)
        controller.viewDidLoad()
    }

    override func tearDownWithError() throws {
        // Clean up
        viewModel = nil
        controller = nil
        try super.tearDownWithError()
      }
    
    func testBindIsButtonEnabled() {
        XCTAssertFalse(viewModel.isButtonEnabled)
                
        viewModel.email = "email"
        viewModel.firstName = "firstName"
        viewModel.lastName = "lastName"
        viewModel.phoneNumber = "phoneNumber"
        XCTAssertTrue(viewModel.isButtonEnabled)
    }
    
    func testBindAvatarBorderColor() {
        viewModel.colorSelection = "red"        
        XCTAssertEqual(viewModel.avatarBorderColor, .red)
    }

}
