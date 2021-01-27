//
//  NotificationsService.swift
//  InstagramFirestore
//
//  Created by Vitor Trimer on 27/01/21.
//

import Firebase

struct NotificationService {
    
    static func uploadNotification(toUid uid: String, fromUser user: User, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
            let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
            
            var data: [String:Any] = ["timestamp": Timestamp(date: Date()),
                                      "uid": currentUid,
                                      "type": type.rawValue,
                                      "id": docRef.documentID,
                                      "userProfileImageUrl": user.profileImageUrl,
                                      "username": user.username]
            
            if let post = post {
                data["postId"] = post.postId
                data["imageUrl"] = post.imageUrl
            }
            
            
            docRef.setData(data)
    }
    
    static func fetchNotifications(completion: @escaping(([Notification]) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").order(by: "timestamp", descending: true).getDocuments { (snapshot, _) in
            guard let documents = snapshot?.documents else { return }
            
            let notifications = documents.map({ Notification(dictionary: $0.data()) })
            completion(notifications)
        }
    }
}
