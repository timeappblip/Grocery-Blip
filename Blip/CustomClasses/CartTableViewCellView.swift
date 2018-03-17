//
//  CartTableVIewCellView.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-09.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit

class CartTableViewCellView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantityLabel:UILabel!
    var item: Item!
    var cart = Cart.shared
    var tableview:UITableView!
    @IBOutlet weak var stepper:UIStepper!
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        var quantity_num = Double(self.quantityLabel.text!)!
        if sender.value < quantity_num{ //Checking to see if stepper was decreased
            cart.decreaseItem(item: self.item)
        }
        if sender.value > quantity_num{
            cart.increaseItem(item: self.item)
        }
        self.quantityLabel.text = "\(Int(sender.value))"
        quantity_num = Double(self.quantityLabel.text!)!
        let price = self.item.price!
        self.price.text = "$\(price * quantity_num)"
        cart.items[self.item.productID]![self.item]! = Int(quantity_num)
    }
    
    @IBAction func deleteItemPresssed(_ sender: UIButton){
        self.item.quantity = 0
        cart.items[self.item.productID] = nil
        UIView.transition(with: self.tableview, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.tableview.reloadData()
        }, completion: nil)
//        self.tableview.reloadData()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
