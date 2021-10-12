//
//  Defaults.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import Foundation


class Defaults {
    enum defaultsKeys: String {
        case keyModel = "model"
    }
    
    
    let defaults = UserDefaults.standard
    
    
    func get(key: String) -> String?{
        return defaults.string(forKey: key)
    }
    
    
    func set(key: String, value: String) {
        defaults.set(value, forKey: key)
    }
}
