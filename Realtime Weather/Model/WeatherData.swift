//
//  WeatherData.swift
//  Realtime Weather
//
//  Created by youngjun kim on 2021/04/08.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
