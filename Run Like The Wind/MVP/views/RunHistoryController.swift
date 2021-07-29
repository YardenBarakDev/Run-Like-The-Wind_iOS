
import UIKit
import MaterialComponents.MaterialButtons

class RunHistoryController: UIViewController{

    @IBOutlet weak var RunHistory_TV_runs: UITableView!
    @IBOutlet weak var RunHistory_Picker: UIPickerView!
    
    private let pickerOptions = ["Date", "Distance", "Avarage speed"]
    private var previousRuns = [SingleRun]()
    private let presenter = RunHistoryPresenter()
    private let runDBAccess = RunDBAccess.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
        initPresenter()
        initPicker()
  
    }

    //init UITableView
    private func initTableView(){
        let nib = UINib(nibName: "RunsTableViewCell", bundle: nil)
        RunHistory_TV_runs.register(nib, forCellReuseIdentifier: "RunsTableViewCell")
        RunHistory_TV_runs.delegate = self
        RunHistory_TV_runs.dataSource = self
    }
    
    func initPresenter(){
        presenter.setViewDelegate(delegate: self)
        presenter.fetchRunsFromDB()
    }
    
    func initPicker(){
        RunHistory_Picker.delegate = self
        RunHistory_Picker.dataSource = self
    }
    
    @IBAction func startNewRun(_ sender: MDCFloatingButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "RunNavigationController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }

}

//MARK: TableView functions

extension RunHistoryController : UITableViewDelegate{}

extension RunHistoryController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousRuns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RunHistory_TV_runs.dequeueReusableCell(withIdentifier: "RunsTableViewCell", for: indexPath) as! RunsTableViewCell
        
        
        let run = previousRuns[indexPath.row]
        let url = URL(string: run.trackImageURL)
        let data = try? Data(contentsOf: url!)
        if let data = data{
            cell.RunTableViewCell_IMG_trackImage.image = UIImage(data: data)
        }
        
        cell.RunTableViewCell_LBL_avgSpeed.text = "Avg speed: \(String(format: "%.2f", run.avgSpeed)) KMPH"
        cell.RunTableViewCell_LBL_date.text = "Date: \(run.date)"
        cell.RunTableViewCell_LBL_distance.text = "Distance: \(String(format: "%.2f", run.distance)) KM"
        cell.RunTableViewCell_LBL_runTime.text = "Run time: \(run.runTime)"

        return cell
    }
}


//MARK: PickerMethods

extension RunHistoryController : UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerOptions[row])
        if (row == 0) {
            presenter.sortRunByDate(allRuns: previousRuns)
        }
        else if (row == 1){
            presenter.sortRunsByDistance(allRuns: previousRuns)
        }
        else{
            presenter.sortRunsByAvgSpeed(allRuns: previousRuns)
        }
    }
}

extension RunHistoryController : UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    
}

//MARK: RunHistoryPresenterDelegate callback
extension RunHistoryController: RunHistoryPresenterDelegate{
    func returnedRuns(result: [SingleRun]?) {
        if let array = result{
            //update run history array
            previousRuns = array
        }
        DispatchQueue.main.async {
            //reload table view after the data arrive from the db
            self.RunHistory_TV_runs.reloadData()
        }
    }
}
