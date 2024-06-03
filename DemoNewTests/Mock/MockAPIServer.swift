//
//  MockAPIServer.swift
//  DemoNewTests
//
//  Created by 吴伟 on 6/3/24.
//

import Foundation
@testable import DemoNew

enum CustomError: Error {
    case invalidInput
    case networkFailure
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return NSLocalizedString("The input provided is invalid.", comment: "Invalid Input")
        case .networkFailure:
            return NSLocalizedString("Network request failed. Please check your connection.", comment: "Network Failure")
        case .unknown:
            return NSLocalizedString("An unknown error occurred.", comment: "Unknown Error")
        }
    }
}


final class MockSuccessApiClient: ApiProtocol {
    func createUser(user: UserForm, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            completion(nil)
        }
    }
}

final class MockErrorApiClient: ApiProtocol {
    func createUser(user: UserForm, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            completion(CustomError.unknown)
        }
    }
}
