//
//  CustomError.swift
//  DemoNew
//
//  Created by 吴伟 on 6/3/24.
//

import Foundation

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
