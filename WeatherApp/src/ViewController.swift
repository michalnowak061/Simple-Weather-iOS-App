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
    
    @IBOutlet weak var nextDays: UITableView!
    
    let queue = DispatchQueue(label: "work-queue")

    override func viewDidLoad() {
        queue.async {
            self.task()
        }
        
        nextDays.dataSource = self
    }
    
    func updateView() {
        locationName.text = weatherDataModel.actualLocation.name
        locationWeather.text = weatherDataModel.actualLocation.weather
        locationTemperature.text = weatherDataModel.actualLocation.temperature + "℃"
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
            default:
                break
            }
        }
    }
    
    func weatherDataModelUpdate(data: WeatherDataModel) {
        weatherDataModel = data
    }
    
    func task() {
        while(true) {
            weatherDataModel.update()
            DispatchQueue.main.async {
                self.updateView()
            }
            sleep(1)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataModel.weatherForDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherForDayCell", for: indexPath) as! WeatherForDayCell
        
        cell.day.text = weatherDataModel.weatherForDays[indexPath.row].day
        cell.icon.image = weatherDataModel.getIcon(index: indexPath.row)
        cell.minmaxTemperature.text = weatherDataModel.weatherForDays[indexPath.row].minTemperature + "/" + weatherDataModel.weatherForDays[indexPath.row].maxTemperature + "℃"
        
        return cell
    }
}
