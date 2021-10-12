//
//  CityWeatherVM.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import Foundation
import Combine



class CityWhetherVM: ObservableObject {
    
    let name: String
    let temp: String
    let iconName: String
    let descriptionWeather: String
    let dailyWeather: [DailyWeather]
    let hourlyWeather: [HourlyWeather]
    
    func deleteWeatherCity(){
        wetherSingleton.deleteWeather(cityName: name)
    }
    
    init(model: WeatherCity) {
        self.name = model.cityName ?? "Неизвестно"
        self.temp = "\(String(model.temp ?? 0)) Cº"
        self.iconName = model.icon ?? "Ошибка"
        self.descriptionWeather = model.descriptionWeather ?? "Неизвестно"
        self.dailyWeather = model.dailyWeather
        self.hourlyWeather = model.hourlyWeather
    }
}
