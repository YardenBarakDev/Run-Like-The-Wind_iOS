
import Foundation
import UIKit

protocol StatisticsPresenterDelegate: AnyObject {
    func statisticsFromDB(statistics : StatisticsScores)
}

typealias StatisticsDelegate = StatisticsPresenterDelegate & UIViewController

class StatisticsPresenter{
    
    weak var delegate: StatisticsDelegate?
    let dbAccess = StatisticsDBAccess.instance
    
    init() {
        dbAccess.setViewDelegate(delegate: self)
    }
    
    func convertSecondstoTimeStamp(timeInSeconds : Int) -> String{
        let hours = timeInSeconds / 3600
        let minutes = (timeInSeconds/60)%60
        let seconds = timeInSeconds%60

        if (hours > 10 && minutes > 10 && seconds > 10) {
            return "\(hours):\(minutes):\(seconds)"
        }
        
        if (hours > 10 && minutes > 10 && seconds < 10) {
            return "\(hours):\(minutes):0\(seconds)"
        }
        
        if (hours > 10 && minutes < 10 && seconds > 10) {
            return "\(hours):0\(minutes):\(seconds)"
        }
        
        if (hours > 10 && minutes < 10 && seconds < 10) {
            return "\(hours):0\(minutes):0\(seconds)"
        }
        
        if (hours < 10 && minutes > 10 && seconds > 10) {
            return "0\(hours):\(minutes):\(seconds)"
        }
        
        if (hours < 10 && minutes > 10 && seconds < 10) {
            return "0\(hours):\(minutes):0\(seconds)"
        }
        
        if (hours < 10 && minutes < 10 && seconds > 10) {
            return "0\(hours):0\(minutes):\(seconds)"
        }
        
        return "0\(hours):0\(minutes):0\(seconds)"
    }
    
    public func setViewDelegate(delegate : StatisticsDelegate){
        self.delegate = delegate
    }
    
    func getStatistics(){
        dbAccess.getStatisticsScore()
    }

}

//call back from db
extension StatisticsPresenter : RunDBCallbackForStatistics{
    
    func statisticsScore(statisticsScore: StatisticsScores) {
        delegate?.statisticsFromDB(statistics: statisticsScore)
    }
    
}
