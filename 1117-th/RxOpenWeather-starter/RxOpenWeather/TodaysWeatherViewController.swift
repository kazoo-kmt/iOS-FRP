//
//  TodaysWeatherViewController.swift
//  RxOpenWeather
//
//  Created by Nikolas Burk on 17/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TodaysWeatherViewController: UIViewController {
  
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var forecastButton: UIButton!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var minTemperatureLabel: UILabel!
  @IBOutlet weak var maxTemperatureLabel: UILabel!
  @IBOutlet weak var avgTemperatureLabel: UILabel!
  
  let openWeatherAPI = RxOpenWeatherMapAPI()
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func setupObservers() {
    
    let maybeWeatherObservable: Observable<Weather?> = cityTextField.rx.text.asObservable()
      .throttle(0.75, scheduler: MainScheduler.instance)
      .flatMapLatest { (searchText: String?) -> Observable<Weather?> in
        return self.openWeatherAPI.createWeatherObservable(for: searchText!)
    }
    
    maybeWeatherObservable.map { (weather: Weather?) in
      if let weather = weather {
        return weather.description
      }
      return "-"
    }.bindTo(descriptionLabel.rx.text)
    .addDisposableTo(disposeBag)
    
    maybeWeatherObservable.map { (weather: Weather?) in
      return weather != nil
    }.bindTo(forecastButton.rx.isEnabled)
    .addDisposableTo(disposeBag)
    
    
  }

  
}

