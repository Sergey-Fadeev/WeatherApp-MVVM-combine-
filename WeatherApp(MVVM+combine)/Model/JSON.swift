//
//  JSON.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import Foundation

// MARK: - DataWeather
struct WeatherJSON: Codable {
    let forecastList: [Forecast]?
    let city: City?
    
    enum CodingKeys: String, CodingKey {
        case forecastList = "list"
        case city
    }
    
    static var placeholder: Self{
        return WeatherJSON(forecastList: nil, city: nil)
    }
}


// MARK: - City
struct City: Codable {
    let name: String
}

// MARK: - List
struct Forecast: Codable {
    let main: MainClass
    let weather: [Weather]
    let wind: Wind
    let visibility: Int
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case main, weather, wind, visibility
        case dtTxt = "dt_txt"
    }
}


// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: MainEnum
    let weatherDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
