 //
//  ViewController.swift
//  FirstMoNeyAccounting
//
//  Created by fedir on 27.05.2020.
//  Copyright © 2020 fedir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //переменная для контроля текста  0 или нет
    var stillTyping = false
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet var numberFromKeyboard: [UIButton]!
    
    var categoryName = ""
    var displayValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFromKeyboard.forEach {$0.layer.cornerRadius = 10}
        tableView.delegate = self
        tableView.dataSource =  self
    }
    
     
    
    @IBAction func numberPressed(_ sender: UIButton) {
        let number = sender.currentTitle!
        //проверка на 0 на дисплее
        if stillTyping {
            if displayLabel.text!.count < 12 {
                displayLabel.text! += number
            }
            
        }else{
            displayLabel.text = number
            stillTyping = true
        }
    }
    
    
    //удаление всей строки на дисплее
    @IBAction func resetButton(_ sender: UIButton) {
        displayLabel.text = "0"
        stillTyping = false
    }
  
    
    //удаление последнего символа
    @IBAction func removeLastButton(_ sender: Any) {
        if displayLabel.text != "0" {
            let txt = displayLabel.text!.dropLast()
            displayLabel.text = String(txt)
        }
    }
    
    @IBAction func categoryPressed(_ sender: UIButton) {
         
        categoryName = sender.currentTitle!
        displayValue = displayLabel.text!
        displayLabel.text = "0"
        stillTyping = false
        
        print(categoryName  , displayValue)
    }
    
    
    

}

 extension UIViewController: UITableViewDelegate,UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
        
    }
    
    
 }
