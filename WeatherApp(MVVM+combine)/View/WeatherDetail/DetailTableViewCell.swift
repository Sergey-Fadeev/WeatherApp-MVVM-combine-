//
//  DetailTableViewCell.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var dayOfWeak: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tempForDayWeak: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
