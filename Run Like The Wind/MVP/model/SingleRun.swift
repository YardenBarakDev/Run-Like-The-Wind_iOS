
import Foundation

class SingleRun : Codable{
    
    var trackImageURL : String
    var date : String
    var runTime: String
    var distance : Double
    var avgSpeed : Double
   
    
    init(trackImageURL : String, date : String, runTime: String, distance : Double, avgSpeed : Double) {
        self.trackImageURL = trackImageURL
        self.date = date
        self.runTime = runTime
        self.distance = distance
        self.avgSpeed = avgSpeed
    }
    
}
