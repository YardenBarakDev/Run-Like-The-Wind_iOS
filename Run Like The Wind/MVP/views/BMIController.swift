//
//  BMIController.swift
//  Run Like The Wind
//
//  Created by Yarden Barak on 28/06/2021.
//

import UIKit

class BMIController: UIViewController {

    @IBOutlet weak var BMI_LBL_height: UILabel!
    @IBOutlet weak var BMI_LBL_weight: UILabel!
    @IBOutlet weak var BMI_LBL_bmi: UILabel!
    
    var currentHeight : Float = 0.1
    var currentWeight : Float = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func heightSliderChange(_ sender: UISlider) {
        let height = String(format: "%.2f", sender.value)
        currentHeight = sender.value
        BMI_LBL_height.text = "\(height)m"
        calculateBMI()
    }
    
    
    @IBAction func weightSliderChange(_ sender: UISlider) {
        let weight = String(format: "%.0f", sender.value)
        currentWeight = sender.value
        BMI_LBL_weight.text = "\(weight)kg"
        calculateBMI()
    }
    
    func calculateBMI(){
        let bmi = currentWeight / pow(currentHeight, 2)
        BMI_LBL_bmi.text = String(format: "%.2f", bmi)
    }
}
