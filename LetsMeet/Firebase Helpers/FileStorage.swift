//
//  Storage.swift
//  LetsMeet
//
//  Created by Lê Duy Tân on 06/11/2023.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

class FileStorage {
    
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ documentLink: String?) -> Void) {
        
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(directory)
        
        let imageData = image.jpegData(compressionQuality: 0.6)
        
        var task: StorageUploadTask!
        
        task = storageRef.putData(imageData!, metadata: nil, completion: { (metaData, error) in
            
            task.removeAllObservers()
            
            if error != nil {
                print("error uploading image", error!.localizedDescription)
                return
            }
            
            storageRef.downloadURL { (url, error) in
                
                guard let downloadUrl = url else {
                    completion(nil)
                    return
                }
                print("we have uploaded image to ", downloadUrl.absoluteString)
                completion(downloadUrl.absoluteString)
            }
        })
    }
    
    class func uploadImages(_ images: [UIImage?], completion: @escaping (_ imagelinks: [String]) -> Void) {
        
        var uploadImagesCount = 0
        var imageLinkArray : [String] = []
        var nameSuffix = 0
        
        for image in images {
            let fileDirectory = "UserImages/" + FUser.currentId() + "/" + "\(nameSuffix)" + ".jpg"
            
            uploadImage(image!, directory: fileDirectory) { (imageLink) in
                
                if imageLink != nil {
                    imageLinkArray.append(imageLink!)
                    uploadImagesCount += 1
                    
                    if uploadImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
            }
            nameSuffix += 1
        }
        
                
//        let imageData = image.jpegData(compressionQuality: 0.6)
//        
//        var task: StorageUploadTask!
//        
//        task = storageRef.putData(imageData!, metadata: nil, completion: { (metaData, error) in
//            
//            task.removeAllObservers()
//            
//            if error != nil {
//                print("error uploading image", error!.localizedDescription)
//                return
//            }
//            
//            storageRef.downloadURL { (url, error) in
//                
//                guard let downloadUrl = url else {
//                    completion(nil)
//                    return
//                }
//                print("we have uploaded image to ", downloadUrl.absoluteString)
//                completion(downloadUrl.absoluteString)
//            }
//        })
    }

    
    class func downloadImage(imageUrl: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        let imageFileName = ((imageUrl.components(separatedBy: "_").last!).components(separatedBy: "?").first)!.components(separatedBy: ".").first!
        
        if fileExistsAt(path: imageFileName) {
            
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(filename: imageFileName)) {
                completion(contentsOfFile)
            } else {
                print("could not generate image from local image")
                completion(nil)
            }
        } else {
            
            if imageUrl != "" {
                
                let documentURL = URL(string: imageUrl)
                
                let downloadQueue = DispatchQueue(label: "downloadQueue")
                
                downloadQueue.async {
                    let data = NSData(contentsOf: documentURL!)
                    
                    if data != nil {
                        
                        let imageToReturn = UIImage(data: data! as Data)
                        
                        FileStorage.saveImageLocally(imageData: data!, fileName: imageFileName)
                        
                        completion(imageToReturn)
                    } else {
                        print("no image in database")
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
        
    class func saveImageLocally(imageData: NSData, fileName: String) {
        var docURL = getDocumentsURL()
        docURL = docURL.appendingPathComponent(fileName, isDirectory: false)
        
        imageData.write(to: docURL, atomically: true)
    }
    
}

func getDocumentsURL() -> URL {
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    
    return documentURL!
}

func fileInDocumentsDirectory(filename: String) -> String {
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL.path
}

func fileExistsAt(path: String) -> Bool {
    
    return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(filename: path))
}
