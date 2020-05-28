//
//  ViewController.swift
//  FirstMoNeyAccounting
//
//  Created by fedir on 27.05.2020.
//  Copyright © 2020 fedir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var numberFromKeyboard: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFromKeyboard.forEach {$0.layer.cornerRadius = 10}
    }


}

