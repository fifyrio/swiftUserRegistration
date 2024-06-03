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
    init(api: ApiProtocol) {
        self.api = api
    }
    
    let api: ApiProtocol
    
    // Properties to hold form data
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var avatarImage: UIImage?
    @Published var colorSelection: String = ""
    @Published var avatarBorderColor: UIColor = .gray
    @Published var isButtonEnabled: Bool = false
    
    func formatImageData() -> Data? {
        return avatarImage?.jpegData(compressionQuality: 0.8)
    }
    
    // Mock API method
    func submitForm(completion: @escaping (Bool) -> Void) {
        // Simulate form submission
        api.createUser(user: .init(firstName: firstName, lastName: lastName, phone: phoneNumber, email: email, image: formatImageData())) { error in
            guard error == nil else {
                completion(false)
                return
            }
                        
            completion(true)
        }
    }
}
