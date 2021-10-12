//
//  WeatherModel.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import Foundation
import Combine



class WhetherModel: ObservableObject {
    
    var weatherProviderCancellable: Cancellable? = nil
    
    
    var weatherProvider = WeatherAPI()
    
    
    @Published var cityAddFailed: Int = 0
    
    
    @Published var cityWeatherList: [WeatherCity] = []
    
    
    let defaults = Defaults()
    
    
    init() {
        if let savedCityWeather = defaults.get(key: Defaults.defaultsKeys.keyModel.rawValue){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([String].self, from: savedCityWeather.data(using: .utf8)!){
                NSLog("Model loaded \(decoded.count) cities")
                for cityName in decoded{
                    addCityWhether(cityName: cityName)
                }
            }
        }
    }
    
    
    func addCityWhether(cityName: String) {
        //делаем запрос на сервак, парсим данные
        let cityName = cityName.trimmingCharacters(in: [" "])
        let weatherPublished = weatherProvider.fetchWeather(for: cityName)
        weatherProviderCancellable = weatherPublished.sink(receiveValue: { [self]
            jsonResult in
            //создаем модель погоды города
            if let weatherCity = WeatherCity.init(dataWeather: jsonResult){
                self.cityWeatherList.insert(weatherCity, at: 0)
            }
            else{
                cityAddFailed += 1
                let str = toString()
                print(str)
            }
        })
    }
    
    
    func deleteWeather(cityName: String){
        cityWeatherList.removeAll(where: {
            $0.cityName == cityName
        })
    }
    
    
    func toString() -> String{
        let jsonList: [String] = cityWeatherList.compactMap { weatherCity in
            return "\"" + weatherCity.cityName! + "\""
        }
        
        
        var jsonStr = ""
        var i = 0
        for json in jsonList{
            jsonStr += json
            if i != jsonList.count - 1{
                jsonStr += ","
            }
            i += 1
        }
        
        return "[\(jsonStr)]"
    }
    
    
    func save() {
        let modelStr = self.toString()
        defaults.set(key: Defaults.defaultsKeys.keyModel.rawValue, value: modelStr)
    }
}
