//
//  ViewController.swift
//  Calculatool
//
//  Created by Jarway on 16/10/17.
//  Copyright © 2016年 Jarway. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayPanel: UILabel!
    
    var userIsEditing = false;
    
    var brain = CalculatoolBrains()
    
    @IBAction func append(_ sender: UIButton) {
        if userIsEditing {
            displayPanel.text! = displayPanel.text! + sender.currentTitle!
        } else {
            userIsEditing = true;
            displayPanel.text! = sender.currentTitle!
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {
        if userIsEditing {
            enter()
        }
        if let operand = sender.currentTitle {
            if let result = brain.performOperation(symbol: operand) {
                displayDouble = result
            } else {
                displayDouble = 0
            }

        }
    }
    
    @IBAction func enter() {
        userIsEditing = false;
        if let result = brain.pushOperant(operant: displayDouble) {
            displayDouble = result
        } else {
            displayDouble = 0
        }
    }
    
    var displayDouble : Double {
        get {
            return NumberFormatter().number(from: displayPanel.text!)!.doubleValue
        }
        set {
            displayPanel.text! = "\(newValue)"
            userIsEditing = false;
        }
    }

}

