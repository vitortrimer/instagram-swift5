//
//  Constants.swift
//  InstagramFirestore
//
//  Created by Vitor Trimer on 21/01/21.
//

import Firebase
import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
