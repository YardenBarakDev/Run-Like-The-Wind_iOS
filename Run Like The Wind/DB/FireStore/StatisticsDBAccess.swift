
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol RunDBCallbackForStatistics : AnyObject{
    func statisticsScore(statisticsScore : StatisticsScores)
}

typealias DBStatisticsDelegate = RunDBCallbackForStatistics

//singleton
class StatisticsDBAccess{
    
    weak var delegate : DBStatisticsDelegate?
    var statisticsScore : StatisticsScores?
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    static let instance = StatisticsDBAccess()
    
    private init(){}
    
    public func setViewDelegate(delegate : DBStatisticsDelegate){
        self.delegate = delegate
    }
    
    func getStatisticsScore(){

        if let currentUser = user {
            
            let docRef = db.collection(Constants.FIRESTORE_COLLECTION_USERS).document(currentUser.uid).collection(Constants.FIRESTORE_COLLECTION_STATISTICS).document(currentUser.uid)

            docRef.getDocument { (statistics, error) in
                let result = Result {
                    try statistics?.data(as: StatisticsScores.self)
                }
                switch result {
                case .success(let statisticsFromDB):
                    if let statisticsFromDB = statisticsFromDB {
                        self.statisticsScore = statisticsFromDB
                        print("Statistics found \(self.statisticsScore?.description ?? "")")
                        self.delegate?.statisticsScore(statisticsScore: self.statisticsScore!)
                    } else {
                        print("Document does not exist")
                        self.addStatisticsToDB()
                    }
                case .failure(let error):
                    print("Error decoding city: \(error)")
                }
            }
        }
        
    }
    
    func addStatisticsToDB(){
    
            let statistics = StatisticsScores(totalRunTime: 0, totalDistance: 0, totalAvgSpeed: 0)
        
            if let currentUser = user{
                do {
                    //Users/UID/Statistics/UID/current statistics data
                    try db.collection(Constants.FIRESTORE_COLLECTION_USERS).document(currentUser.uid).collection(Constants.FIRESTORE_COLLECTION_STATISTICS).document(currentUser.uid).setData(from: statistics)
                } catch {
                  print("Unable to add item to database")
                    return
                }
                print("Item added to the database")
            }
        
    }
    
    
    func updateStatisticsInDB(singleRun : SingleRun, runTime : Int){
        if let currentStatistics = statisticsScore{
            currentStatistics.totalAvgSpeed += singleRun.avgSpeed
            currentStatistics.totalDistance += singleRun.distance
            currentStatistics.totalRunTime += runTime
            
            if let currentUser = user{
                do {
                    //Users/UID/Statistics/UID/current statistics data
                    try db.collection(Constants.FIRESTORE_COLLECTION_USERS).document(currentUser.uid).collection(Constants.FIRESTORE_COLLECTION_STATISTICS).document(currentUser.uid).setData(from: currentStatistics)
                } catch {
                  print("Unable to add item to database")
                    return
                }
                print("Item added to the database")
                self.delegate?.statisticsScore(statisticsScore: currentStatistics)
            }
            else{
                print("Unable to find user instance")
                return
            }
        }
    }
}
