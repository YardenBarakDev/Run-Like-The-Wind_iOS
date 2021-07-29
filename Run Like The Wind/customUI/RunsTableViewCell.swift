//
//  RunsTableViewCell.swift
//  Run Like The Wind
//
//  Created by Yarden Barak on 28/06/2021.
//

import UIKit

class RunsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var RunTableViewCell_IMG_trackImage: UIImageView!
    
    @IBOutlet weak var RunTableViewCell_LBL_date: UILabel!
    
    @IBOutlet weak var RunTableViewCell_LBL_runTime: UILabel!
    
    
    @IBOutlet weak var RunTableViewCell_LBL_distance: UILabel!
    
    
    @IBOutlet weak var RunTableViewCell_LBL_avgSpeed: UILabel!
    
    
    @IBOutlet weak var RunTableViewCell_LBL_caloriesBurned: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
