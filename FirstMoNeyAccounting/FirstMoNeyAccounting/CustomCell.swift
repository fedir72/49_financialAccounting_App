//
//  CustomCell.swift
//  FirstMoNeyAccounting
//
//  Created by fedir on 01.06.2020.
//  Copyright © 2020 fedir. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var recordImage: UIImageView!
    
    @IBOutlet weak var recordCategory: UILabel!
    
    @IBOutlet weak var recordCost: UILabel!
    func setupcell(item: Spending) {
         
        recordCategory.text = item.category
        recordCost.text = String(item.cost)
        
        switch item.category {
            
        case "Еда": recordImage.image = #imageLiteral(resourceName: "Category_Еда")
        case "Одежда": recordImage.image = #imageLiteral(resourceName: "Category_Одежда")
        case "Связь": recordImage.image = #imageLiteral(resourceName: "Category_Связь")
        case "Досуг": recordImage.image = #imageLiteral(resourceName: "dancing-party")
        case "Красота": recordImage.image = #imageLiteral(resourceName: "Category_Красота")
        case "Авто": recordImage.image = #imageLiteral(resourceName: "Category_Авто")
        
        default:  break
            
        }
    }
    
}
