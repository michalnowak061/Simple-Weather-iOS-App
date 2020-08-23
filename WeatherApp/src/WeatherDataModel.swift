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
    var feelsLike: Double
    var minTemperature: Double
    var maxTemperature: Double
    var pressure: Int
    var humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
}

struct WeatherInfoVO: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
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

struct Location: Codable {
    var id = 833
    var name = "-"
    var weather = "-"
    var temperature = "--"
    var minMaxTemperature = "--/--"
    var feelsLike = "--"
    var pressure = "----"
    var humidity = "--"
    var time = "--:--"
    var icon = "-"
    
    public func getIcon() -> UIImage {
        
        switch self.icon {
        case "01d":
            return #imageLiteral(resourceName: "01d.png")
        case "01n":
            return #imageLiteral(resourceName: "01n.png")
        case "02d":
            return #imageLiteral(resourceName: "02d.png")
        case "02n":
            return #imageLiteral(resourceName: "02n.png")
        case "03d":
            return #imageLiteral(resourceName: "03d.png")
        case "03n":
            return #imageLiteral(resourceName: "03n.png")
        case "04d":
            return #imageLiteral(resourceName: "04d.png")
        case "04n":
            return #imageLiteral(resourceName: "04n.png")
        case "09d":
            return #imageLiteral(resourceName: "09d.png")
        case "09n":
            return #imageLiteral(resourceName: "09n.png")
        case "10d":
            return #imageLiteral(resourceName: "10d.png")
        case "10n":
            return #imageLiteral(resourceName: "10n.png")
        case "11d":
            return #imageLiteral(resourceName: "11d.png")
        case "11n":
            return #imageLiteral(resourceName: "11n.png")
        case "13d":
            return #imageLiteral(resourceName: "13d.png")
        case "13n":
            return #imageLiteral(resourceName: "13n.png")
        case "50d":
            return #imageLiteral(resourceName: "50d.png")
        case "50n":
            return #imageLiteral(resourceName: "50n.png")
        default:
            return #imageLiteral(resourceName: "01d.png")
        }
    }
}

class WeatherDataModel {
    var locationsIdList: [(String, Int)] = []
    var actualLocation: Location = Location()
    var favoritesLocations: [Location] = []
    
    init() {
    }
    
    public func update() {
        OpenWeatherMap.instance.downloadJSON(id: actualLocation.id) { (response, error) in
            if error != nil {
                return
            }
            else if let responseModel = response {
                self.actualLocation.name = responseModel.name
                self.actualLocation.weather = responseModel.weather[0].description
                self.actualLocation.temperature = String(format: "%.0f", responseModel.forecast.temperature)
                self.actualLocation.feelsLike = String(format: "%.0f", responseModel.forecast.feelsLike)
                self.actualLocation.minMaxTemperature = String(format: "%.0f",responseModel.forecast.minTemperature) + "/" + String(format: "%.0f", responseModel.forecast.maxTemperature)
                self.actualLocation.pressure = String(responseModel.forecast.pressure)
                self.actualLocation.humidity = String(responseModel.forecast.humidity)
                self.actualLocation.icon = responseModel.weather[0].icon
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
                        self.favoritesLocations[index].icon = responseModel.weather[0].icon
                    }
                }
            }
        }
    }
    
    public func save() {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let actualLocationEncoded = try? JSONEncoder().encode(self.actualLocation)
        let favoritesLocationEncoded = try? JSONEncoder().encode(self.favoritesLocations)
        
        let actualLocationfilePath = documentsDirectoryPathString + "/actualLocationData.json"
        let favoritesLocationfilePath = documentsDirectoryPathString + "/favoritesLocationData.json"
        
        if !FileManager.default.fileExists(atPath: actualLocationfilePath) {
            FileManager.default.createFile(atPath: actualLocationfilePath, contents: actualLocationEncoded, attributes: nil)
        }
        else {
            if let file = FileHandle(forWritingAtPath: actualLocationfilePath) {
                file.write(actualLocationEncoded!)
            }
        }
        
        if !FileManager.default.fileExists(atPath: favoritesLocationfilePath) {
            FileManager.default.createFile(atPath: favoritesLocationfilePath, contents: favoritesLocationEncoded, attributes: nil)
        }
        else {
            if let file = FileHandle(forWritingAtPath: favoritesLocationfilePath) {
                file.write(favoritesLocationEncoded!)
            }
        }
    }
    
    public func load() {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let actualLocationfilePath = documentsDirectoryPathString + "/actualLocationData.json"
        let favoritesLocationfilePath = documentsDirectoryPathString + "/favoritesLocationData.json"
        
        if FileManager.default.fileExists(atPath: actualLocationfilePath) {
            if let file = FileHandle(forReadingAtPath: actualLocationfilePath) {
                let data = file.readDataToEndOfFile()
                let actualLocationDecoded = try? JSONDecoder().decode(Location.self, from: data)
                
                self.actualLocation = actualLocationDecoded!
            }
        }
        
        if FileManager.default.fileExists(atPath: favoritesLocationfilePath) {
            if let file = FileHandle(forReadingAtPath: favoritesLocationfilePath) {
                let data = file.readDataToEndOfFile()
                let favoritesLocationDecoded = try? JSONDecoder().decode([Location].self, from: data)
                
                self.favoritesLocations = favoritesLocationDecoded!
            }
        }
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
