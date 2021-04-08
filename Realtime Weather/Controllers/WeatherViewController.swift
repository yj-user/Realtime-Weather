//
//  ViewController.swift
//  Realtime Weather
//
//  Created by youngjun kim on 2021/04/08.
//

import UIKit

class WeatherViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var myTextField: UITextField!
    
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTextField.delegate = self
    }
    
    // 검색 버튼을 누르면 키보드가 내려간다
    @IBAction func searchPressed(_ sender: UIButton) {
        myTextField.endEditing(true)
    }
    
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
    
    
    
    
    
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
    }
}

