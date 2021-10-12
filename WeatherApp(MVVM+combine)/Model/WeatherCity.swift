//
//  WeatherCity.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import Foundation



let daysOfTheWeek: [String] = ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"]


struct WeatherCity {
    let cityName: String?
    let temp: Int?
    let icon: String?
    let descriptionWeather: String?
    let hourlyWeather: [HourlyWeather]
    let dailyWeather: [DailyWeather]
    let json: WeatherJSON
    
    
    init?(dataWeather: WeatherJSON) {
        guard let city = dataWeather.city, let forecastList = dataWeather.forecastList
        else { return nil }
        
        self.json = dataWeather
        
        self.cityName = city.name
        self.icon = forecastList.first?.weather.first?.icon
        self.temp = Int(forecastList.first?.main.temp ?? 0)
        
        var hourlyWeatherArray: [HourlyWeather] = []
        
        let calendar = Calendar.current
        
        for data in forecastList{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            
            let date = formatter.date(from: data.dtTxt)
            let dayText = daysOfTheWeek[(calendar.component(.weekday, from: date!)) - 1]
            let hoursCounter = String(calendar.component(.hour, from: date!))
            
            hourlyWeatherArray.append(HourlyWeather(day: dayText, time: hoursCounter, dataWeather: data, date: date!))
        }
        
        self.hourlyWeather = hourlyWeatherArray
        
        var dailyWeatherDict: [String: [DailyWeather]] = [:]
        self.hourlyWeather.forEach({
            if dailyWeatherDict[$0.day] == nil{
                dailyWeatherDict[$0.day] = []
            }
            
            dailyWeatherDict[$0.day]!.append(.init(dayOfTheWeek: $0.day, dataWeather: $0.dataWeather, date: $0.date))
        })
        
        var dailyWeatherArray = [DailyWeather]()
        dailyWeatherDict.forEach({
            let maxTempWeather = $1.max(by: {$0.temp > $1.temp})!
            dailyWeatherArray.append(maxTempWeather)
        })
        
        dailyWeatherArray.sort(by: {$0.date < $1.date})

        self.dailyWeather = dailyWeatherArray
        self.descriptionWeather = forecastList.last?.weather.last?.weatherDescription
    }
    
    
    func toString() -> String? {
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(self.json)
        let encodedStr = String.init(data: encodedData ?? .init(), encoding: .utf8)
        return encodedStr
    }
}


struct DailyWeather {
    let temp: String
    let dayOfWeek: String
    let icon: String
    let date: Date
    
    var dayIndex: Int?{
        var index = daysOfTheWeek.firstIndex(of: dayOfWeek)
        if index == 0{
            index = dayOfWeek.count
        }
        return index
    }
    
    init(dayOfTheWeek: String, dataWeather: Forecast, date: Date) {
        let tempDouble = Double(round(10*dataWeather.main.temp)/10)
        self.temp = String(tempDouble)
        
        self.dayOfWeek = dayOfTheWeek
        self.icon = dataWeather.weather.first!.icon
        self.date = date
    }
}
    

struct HourlyWeather {
    let temp: String
    var time: String
    let icon: String
    let day: String
    let dataWeather: Forecast
    let date: Date
    
    init(day: String, time: String, dataWeather: Forecast, date: Date) {
        let tempDouble = Double(round(10*dataWeather.main.temp)/10)
        self.temp = String(tempDouble)
        
        let timeInt = Int.init(time)!
        if timeInt < 10{
            self.time = "0\(time)"
        }
        else{
            self.time = time
        }
        
        self.icon = dataWeather.weather.first!.icon
        self.day = day
        self.dataWeather = dataWeather
        self.date = date
    }
}
