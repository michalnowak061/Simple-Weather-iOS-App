//
//  FavoritesViewController.swift
//  WeatherApp
//
//  Created by Michał Nowak on 20/08/2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    var weatherDataModel = WeatherDataModel()
    
    weak var delegate: FavoritesViewControllerDelegate?
    
    @IBOutlet weak var favoritesLocations: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesLocations.dataSource = self
        favoritesLocations.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "showAddFavorites":
                guard let addFavVC: FavoritesViewController = segue.destination as? FavoritesViewController else {
                    return
                }
                
                addFavVC.weatherDataModel = weatherDataModel
            default:
                break
            }
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataModel.favoritesLocations.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < weatherDataModel.favoritesLocations.count {
            let cell: FavoriteViewCell = tableView.dequeueReusableCell(withIdentifier: "FavoritesViewCell", for: indexPath) as! FavoriteViewCell
            
            cell.favoriteCity.text = weatherDataModel.favoritesLocations[indexPath.row].name
            cell.favoriteTime.text = weatherDataModel.favoritesLocations[indexPath.row].time
            cell.favoriteTemperature.text = weatherDataModel.favoritesLocations[indexPath.row].temperature + "℃"
            
            return cell
        }
        
        let cell: AddFavoriteViewCell = tableView.dequeueReusableCell(withIdentifier: "AddFavoriteViewCell", for: indexPath) as! AddFavoriteViewCell
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherDataModel.actualLocation = weatherDataModel.favoritesLocations[indexPath.row]
        self.delegate?.weatherDataModelUpdate(data: weatherDataModel)
        
        dismiss(animated: true, completion: nil)
    }
}

protocol FavoritesViewControllerDelegate: class {
    func weatherDataModelUpdate(data: WeatherDataModel) -> ()
}
