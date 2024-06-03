//
//  APIService.swift
//  DemoNew
//
//  Created by 吴伟 on 6/3/24.
//

import Foundation

protocol Api {
    func createUser(user: UserForm, completion: @escaping (Error?) -> Void)
}

final class ApiClient: Api {
    func createUser(user: UserForm, completion: @escaping (Error?) -> Void) {
        // reach the actual API
    }
}

final class MockApiClient: Api {
    private static let delay = 5
    
    func createUser(user: UserForm, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(MockApiClient.delay)) {
            completion(CustomError.unknown)
        }
    }
}
