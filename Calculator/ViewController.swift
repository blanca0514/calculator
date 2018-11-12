//
//  ViewController.swift
//  Calculator
//
//  Created by Blanca Wang on 08/07/2017.
//  Copyright © 2017 Blanca Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var brain = CalculatorBrain()
    var isTypingDigit = false

    @IBOutlet weak var display: UILabel!

    var displayValue: Double{
        get {
            if display.text!.hasSuffix(".") {
                display.text!.append("0")  // fix the value's format for compute
            }
            return Double(display.text!)!
        }

        set {
            let newIntValue = Int(newValue)
            if Double(newIntValue) == newValue {
                display.text = String(newIntValue)
            } else {
                display.text = String(newValue)
            }
        }
    }

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isTypingDigit {
            display.text!.append(digit)
        } else {
            display.text = digit
            isTypingDigit = true
        }
    }

    @IBAction func touchDot(_ sender: UIButton) {
        if isTypingDigit == false || display!.text == nil {
            display.text = "0."
            isTypingDigit = true
        } else if !display.text!.contains("."){
            display.text!.append(".")
        }
    }

    @IBAction func performOperation(_ sender: UIButton) {
        if isTypingDigit {
            brain.setOperand(displayValue)
            isTypingDigit = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result{
            displayValue = result
        }
    }
}
