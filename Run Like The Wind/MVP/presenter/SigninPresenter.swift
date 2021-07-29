
import Foundation
import UIKit

protocol SignInPresenterDelegate: AnyObject {
    func returnedResult(result : String)
}


import FirebaseFirestore
import FirebaseFirestoreSwift

typealias SignInDelegate = SignInPresenterDelegate & UIViewController

class SigninPresenter{
    
    weak var delegate: SignInDelegate?
    private let database = Firestore.firestore()
    
    public func saveUserInDB(userAccount : UserAccount){
        
        do {
            try database.collection(Constants.FIRESTORE_COLLECTION_USERS).document(userAccount.idToken).setData(from: userAccount)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
            delegate?.returnedResult(result: Constants.FAIL)
        }
        delegate?.returnedResult(result: Constants.SUCCESS)
    }
    
    public func setViewDelegate(delegate : SignInDelegate){
        self.delegate = delegate
    }
}
