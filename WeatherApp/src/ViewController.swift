//
//  ViewController.swift
//  WeatherApp
//
//  Created by Michał Nowak on 20/08/2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, FavoritesViewControllerDelegate {
    var weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationWeather: UILabel!
    @IBOutlet weak var locationTemperature: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationMinMaxTemperature: UILabel!
    @IBOutlet weak var locationFeelsLike: UILabel!
    @IBOutlet weak var locationPressure: UILabel!
    @IBOutlet weak var locationHumidity: UILabel!
    
    let queue = DispatchQueue(label: "work-queue")

    override func viewDidLoad() {
        queue.async {
            self.weatherDataModel.loadCityIdJSON()
            self.weatherDataModel.load()
            
            while(true) {
                self.weatherDataModel.update()
                DispatchQueue.main.async {
                    self.updateView()
                }
                sleep(2)
                
                self.weatherDataModel.save()
            }
        }
    }
    
    func updateView() {
        locationName.text = weatherDataModel.actualLocation.name
        locationWeather.text = weatherDataModel.actualLocation.weather
        locationTemperature.text = weatherDataModel.actualLocation.temperature + "℃"
        locationFeelsLike.text = weatherDataModel.actualLocation.feelsLike + "℃"
        locationMinMaxTemperature.text = weatherDataModel.actualLocation.minMaxTemperature + "℃"
        locationPressure.text = weatherDataModel.actualLocation.pressure + "hPa"
        locationHumidity.text = weatherDataModel.actualLocation.humidity + "%"
        locationIcon.image = weatherDataModel.actualLocation.getIcon()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "showFavorites":
                guard let favVC: FavoritesViewController = segue.destination as? FavoritesViewController else {
                    return
                }
                
                favVC.weatherDataModel = weatherDataModel
                favVC.delegate = self
                
                queue.async {}
            default:
                break
            }
        }
    }
    
    func weatherDataModelUpdate(data: WeatherDataModel) {
        weatherDataModel = data
        updateView()
    }
}
