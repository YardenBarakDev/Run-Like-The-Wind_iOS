
import Foundation
import UIKit
import GoogleMaps

protocol RunPresenterDelegate: AnyObject {
    func timerUpdate(time : String)
}

typealias RunDelegate = RunPresenterDelegate & UIViewController

class RunPresenter{
    
    weak var delegate: RunDelegate?
    var timer : Timer?
    var currentRunTime = 0
    var timerTime : String?
    var singleRun : SingleRun?
    
    init() {
        RunStorageAccess.instance.setViewDelegate(delegate: self)
    }
    
    public func setViewDelegate(delegate : RunDelegate){
        self.delegate = delegate
    }
    
    public func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        currentRunTime += 1
        let hours : Int = currentRunTime/3600
        let minutes : Int = (currentRunTime/60)%60
        let seconds : Int = currentRunTime%60
        
        var time = hours < 10 ? "0\(hours)" : "\(hours)"
        time += minutes < 10 ? ":0\(minutes)" : ":\(minutes)"
        time += seconds < 10 ? ":0\(seconds)" : ":\(seconds)"
        print(time)
        delegate?.timerUpdate(time: time)
        timerTime = time
    }
    
    func stopTimer(){
        timer?.invalidate()
       
    }
    
    func getDistanceInKM(coordinatesArray: [CLLocation]) -> Double {
        var distance : CLLocationDistance = 0

        for i in 0..<coordinatesArray.count-1{
            let fromLat = coordinatesArray[i].coordinate.latitude
            let fromLon = coordinatesArray[i].coordinate.longitude
            
            let toLat = coordinatesArray[i + 1].coordinate.latitude
            let toLon = coordinatesArray[i + 1].coordinate.longitude
            
            let from = CLLocation(latitude: fromLat, longitude: fromLon)
            let to = CLLocation(latitude: toLat, longitude: toLon)
            
            distance = distance + from.distance(from: to)
        }
        
        return distance/1000
      }
    
    func getAvgSpeedInKM(distance : Double) -> Double{
        let avgSpeed = (distance*1000)/Double((currentRunTime*3600))
        return avgSpeed*1000
    }
    
    
    func saveRunInDB(singleRun : SingleRun){
        self.singleRun = singleRun
        
    }
    
    func uploadImageToDB(image : UIImage){
        RunStorageAccess.instance.uploadImage(image: image)
    }
    
    func zoomOutToShowWholeTrack(path : GMSPath) -> GMSCoordinateBounds{
        var bounds = GMSCoordinateBounds()
        
        for i in 0..<path.count(){
            bounds = bounds.includingCoordinate(path.coordinate(at: i))
        }
        return bounds
    }
    
    private func addItemToDatabase(imageUrl: String){
        let dbAccess = RunDBAccess.instance
        if let run = singleRun{
            run.trackImageURL = imageUrl
            dbAccess.addItem(singleRun: run)
            StatisticsDBAccess.instance.updateStatisticsInDB(singleRun: run, runTime: currentRunTime)

        }
    }
}

extension RunPresenter: FirebaseStorageCallBack{
    
    func getImageUrl(imageUrl: String) {
        addItemToDatabase(imageUrl: imageUrl)
    }
}
