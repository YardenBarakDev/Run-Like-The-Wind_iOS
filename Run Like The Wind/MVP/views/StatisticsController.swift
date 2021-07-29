

import UIKit

class StatisticsController: UIViewController {

    
    @IBOutlet weak var Statistics_LBL_totalTime: UILabel!
    @IBOutlet weak var Statistics_LBL_totalDistance: UILabel!
    @IBOutlet weak var Statistics_LBL_avgSpeed: UILabel!
    
    var statisticsPresenter : StatisticsPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        StatisticsDBAccess.instance.getStatisticsScore()

        //set presenter
        statisticsPresenter = StatisticsPresenter()
        statisticsPresenter?.setViewDelegate(delegate: self)
        statisticsPresenter?.getStatistics()
    }
    
}

//call back from presentor
extension StatisticsController : StatisticsPresenterDelegate{
    
    func statisticsFromDB(statistics: StatisticsScores) {
        Statistics_LBL_totalTime.text = statisticsPresenter?.convertSecondstoTimeStamp(timeInSeconds: statistics.totalRunTime)
        Statistics_LBL_totalDistance.text = String(format: "%.2f", statistics.totalDistance) + " KMPH"
        Statistics_LBL_avgSpeed.text = String(format: "%.2f", statistics.totalAvgSpeed)
    }
    
}
