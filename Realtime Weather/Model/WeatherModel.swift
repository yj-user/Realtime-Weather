//
//  WeatherModel.swift
//  Realtime Weather
//
//  Created by youngjun kim on 2021/04/09.
//

import Foundation

struct WeatherModel {
    
    // WeatherVC 에서 바로 가져갈 수 있도록 WeatherManager 에서 해당 정보를 가져왔다
    let weatherId: Int
    let cityName: String
    let temperature: Double
    
    // computed property 로서 tempString 을 호출하면 소수점 1자리 온도가 출력된다
    var tempString: String {
        return String(format: "%.1f", temperature)
    }
    
    // 함수 안에 switch 문이 들어가 있는 형태로 switch 가 weatherId 를 입력받아, 함수 호출할때 따로 입력하지 않아도 된다
    func weatherCondition() -> String {
        switch weatherId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
        
    }
    
}
