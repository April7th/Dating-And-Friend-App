//
//  FCollectionRefference.swift
//  LetsMeet
//
//  Created by Lê Duy Tân on 01/11/2023.
//

import Foundation
import FirebaseFirestore

enum FCollectionRefference: String {
    case User
}

func FirebaseReference(_ collectionRefference: FCollectionRefference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionRefference.rawValue)
}
