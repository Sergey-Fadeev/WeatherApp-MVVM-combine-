//
//  CollectionViewCell.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
