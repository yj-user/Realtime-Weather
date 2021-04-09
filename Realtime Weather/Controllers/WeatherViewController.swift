//
//  ViewController.swift
//  Realtime Weather
//
//  Created by youngjun kim on 2021/04/08.
//

import UIKit
// 현재위치를 가져오는 툴
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var myTextField: UITextField!
    
    var weatherManager = WeatherManager()
    // CoreLocation 툴과 함께 쓰이는 클래스가 CLLocationManager
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WeatherManagerDelegate 프로토콜을 사용하였으므로 반드시 설정, locationManager 관련된 메소드 보다 먼저 설정되어야 한다
        locationManager.delegate = self
        // CLLocationManager 클래스로 현재 위치정보를 제공할때 가장 먼저 위치제공 동의를 구해야 한다 -> Info.plist 수정
        locationManager.requestWhenInUseAuthorization()
        // 동의를 얻었다면 위치를 한번 제공받는 작업을 수행 (지속적인 제공은 startUpdatingLocation())
        locationManager.requestLocation()
        // requestLocation 메소드를 사용하려면 반드시 didUpdateLocations 와 didFailWithError 를 사용해야한다
        
        // WeatherManager 클래스의 delegate 을 호출하였다 -> WeatherManagerDelegate 프로토콜을 호출한다
        weatherManager.delegate = self
        myTextField.delegate = self
    }
    
    // 검색 버튼을 누르면 키보드가 내려간다
    @IBAction func searchPressed(_ sender: UIButton) {
        myTextField.endEditing(true)
    }
    
    
    
    // 위치 버튼을 누르면 requestLocation 메소드를 한번 더 사용하여 didUpdateLocations 메소드를 다시 호출하겠다
    @IBAction func locationPressed(_ sender: UIButton) {
        // 단, requestLocation 메소드는 위치에 변화가 없으면 다시 작동하지 않으므로 didUpdateLocations 메소드를 중단해야 한다
        locationManager.requestLocation()
        
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    // 키보드의 리턴 버튼을 누르면 키보드가 내려가고 textField 값을 return 한다
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myTextField.endEditing(true)
        return true
    }
    
    // 키보드가 내려가려면 textField 가 비어있어야 하고 그렇지 않으면 placeholder 값을 변경하면서 키보드를 내리지 않는다
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if myTextField.text != "" {
            return true
        } else {
            myTextField.placeholder = "Type the city"
            return false
        }
    }
    
    // 키보드가 내려가면 textField 입력값을 weatherManager 로 보내고 myTextField 를 비운다
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = myTextField.text {
            weatherManager.fetchWeather(city: cityName)
        }
        
        myTextField.text = ""
    }
}


//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    // WeatherManagerDelegate 안에있는 didUpdateWeather 을 끌어옴으로서 WeatherModel 의 정보를 사용할 수 있게 되었다
    func didUpdateWeather(weather: WeatherModel) {
        // WeatherVC 에 보여지기 이전의 작업은 백그라운드 작업이므로 실제 보여지기 위해서는 DispatchQueue 직업이 필요하다
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.weatherCondition())
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.cityName
        }

    }
}

//MARK: - CLLocationManagerDelegate

// CLLocationManagerDelegate 프로토콜은 위치기반의 이벤트를 앱에 전달하기 위해 필요한 기능을 제공한다
extension WeatherViewController: CLLocationManagerDelegate {
    // requestLocation 를 사용하면 위치정보를 받아오는데 성공했을때, 실패했을때 동작을 설정하는 메소드가 필요하다
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 위치정보를 받으면 CLLocation 이 제공하는 latitude, longitude 로 최근 좌표를 생성한다
        if let location = locations.last {
            // requestLocation 메소드가 호출될 때마다 새로 작동하게 하기 위해 현위치를 찾자마자 위치 업데이트를 멈추도록 하였다
            locationManager.stopUpdatingLocation()
            // 위도와 경도를 상수화 하여 weatherManager 로 보낼수 있도록 한다
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            // 생성한 좌표를 WeatherManager 로 보내서 위치를 기반으로 한 URL 을 새로 만든다
            weatherManager.fetchLocation(lat, lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
