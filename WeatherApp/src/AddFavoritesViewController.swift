//
//  AddFavoritesViewController.swift
//  WeatherApp
//
//  Created by Michał Nowak on 20/08/2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import UIKit

class AddFavoritesViewController: UIViewController {
    var weatherDataModel = WeatherDataModel()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    weak var delegate: AddFavoritesViewControllerDelegate?
    
    @IBAction func cancelButtonPush(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var locationsTableView: UITableView!
    
    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        locationsTableView.dataSource = self
        locationsTableView.delegate = self
    }
}

extension AddFavoritesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.localizedLowercase
        
        if searchText.count > 0 {
            /*
            var filteredCountries:[Country] = []
            
            for country in countries {
                if let filteredCountry = filteredCities(in: country, searchText: searchText) {
                    filteredCountries.append(filteredCountry)
                }
            }
            
            countries = filteredCountries
            */
        }
        else {
            //countries = Country.getHardCodedData()
        }
        
        //tableView.reloadData()
    }
}

extension AddFavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataModel.locationsIdList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CityIDViewCell = tableView.dequeueReusableCell(withIdentifier: "CityIDViewCell", for: indexPath) as! CityIDViewCell
        
        cell.cityName.text = weatherDataModel.locationsIdList[indexPath.row].0

        return cell
    }
}

extension AddFavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = weatherDataModel.locationsIdList[indexPath.row].0
        let id = weatherDataModel.locationsIdList[indexPath.row].1
        let location = Location(id: id, name: name, weather: "", temperature: "", time: "")
    
        weatherDataModel.favoritesLocations.append(location)
        
        self.delegate?.weatherDataModelUpdate(data: weatherDataModel)
        dismiss(animated: true, completion: nil)
    }
}

protocol AddFavoritesViewControllerDelegate: class {
    func weatherDataModelUpdate(data: WeatherDataModel) -> ()
}
