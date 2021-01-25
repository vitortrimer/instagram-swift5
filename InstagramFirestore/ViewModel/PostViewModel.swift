//
//  PostViewModel.swift
//  InstagramFirestore
//
//  Created by Vitor Trimer on 24/01/21.
//

import Foundation

struct PostViewModel {
    private let post: Post
    
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
    
    init(post: Post) {
        self.post = post
    }
}
