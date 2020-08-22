//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Michał Nowak on 20/08/2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import UIKit

struct WeatherVO: Codable {
    var temperature: Double
    var pressure: Int
    var humidity: Int
    var minTemperature: Double
    var maxTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case pressure
        case humidity
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
}

struct WeatherInfoVO: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct WindVO: Codable {
    var speed: Double
    var degree: Double
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degree = "deg"
    }
}

struct WeatherResponse: Codable {
    var weather: [WeatherInfoVO]
    var visibility: Int
    var wind: WindVO
    var time: Int
    var name: String
    var id: Int
    var responseCode: Int
    var forecast: WeatherVO
    
    enum CodingKeys: String, CodingKey {
        case weather
        case visibility
        case wind
        case time = "dt"
        case name
        case id
        case responseCode = "cod"
        case forecast = "main"
    }
}

struct LocationVO: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

struct Location {
    var id = 833
    var name = "-"
    var weather = "-"
    var temperature = "--"
    var time = "--:--"
}

struct WeatherForDay {
    var day = "-"
    var weather = "-"
    var minTemperature = "-"
    var maxTemperature = "-"
}

class WeatherDataModel {
    var locationsIdList: [(String, Int)] = []
    var actualLocation: Location = Location()
    var favoritesLocations: [Location] = []
    var weatherForDays: [WeatherForDay] = []
    
    init() {
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
    
    public func update() {
        OpenWeatherMap.instance.downloadJSON(id: actualLocation.id) { (response, error) in
            if error != nil {
                print("Wystapil blad: \(String(describing: error))")
            }
            else if let responseModel = response {
                self.actualLocation.name = responseModel.name
                self.actualLocation.temperature = String(format: "%.0f", responseModel.forecast.temperature)
                self.actualLocation.weather = responseModel.weather[0].description
            }
        }
        
        if favoritesLocations.count > 0 {
            for index in 0...favoritesLocations.count - 1 {
                let locationId = favoritesLocations[index].id
                
                OpenWeatherMap.instance.downloadJSON(id: locationId) { (response, error) in
                    if error != nil {
                        print("Wystapil blad: \(String(describing: error))")
                    }
                    else if let responseModel = response {
                        self.favoritesLocations[index].name = responseModel.name
                        self.favoritesLocations[index].temperature = String(format: "%.0f", responseModel.forecast.temperature)
                        self.favoritesLocations[index].weather = responseModel.weather[0].description
                    }
                }
            }
        }
    }
    
    public func save() {
        
    }

    public func loadCityIdJSON() {
        if let url = Bundle.main.url(forResource: "city.list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data) as! [[String: Any]]
                
                for cityList in json {
                    let cityName: String = cityList["name"]! as! String
                    let cityID: Int = cityList["id"]! as! Int
                    
                    let city = (cityName, cityID)
                    
                    self.locationsIdList.append(city)
                }
            } catch let jsonErr {
                print("err", jsonErr)
            }
        }
    }
}
