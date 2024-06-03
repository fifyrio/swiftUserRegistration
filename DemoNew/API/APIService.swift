//
//  APIService.swift
//  DemoNew
//
//  Created by 吴伟 on 6/3/24.
//

import Foundation

protocol ApiProtocol {
    func createUser(user: UserForm, completion: @escaping (Error?) -> Void)
}

final class ApiClient: ApiProtocol {
    private static let delay = 3
    
    //Mock API
    func createUser(user: UserForm, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(ApiClient.delay)) {
            completion(nil)
        }
    }
}
