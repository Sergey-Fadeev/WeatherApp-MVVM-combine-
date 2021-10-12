//
//  CityWeatherDetail.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import UIKit



class CityWhetherDetail: UIViewController {
    
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
 
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var dailyWeatherCollection: UICollectionView!
    @IBOutlet weak var tableWeatherForEveryDay: UITableView!

    
    unowned var VM: CityWhetherVM!
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        todayLabel.text = VM.dailyWeather[0].dayOfWeek
        tableWeatherForEveryDay.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "detailTableViewCell")
        tableWeatherForEveryDay.delegate = self
        tableWeatherForEveryDay.dataSource = self
        
        dailyWeatherCollection.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        dailyWeatherCollection.delegate = self
        dailyWeatherCollection.dataSource = self
        
        cityNameLabel.text = "\(VM.name)"
        weatherDescription.text = VM.descriptionWeather
        cityTemp.text = VM.temp
    }
}



extension CityWhetherDetail: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.dailyWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableWeatherForEveryDay.dequeueReusableCell(withIdentifier: "detailTableViewCell")! as! DetailTableViewCell
        cell.dayOfWeak.text = VM.dailyWeather[indexPath.row].dayOfWeek
        cell.iconImage.image = UIImage.init(named:VM.dailyWeather[indexPath.row].icon)
        cell.tempForDayWeak.text = VM.dailyWeather[indexPath.row].temp
        return cell
    }
}



extension CityWhetherDetail: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        VM.hourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dailyWeatherCollection.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        cell.cityName.text = VM.hourlyWeather[indexPath.row].time
        cell.iconImage.image = UIImage.init(named: VM.hourlyWeather[indexPath.row].icon)
        cell.tempLabel.text = VM.hourlyWeather[indexPath.row].temp
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dailyWeatherCollection.deselectItem(at: indexPath, animated: true)
    }
    
    
}
