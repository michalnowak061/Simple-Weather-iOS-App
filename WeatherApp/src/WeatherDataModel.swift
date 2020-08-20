//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Michał Nowak on 20/08/2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import UIKit

class WeatherDataModel {
    var actualLocation: Location
    var favoritesLocations: [Location] = []
    var weatherForDays: [WeatherForDay] = []
    
    init() {
        self.actualLocation = Location(name: "Nowy Jork", weather: "Słonecznie", temperature: "12", time: "8:00")
        self.favoritesLocations.append(Location(name: "Nowy Jork", weather: "Słonecznie", temperature: "12", time: "8:00"))
        self.favoritesLocations.append(Location(name: "Bolesławiec", weather: "lekki deszcz", temperature: "-10", time: "12:33"))
        self.weatherForDays.append(WeatherForDay(day: "Teraz", weather: "słonecznie", minTemperature: "10", maxTemperature: "20"))
        self.weatherForDays.append(WeatherForDay(day: "Poniedziałek", weather: "lekki deszcz", minTemperature: "12", maxTemperature: "22"))
    }
    
    public func getIcon(index: Int) -> UIImage {
        let weather = weatherForDays[index].weather
        
        switch weather.lowercased() {
        case "słonczenie":
            return #imageLiteral(resourceName: "slonecznie.jpg")
        case "deszcz":
            return #imageLiteral(resourceName: "deszcz.jpg")
        case "lekki deszcz":
            return #imageLiteral(resourceName: "lekki_deszcz.jpg")
        case "śnieg":
            return #imageLiteral(resourceName: "snieg.png")
        case "zachmurzenie":
            return #imageLiteral(resourceName: "zachmurzenie.jpg")
        case "częściowe zachmurzenie":
            return #imageLiteral(resourceName: "czesciowe_zachmurzenie.jpg")
        default:
            return #imageLiteral(resourceName: "slonecznie.jpg")
        }
    }
}
