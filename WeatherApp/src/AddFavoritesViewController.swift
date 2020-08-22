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
    var locationsIdListCopy: [(String, Int)] = []
    
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var locationsTableView: UITableView!
    
    @IBAction func cancelButtonPush(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        locationsIdListCopy = weatherDataModel.locationsIdList
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        locationsTableView.dataSource = self
        locationsTableView.delegate = self
        
        locationSearchBar.delegate = self
    }
    
    func updateView() {
        locationsTableView.reloadData()
    }
    
    func filteredLocations(searchText: String) -> [(String, Int)] {
        var locations: [(String, Int)] = []
        
        locations = weatherDataModel.locationsIdList.filter {
            $0.0.localizedLowercase.contains(searchText)
        }
        
        return locations
    }
}
extension AddFavoritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.localizedLowercase
        
        if searchText.count > 0 {
            let filteredLocations: [(String, Int)] = self.filteredLocations(searchText: searchText)
            weatherDataModel.locationsIdList = filteredLocations
        }
        else {
            weatherDataModel.locationsIdList = locationsIdListCopy
        }
        print("TUTAJ")
        
        updateView()
    }
}
extension AddFavoritesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.localizedLowercase
        
        if searchText.count > 0 {
            let filteredLocations: [(String, Int)] = self.filteredLocations(searchText: searchText)
            weatherDataModel.locationsIdList = filteredLocations
        }
        
        updateView()
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
        let location = Location(id: id, name: name, weather: "--", temperature: "--", time: "--:--")
    
        weatherDataModel.locationsIdList = locationsIdListCopy
        weatherDataModel.favoritesLocations.append(location)
        
        self.delegate?.weatherDataModelUpdate(data: weatherDataModel)
        dismiss(animated: true, completion: nil)
    }
}

protocol AddFavoritesViewControllerDelegate: class {
    func weatherDataModelUpdate(data: WeatherDataModel) -> ()
}
