//
//  AuthenticationViewModel.swift
//  InstagramFirestore
//
//  Created by Vitor Trimer on 20/01/21.
//

import Foundation

struct LoginViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}

struct RegistrationViewModel {
    
}
