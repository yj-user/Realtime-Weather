//
//  ViewController.swift
//  Realtime Weather
//
//  Created by youngjun kim on 2021/04/08.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var myTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func searchPressed(_ sender: UIButton) {
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
    }
}

