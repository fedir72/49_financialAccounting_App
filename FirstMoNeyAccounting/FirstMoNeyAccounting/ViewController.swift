 //
//  ViewController.swift
//  FirstMoNeyAccounting
//
//  Created by fedir on 27.05.2020.
//  Copyright © 2020 fedir. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    
    
    //MARK: - realm
    var realm = try! Realm()
    
     //MARK: - массив значений
    var spendingArray: Results<Spending>!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //переменная для контроля текста  0 или нет
    var stillTyping = false
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet var numberFromKeyboard: [UIButton]!
    
    var categoryName = ""
    var displayValue: Int = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFromKeyboard.forEach {$0.layer.cornerRadius = 25}
        
        tableView.delegate = self
        tableView.dataSource =  self
        //MARK: - заполнение массива при загрузке
        spendingArray = realm.objects(Spending.self)
    }
    
    @IBAction func deleteAllButton(_ sender: UIBarButtonItem) {
        
        try! realm.write {
            realm.deleteAll()
            tableView.reloadData()
            //spendingArray = []
            }
    }
    
    
    @IBAction func numberPressed(_ sender: UIButton) {
        
        let number = sender.currentTitle!
        if number == "0" && displayLabel.text == "0" {
           
            stillTyping = false
        }else{
            if stillTyping {
                if displayLabel.text!.count < 12 {
                    displayLabel.text! += number
                }
                
            }else{
                displayLabel.text = number
                stillTyping = true
            }
        }
        //проверка на 0 на дисплее
        
    }
    
    
    //удаление всей строки на дисплее
    @IBAction func resetButton(_ sender: UIButton) {
        displayLabel.text = "0"
        stillTyping = false
    }
  
    
    //удаление последнего символа
    @IBAction func removeLastButton(_ sender: Any) {
        if displayLabel.text != "0" {
            let text = String((displayLabel.text?.dropLast())!)
            displayLabel.text = text
        }
    }
    
    @IBAction func categoryPressed(_ sender: UIButton) {
         
        categoryName = sender.currentTitle!
        displayValue = Int(displayLabel.text!)!
        displayLabel.text = "0"
        stillTyping = false
        
        //MARK: - создание и сохранение модели
        
        let value = Spending()
        value.category = categoryName
        value.cost = Int(displayValue)
        
        //spendingArray.append(value)
        //print("value saved:",value)
        //print(categoryName  , displayValue)
        
        //MARK: - realm WRITE
        try! realm.write {
            realm.add(value)
        }
        tableView.reloadData()
    }
    
    
    

}

 extension ViewController: UITableViewDelegate,UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendingArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)  as! CustomCell

        let spending = spendingArray[indexPath.row]
        cell.setupcell(item: spending)
        
       
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let edit = spendingArray[indexPath.row]
            try! realm.write{
                realm.delete(edit)}
            //spendingArray.remove(at: indexPath.row)
        }
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
        
    }
    
    
 }
