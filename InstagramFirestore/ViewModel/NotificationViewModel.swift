//
//  NotificationViewModel.swift
//  InstagramFirestore
//
//  Created by Vitor Trimer on 27/01/21.
//

import UIKit

struct NotificationViewModel {
    var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageUrl: URL? { return URL(string: notification.postImageUrl ?? "") }
    var profileImageUrl: URL? { return URL(string: notification.userProfileImageUrl) }
    
    var notificationMessage: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        
        attributedText.append(NSAttributedString(string: "  2m", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    var shouldHidePostImage: Bool {
        return self.notification.type == .follow
    }
    
    var shouldHideFollowButton: Bool {
        return self.notification.type != .follow
    }
    
    var followButtonColor: UIColor {
        return self.notification.userIsFollowed ? .systemBackground : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return self.notification.userIsFollowed ? .label : .white
    }
    
    var followButtonText: String {
        return self.notification.userIsFollowed ? "Following" : "Follow"
    }
    
}
