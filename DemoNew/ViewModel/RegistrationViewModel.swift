//
//  RegistrationViewModel.swift
//  DemoNew
//
//  Created by 吴伟 on 6/3/24.
//

import UIKit
import Combine

// ViewModel for the registration form
class RegistrationViewModel: ObservableObject {
    let api: MockApiClient = MockApiClient()
    
    // Properties to hold form data
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var avatarImage: UIImage?
    @Published var colorSelection: String = ""
    @Published var avatarBorderColor: UIColor = .gray
    @Published var isButtonEnabled: Bool = false
    
    // Mock API method
    func submitForm(completion: @escaping (Bool) -> Void) {
        // Simulate form submission
        api.createUser(user: .init(firstName: firstName, lastName: lastName, phone: phoneNumber, email: email)) { error in
            guard error == nil else {
                // Show error toast
                //TODO: add call back
                completion(false)
                return
            }
            
            //TODO: add call back
            completion(true)
            // Show success toast
        }
    }
}
