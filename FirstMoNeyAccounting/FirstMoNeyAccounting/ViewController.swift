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
    
    @IBOutlet weak var limithLabel: UILabel!
    @IBOutlet weak var howManyCanSpend: UILabel!
    @IBOutlet weak var spendByCheck: UILabel!
    @IBOutlet weak var allSpending: UILabel!
    
    
    var categoryName = ""
    var displayValue: Int = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        numberFromKeyboard.forEach {$0.layer.cornerRadius = 25}
        
        tableView.delegate = self
        tableView.dataSource =  self
        //MARK: - заполнение массива при загрузке
        
        spendingArray = realm.objects(Spending.self)
         leftLabels()//отображение суммы лимита
        allSpendingSettings()
  
        
    }
    //MARK: - кнопка алерт для установления лимита денег
    
    @IBAction func limitPressedButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Установить лимит", message: "Введите сумму и количество дней", preferredStyle: .alert)
        alert.addTextField { (field) in
            field.placeholder = "введите сумму"
            field.keyboardType = .asciiCapableNumberPad
        }
        
        alert.addTextField { (field) in
            field.placeholder = "введите количество дней"
            field.keyboardType = .asciiCapableNumberPad
        }
        
        let alertINSTALL = UIAlertAction(title:  "установить", style: .default) { action in
            let tfSum = alert.textFields?[0].text
           
            let tfDay = alert.textFields?[1].text
            guard tfDay != "" && tfSum != "" else {return}
            self.limithLabel.text = tfSum

            if let day = tfDay {
                let datenow = Date()
                let lastDay: Date = datenow.addingTimeInterval(60*60*24*Double(day)!)
                
               //MARK: - запись лимита в базу
                
                let value = Limit()
                value.limitSum = self.limithLabel.text!
                value.limitDate = datenow as NSDate
                value.limitLastDay = lastDay as NSDate
                
                let limit = self.realm.objects(Limit.self)//вссе лимиты базы
                if limit.isEmpty == true {
                    try! self.realm.write {
                    self.realm.add(value)
                    }
                }else{//если не пусто перезаписываем
                    try! self.realm.write {
                    limit[0].limitSum = self.self.limithLabel.text!
                    limit[0].limitDate = datenow as NSDate
                    limit[0].limitLastDay = lastDay as NSDate
                    }
                }
            }
            self.leftLabels()
        }
        let cancel = UIAlertAction(title: "выйти", style: .destructive, handler: nil)
        alert.addAction(alertINSTALL)
        alert.addAction(cancel)
        present(alert,animated: true,completion: nil)
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
        
        //MARK: - realm WRITE
        try! realm.write {
            realm.add(value)
            
        }
        self.leftLabels()
        self.allSpendingSettings()
        tableView.reloadData()
    }
    //MARK: - функция для назначения текста лейблам трат
    func leftLabels() {
        
        let limit = self.realm.objects(Limit.self)
        guard limit.isEmpty == false else {return}//проверка на наличие записи в базе данных
        limithLabel.text = limit[0].limitSum
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let firstday = limit[0].limitDate as Date
        let lastday = limit[0].limitLastDay as Date
        
        let firstComponents = calendar.dateComponents([.year,.month,.day], from: firstday)
        let lastComponents = calendar.dateComponents([.year,.month,.day], from: lastday)
        //MARK: - даты начала и конца
        let startdate = formatter.date(from: "\(firstComponents.year!)/\(firstComponents.month!)/\(firstComponents.day!) 00:00") as Any
        let endtdate = formatter.date(from: "\(lastComponents.year!)/\(lastComponents.month!)/\(lastComponents.day!) 23:59") as Any
        
        let filtredlimit: Int = realm.objects(Spending.self).filter("self.date >= %@ && self.date <= %@", startdate , endtdate  ).sum(ofProperty: "cost")
        //print("filteredlimit",filtredlimit)
        
         //MARK: - text for labels
        spendByCheck.text = "\(filtredlimit)"
        if let a = Int(limithLabel.text!) ,let b = Int(spendByCheck.text!) {
            let c = a - b
            howManyCanSpend.text = "\(c)"
    
        }
       
    }
    
    func allSpendingSettings() {
                //MARK: - все траты и лейбл
        let allSpend: Int = realm.objects(Spending.self).sum(ofProperty: "cost")
           allSpending.text = "\(allSpend)"
    }
 
 }
 


 extension ViewController: UITableViewDelegate,UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendingArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)  as! CustomCell

        let spending = spendingArray.sorted(byKeyPath: "date", ascending: false)[indexPath.row]
        cell.setupcell(item: spending)
        
       
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let edit = spendingArray.sorted(byKeyPath: "date", ascending: false)[indexPath.row]
            try! realm.write{
                realm.delete(edit)}
            //spendingArray.remove(at: indexPath.row)
        }
        self.leftLabels()
        self.allSpendingSettings()
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
        
    }
    
    
 }
