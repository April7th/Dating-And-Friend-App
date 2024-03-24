//
//  FirebaseListener.swift
//  LetsMeet
//
//  Created by Lê Duy Tân on 02/11/2023.
//

import Foundation
import Firebase

class FirebaseListener {
    static let shared = FirebaseListener()
    
    private init() {}
    
    //MARK: - FUser
    func downloadCurrentUserFromFirebase(userId: String, email: String) {
        
        FirebaseReference(.User).document(userId).getDocument { snapshot, error in
            
            guard let snapshot = snapshot else {return}
            
            if snapshot.exists {
                
                let user = FUser(_dictionary: snapshot.data() as! NSDictionary)
                user.saveUserLocally()
                
                user.getUserAvatarFromFirestore { (didSet) in
                    
                }
            } else {
                //first login
                if let user = userDefaults.object(forKey: kCURRENTUSER) {
                    FUser(_dictionary: user as! NSDictionary).saveUserToFireStore()
                }
                
            }
        }
    }
}
