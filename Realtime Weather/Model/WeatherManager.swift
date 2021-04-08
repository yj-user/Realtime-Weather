//
//  WeatherController.swift
//  Realtime Weather
//
//  Created by youngjun kim on 2021/04/08.
//

import Foundation

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=155de75654034a71c7e6b6dd424ee5d5&units=metric"
    
    // WeatherVC 에서 키보드가 내려가면 textField 입력값을 전달받아서 urlString 을 완성한다
    func fetchWeather(city: String) {
        let urlString = "\(weatherUrl)&q=\(city)"
        
        // 완성한 urlString 을 performRequest 함수에서 사용하도록 url 로 보낸다
        performRequest(url: urlString)
    }
    
    // 완성된 urlString 을 url 삼아, 서버에서 원하는 내용을 가져오는 네트워킹 작업을 하는 함수다
    func performRequest(url: String) {
        
        // 1. URL 을 만들고
        if let url = URL(string: url) {
            // 2. URLSession 을 만들고
            let urlSession = URLSession(configuration: .default)
            // 3. URLSession 에 task 를 부여하고 dataTask 의 기능인 data 를 가져오는 작업을 수행한다
            let task = urlSession.dataTask(with: url) { (data, urlResponse, error) in
                // 이떄 error 가 있으면 그대로 작업을 중단하고
                if error != nil {
                    return
                }
                // data 를 unwrapping 하고 data 를 가져오는데, 내가 원하는 데이터만 뽑아서 가져오도록 하겠다
                if let safeData = data {
                    // 그래서 JSON 을 읽어오는 함수를 새로 만들어서 수행하는데 unwrapping 한 data 를 제공하겠다
                    self.parseJson(data: safeData)
                    
                }
            }
            // 4. task 를 수행한다
            task.resume()
        }
    }
    
    // 온라인상의 JSON 사이트에서 원하는 정보를 가져오는데 필요한 데이터는 위에서 받아왔다
    func parseJson(data: Data) {
        
        // JSON 으로 데이터를 넘겨주고 필요한 정보를 뽑아올때 정보를 해독하는 기능이 필요하므로 JSONDecoder 를 설정한다
        let decoder = JSONDecoder()
        
        // 서버에서 정보를 가져오는 작업은 에러가 발생할 수 있기 때문에 try 문을 사용하는데
        do {
            // JSONDecoder 로 WeatherData (타입) 을 해독하겠다. 받아온 정보(data) 를 가지고.
            let decodecData = try decoder.decode(WeatherData.self, from: data)
            // WeatherData 는 JSON 에서 가져오는 정보를 담아내는 뼈대 이다. Model 의 본래 역할
            let id = decodecData.weather[0].id
            let name = decodecData.name
            let temp = decodecData.main.temp
            
            // WeatherVC 에서 위 항목들이 필요한데 함수 안에 있는 상수는 가져올 수 없으므로 WeatherModel 보냈다
            let weather = WeatherModel(weatherId: id, cityName: name, temperature: temp)
            
            print(weather.tempString)
        } catch {
            
        }
        
    }
    
    
    
}
