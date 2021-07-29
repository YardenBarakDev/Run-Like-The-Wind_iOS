
import UIKit
import GoogleMaps

class RunController: UIViewController {

    @IBOutlet weak var runMap: GMSMapView!
    @IBOutlet weak var Run_LBL_runTime: UILabel!
    
    private var coordinatesArray: [CLLocation] = []


    var runPresenter : RunPresenter?
    let locationManager = CLLocationManager()
    let path = GMSMutablePath()
    var polyline : GMSPolyline?
    var locationPermissionHelper : LocationPermissionHelper?
    var currentLocation: CLLocation?
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
          
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set presenter
        runPresenter = RunPresenter()
        runPresenter?.setViewDelegate(delegate: self)
        
        //set location attributes
        setLocation()
        
        setPolylineSettings()
        
        
    }

    private func setLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationPermissionHelper = LocationPermissionHelper(locationManager: locationManager)
        runMap.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()
    }
    
    private func setPolylineSettings(){
        polyline?.map = runMap
        
        polyline?.strokeColor = .green
        polyline?.strokeWidth = 10.0
        polyline?.geodesic = true
        
    }
    
    func openSettings(){
        let alertController = UIAlertController (title: Constants.settingsTitle, message: Constants.settingsMessage, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func startRun(_ sender: UIButton) {
        if (sender.currentTitle == "Start") {
            locationManager.startUpdatingLocation()
            runPresenter?.startTimer()
            sender.setTitle("Stop", for: UIControl.State.normal)
        }
        else{
            locationManager.stopUpdatingLocation()
            runPresenter?.stopTimer()
            finishRun()
            returnToMainPage()
        }
    }
    
    private func finishRun(){
        // get screenshot
        getScreenShot()
      
        let date = Date.getCurrentDate()
        let distance = runPresenter?.getDistanceInKM(coordinatesArray: coordinatesArray) ?? 0
        let avgSpeed = runPresenter?.getAvgSpeedInKM(distance: distance ) ?? 0
        let runTime = Run_LBL_runTime.text ?? " "
        
        let singleRun = SingleRun(trackImageURL: "url check", date: date, runTime: runTime, distance: distance, avgSpeed: avgSpeed)
        runPresenter?.saveRunInDB(singleRun: singleRun)
        
    }
    
    private func getScreenShot(){
        //get the cordinate bounds so we can see the whole track
        let bound = runPresenter?.zoomOutToShowWholeTrack(path: path) ?? GMSCoordinateBounds()
   
        //zoom out the map so we can take a screenshoot of the whole track
        runMap.animate(with: GMSCameraUpdate.fit(bound))
        
        //
        let image = UIGraphicsImageRenderer(size: runMap.bounds.size).image { _ in
            runMap.drawHierarchy(in: runMap.bounds, afterScreenUpdates: true)
        }
        
        runPresenter?.uploadImageToDB(image: image)
    }
    func returnToMainPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}

//MARK: callback from presenter
extension RunController : RunPresenterDelegate{
    func timerUpdate(time: String) {
        Run_LBL_runTime.text = time
    }
}

//MARK: location methods
extension RunController : CLLocationManagerDelegate{
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        for location in locations {
               
               self.coordinatesArray.append(location)
               
               let index = self.coordinatesArray.count
               
               if index > 2 {
               
                   let path = GMSMutablePath()
                   path.add(self.coordinatesArray[index - 1].coordinate)
                   path.add(self.coordinatesArray[index - 2].coordinate)
                   
                   let polyline = GMSPolyline(path: path)
                polyline.strokeColor = .red
                   polyline.strokeWidth = 5.0
                   polyline.map = self.runMap
                   
               }
               
           }
        
        
        
        
        let latitude = locationManager.location?.coordinate.latitude ?? 0.0
        let longitude = locationManager.location?.coordinate.longitude ?? 0.0
        path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        polyline = GMSPolyline(path: path)
        print("lon = \(longitude), lat = \(latitude)")
        showLocationOnTheMap(lat: latitude, lon: longitude)
      }
    
    // Handle authorization for the location manager.
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
          fatalError()
        }

        // Handle authorization status
        switch status {
        case .restricted:
          print("Location access was restricted.")
        case .denied:
          print("User denied access to location.")
          // Display the map using the default location.
            runMap.isHidden = false
        case .notDetermined:
          print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
          print("Location status is OK.")
        @unknown default:
          fatalError()
        }
      }

      // Handle location manager errors.
      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
      }
 
    func showLocationOnTheMap(lat : Double, lon : Double){
        runMap.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                             zoom: 20,
                                             bearing: 0,
                                             viewingAngle: 0)
    }
    
}
   

