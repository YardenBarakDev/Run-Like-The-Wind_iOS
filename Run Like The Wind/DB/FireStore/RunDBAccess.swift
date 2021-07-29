
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol RunDBAccessDelegate {
    func allRuns(allRuns : [SingleRun])
}

//singleton class
class RunDBAccess{
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var delegate : RunDBAccessDelegate?
    
    static let instance = RunDBAccess()
    
    private init(){}
    
    public func setViewDelegate(delegate : RunDBAccessDelegate){
        self.delegate = delegate
    }
    
    // add new run to the DB
    func addItem(singleRun : SingleRun) {
        
        if let currentUser = user{
            do {
                //Users/UID/Runs/auto genreated id/current run data
              try db.collection(Constants.FIRESTORE_COLLECTION_USERS).document(currentUser.uid).collection(Constants.FIRESTORE_COLLECTION_RUNS).document().setData(from: singleRun)
            } catch {
              print("Unable to add item to database")
                return
            }
            
            print("Item added to the database")
        }
        else{
            print("Unable to find user instance")
            return
        }
    }
    
    func getAllRuns(){
        if let currentUser = user{
            let pathRef = db.collection(Constants.FIRESTORE_COLLECTION_USERS).document(currentUser.uid).collection(Constants.FIRESTORE_COLLECTION_RUNS)
            
            pathRef.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else if let snapshot = querySnapshot{
                    let allRubs: [SingleRun] = snapshot.documents.compactMap {
                          return try? $0.data(as: SingleRun.self)
                    }
                    self.delegate?.allRuns(allRuns: allRubs)
                }
            }
        }
    }
}
