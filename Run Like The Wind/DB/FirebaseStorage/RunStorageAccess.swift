
import Foundation
import FirebaseStorage
import FirebaseAuth

protocol FirebaseStorageCallBack : AnyObject{
    func getImageUrl(imageUrl : String)
}

class RunStorageAccess{
    let storage = Storage.storage()
    let user = Auth.auth().currentUser
    var delegate : FirebaseStorageCallBack?
    static let instance = RunStorageAccess()
    
    private init(){}
    
    public func setViewDelegate(delegate : FirebaseStorageCallBack){
        self.delegate = delegate
    }
    
    func uploadImage(image : UIImage){
        if let currentUser = user{
            let storageRef = storage.reference().child(currentUser.uid).child("\(UUID.init().uuidString).jpg")

   
            // Upload the file to the path "images/rivers.jpg"
            _ = storageRef.putData(image.pngData()!, metadata: nil) {
                (metadata, error) in
                guard metadata != nil else {
                print("Unable to upload photo")
                return
              }
              // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    self.delegate?.getImageUrl(imageUrl: url?.absoluteString ?? "")
              }
            }
                
        }
    }
}
