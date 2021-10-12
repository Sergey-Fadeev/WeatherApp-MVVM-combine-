//
//  CityListVM.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import Foundation
import Combine



class CityListVM: ObservableObject {
    
    var cityAddFailedCancellable: Cancellable? = nil
    var cityWhetherListCancellable: Cancellable? = nil
    
    @Published var cityAddFailed: Int = 0
    @Published var cityWhetherList: [CityWhetherVM] = []
    
    
    init(model: WhetherModel) {
        cityWhetherList = model.cityWeatherList.compactMap({.init(model: $0)})
        
        cityWhetherListCancellable = wetherSingleton
            .objectWillChange
            .sink(receiveValue: {[weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.cityWhetherList = model.cityWeatherList.compactMap({.init(model: $0)})
                }
            })
        
        cityAddFailedCancellable = wetherSingleton.$cityAddFailed.sink(receiveValue: {
            self.cityAddFailed = $0
        })
    }
    
    
    func addCity(name: String) -> Bool{
        let name = name.trimmingCharacters(in: [" "])
        let contains = cityWhetherList.contains(where: {$0.name.capitalized == name.capitalized})
        
        if !contains{
            wetherSingleton.addCityWhether(cityName: name)
        }
        return !contains
    }
}
