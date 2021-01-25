//
//  ProfileHeaderViewModel.swift
//  InstagramFirestore
//
//  Created by Vitor Trimer on 21/01/21.
//

import Foundation
import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var fullName: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var followedButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .systemBackground : .systemBlue
    }
    
    var followedButtonTextColor: UIColor {
        return user.isCurrentUser ? .label : .white
    }
    
    var followersNumber: NSAttributedString {
        return attributedStatText(value: user.stats.followers, label: "followers")
    }
    
    var followingNumber: NSAttributedString {
        return attributedStatText(value: user.stats.following, label: "following")
    }
    
    var postsNumber: NSAttributedString {
        return attributedStatText(value: user.stats.posts, label: "posts")
    }
    
    init(user: User) {
        self.user = user
    }
    
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "\(label)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
}
