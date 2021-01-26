//
//  PostViewModel.swift
//  InstagramFirestore
//
//  Created by Vitor Trimer on 24/01/21.
//

import UIKit

struct PostViewModel {
    public var post: Post
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var userProfileImageUrl: URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var username: String {
        return post.ownerUserName
    }
    
    var caption: String {
        return post.caption
    }
    
    var likesLabelText: String {
        return "\(post.likes) Like\(post.likes != 1 ? "s" : "")"
    }
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .label
    }
    
    var likeButtonImage: UIImage? {
        let imageName = post.didLike ? "like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }
    
    init(post: Post) {
        self.post = post
    }
}
