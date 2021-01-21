//
//  ProfileHeaderViewModel.swift
//  InstagramFirestore
//
//  Created by Vitor Trimer on 21/01/21.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullName: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    init(user: User) {
        self.user = user
    }
}
