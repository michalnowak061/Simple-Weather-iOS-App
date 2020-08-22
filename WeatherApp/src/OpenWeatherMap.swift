//
//  ForecastStore.swift
//  WeatherApp
//
//  Created by Michał Nowak on 21/08/2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import Alamofire

class OpenWeatherMap {
    public static let instance: OpenWeatherMap = OpenWeatherMap()
    
    static let WEATHER_API = "https://api.openweathermap.org/data/2.5/weather"
    static let WEATHER_API_QUERY = "?appid=dd3d48457309e54804512f943cb085a2&units=metric"
    
    enum LoadingError {
        case invalidCity
        case noConnection
        case invalidURL
        case wrongResponse
    }
    
    private init() {
        
    }
    
    func downloadJSON(id: Int, callback: @escaping(WeatherResponse?, LoadingError?) -> ()) {
        let urlString = OpenWeatherMap.WEATHER_API + OpenWeatherMap.WEATHER_API_QUERY + "&id=" + String(describing: id)
        
        Alamofire.request(urlString).responseJSON { response in
            guard let JSON = response.data else {
                callback(nil, LoadingError.wrongResponse)
                return
            }
            
            switch response.result {
            case .success:
                let decoder = JSONDecoder()
                let responseModel = try! decoder.decode(WeatherResponse.self, from: JSON)
                callback(responseModel, nil)
            case .failure:
                callback(nil, LoadingError.wrongResponse)
            }
        }
    }
}
