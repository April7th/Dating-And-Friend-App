//
//  FUser.swift
//  LetsMeet
//
//  Created by Lê Duy Tân on 01/11/2023.
//

import Foundation
import Firebase
import UIKit

class FUser: Equatable {
    
    static func == (lhs: FUser, rhs: FUser) -> Bool {
        lhs.objectID == rhs.objectID
    }
    
    let objectID: String
    var email: String
    var username: String
    var dateOfBirth: Date
    var isMale: Bool
    var avatar: UIImage?
    var profession: String
    var jobTitle: String
    var about: String
    var city: String
    var country: String
    var height: Double
    var lookingFor: String
    var avatarLink: String
    
    var likedIdArray: [String]?
    var imageLinks: [String]?
    let registeredDate = Date()
    var pushID: String?
    
    var userDictionary: NSDictionary {
        return NSDictionary(objects: [
                                        self.objectID,
                                        self.email,
                                        self.username,
                                        self.dateOfBirth,
                                        self.isMale,
                                        self.profession,
                                        self.jobTitle,
                                        self.about,
                                        self.city,
                                        self.country,
                                        self.height,
                                        self.lookingFor,
                                        self.avatarLink,
                                        self.likedIdArray ?? [],
                                        self.imageLinks ?? [],
                                        self.registeredDate,
                                        self.pushID ?? ""
        ],
        forKeys: [
                                        kOBJECTID as NSCopying,
                                        kEMAIL as NSCopying,
                                        kUSERNAME as NSCopying,
                                        kDATEOFBIRTH as NSCopying,
                                        kISMALE as NSCopying,
                                        kPROFFESION as NSCopying,
                                        kJOBTITLE as NSCopying,
                                        kABOUT as NSCopying,
                                        kCITY as NSCopying,
                                        kCOUNTRY as NSCopying,
                                        kHEIGHT as NSCopying,
                                        kLOOKINGFOR as NSCopying,
                                        kAVATARLINK as NSCopying,
                                        kLIKEDIDARRAY as NSCopying,
                                        kIMAGELINKS as NSCopying,
                                        kREGISTEREDDATE as NSCopying,
                                        kPUSHID as NSCopying,
        ])
    }
    
    //MARK: - Inits
    init(_objectID: String, _email: String,_username: String, _city: String, _dateOfBirth: Date, _isMale: Bool, _avatarLink: String = "") {
        objectID = _objectID
        email = _email
        username = _username
        dateOfBirth = _dateOfBirth
        isMale = _isMale
        profession = ""
        jobTitle = ""
        about = ""
        city = _city
        country = ""
        height = 0.0
        lookingFor = ""
        avatarLink = _avatarLink
        likedIdArray = []
        imageLinks = []
    }
    
    //MARK: - Login
    class func loginUserWith(email: String, password: String, completion: @escaping(_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if error == nil {
                
                if authDataResult!.user.isEmailVerified {
                    
                    //check if user existed in firebase
                    completion(error, true)
                } else {
                    print("Email not verified")
                    completion(error, false)
                }
            } else {
                completion(error, false)
            }
        }
    }
    
    
    //MARK: - Register
    class func registerUserWith(email: String, password: String, userName: String, city: String, isMale: Bool, dateOfBirth: Date, completion: @escaping(_ error: Error?) -> Void) {
         
        print("register", Date())
        
        Auth.auth().createUser(withEmail: email, password: password) { authData , error in
            
            completion(error)
            
            if error == nil {
                
                authData!.user.sendEmailVerification { error in
                    print("email vertification sent", error?.localizedDescription)
                }
                
                if authData?.user != nil {
                    
                    let user = FUser(_objectID: authData!.user.uid, _email: email, _username: userName, _city: city, _dateOfBirth: dateOfBirth, _isMale: isMale)
                    
                    user.saveUserLocally()
                }
            }
        }
    }
    
    func saveUserLocally() {
        
        userDefaults.set(self.userDictionary as! [String : Any], forKey: kCURRENTUSER)
        userDefaults.synchronize()
    }
}
