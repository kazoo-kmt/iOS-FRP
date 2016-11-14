//
//  ViewController.swift
//  RxCalculator
//
//  Created by Nikolas Burk on 09/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
  @IBOutlet weak var firstValueTextField: UITextField!
  @IBOutlet weak var secondValueTextField: UITextField!
  @IBOutlet weak var operationLabel: UILabel!
  @IBOutlet weak var resultLabel: UILabel!
  
  let calculator = Calculator()
  let disposeBag = DisposeBag()

  // MARK: View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let operationObservable: Observable<Calculator.Operation> = operationSegmentedControl.rx.value.map { value in
      return Calculator.Operation(rawValue: value)!
    }
    
    operationObservable.map { operation in
      return self.calculator.sign(for: operation)
    }.bindTo(operationLabel.rx.text)
    .addDisposableTo(disposeBag)
    
    let firstValueObservable: Observable<Int> = firstValueTextField.rx.text.map { (text: String?) in
      return Int(text!)!
    }
    
    let secondValueObservable: Observable<Int> = secondValueTextField.rx.text.map { text in
      return Int(text!)!
    }
    
    let resultValueObservable: Observable<Int> = Observable.combineLatest(operationObservable, firstValueObservable, secondValueObservable) { operation, firstValue, secondValue -> Int in
      switch operation {
      case .addition: return self.calculator.add(a: firstValue, b: secondValue)
      case .subtraction: return self.calculator.subtract(a: firstValue, b: secondValue)
      }
    }
    
    resultValueObservable.map { result in
      return String(result)
    }.bindTo(resultLabel.rx.text)
    .addDisposableTo(disposeBag)
    
  }
}
