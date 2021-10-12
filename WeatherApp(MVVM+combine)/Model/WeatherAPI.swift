//
//  WeatherAPI.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import Foundation
import Combine
import UIKit



class WeatherAPI {
    static let shared = WeatherAPI()
    
    private let baseaseURL = "https://api.openweathermap.org/data/2.5/forecast"
    private let apiKey = "47fcb2ef67bb9ebaebd0f07fe40c1a80"
    
    private func absoluteURL(city: String) -> URL? {
        let queryURL = URL(string: baseaseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil}
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "q", value: city),
                                    URLQueryItem(name: "units", value: "metric"), URLQueryItem(name: "lang", value: "ru")]
        return urlComponents.url
    }
    
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherJSON, Never> {
        guard let url = absoluteURL(city: city) else {                  // 1
            return Just(WeatherJSON.placeholder)
                .eraseToAnyPublisher()
        }
        return
            URLSession.shared.dataTaskPublisher(for:url)                  // 2
            .map { $0.data }                                          // 3
            .decode(type: WeatherJSON.self, decoder: JSONDecoder()) // 4
            .catch { error in Just(WeatherJSON.placeholder)}        // 5
            .receive(on: RunLoop.main)                                // 6
            .eraseToAnyPublisher()                                    // 7
    }
}
