
import Foundation
import UIKit

protocol RunHistoryPresenterDelegate: AnyObject {
    func returnedRuns(result : [SingleRun]?)
}

import FirebaseFirestore
import FirebaseFirestoreSwift

typealias RunHistoryDelegate = RunHistoryPresenterDelegate & UIViewController

class RunHistoryPresenter{
    
    weak var delegate: RunHistoryDelegate?
    private let database = Firestore.firestore()
    
    init() {
        RunDBAccess.instance.setViewDelegate(delegate: self)
    }
    public func setViewDelegate(delegate : RunHistoryDelegate){
        self.delegate = delegate
    }
    
    public func fetchRunsFromDB(){
        RunDBAccess.instance.getAllRuns()
    }
    
    public func sortRunByDate(allRuns: [SingleRun]){
        var array = allRuns
        for i in 0..<array.count {
            for j in 0..<array.count{
                if (geTMicroSec(string: array[i].date) > geTMicroSec(string: array[j].date)) {
                    let temp = array[i]
                    array[i] = array[j]
                    array[j] = temp
                }
            }
        }
        delegate?.returnedRuns(result: array)
    }
    
    public func sortRunsByDistance(allRuns: [SingleRun]){
        var array = allRuns
        for i in 0..<array.count {
            for j in 0..<array.count{
                if (array[i].distance > array[j].distance) {
                    let temp = array[i]
                    array[i] = array[j]
                    array[j] = temp
                }
            }
        }
        delegate?.returnedRuns(result: array)
    }

    func geTMicroSec(string : String) -> Int {
            //Incoming date format with microseconds
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
            let date = formater.date(from: string)
            let interval = ((date ?? Date()).timeIntervalSince1970)*1000
            
            return Int(interval)

    }
    
     func sortRunsByAvgSpeed(allRuns: [SingleRun]){
        var array = allRuns
        for i in 0..<array.count {
            for j in 0..<array.count{
                if (allRuns[i].avgSpeed > array[j].avgSpeed) {
                    let temp = array[i]
                    array[i] = array[j]
                    array[j] = temp
                }
            }
        }
        delegate?.returnedRuns(result: array)
    }
}

extension RunHistoryPresenter : RunDBAccessDelegate{
    
    func allRuns(allRuns: [SingleRun]) {
        delegate?.returnedRuns(result: allRuns)
    }
    
}
