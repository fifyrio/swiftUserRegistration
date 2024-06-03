//
//  RegistrationViewModel.swift
//  DemoNew
//
//  Created by 吴伟 on 6/3/24.
//

import UIKit
import SnapKit
import PhotosUI
import Combine

// ViewModel for the registration form
class RegistrationViewModel {
    // Properties to hold form data
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var avatarImage: UIImage?
    @Published var avatarBorderColor: UIColor = .clear
    
    // Mock API method
    func submitForm() {
        // Simulate form submission
        print("Form submitted with: \(firstName), \(lastName), \(email), \(avatarImage?.description ?? "No Image"), \(avatarBorderColor)")
    }
}
