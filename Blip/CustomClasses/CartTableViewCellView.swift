//
//  CartTableVIewCellView.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-09.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import GMStepper

class CartTableViewCellView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var stepper: GMStepper!
    var item: Item!
    var cart = Cart.shared
    var tableview:UITableView!
    var initial_value_when_loaded: Int!
    var superViewCartVC:CartVC!
    

    @IBAction func stepperChanged(_ sender: GMStepper){
        print("init val", initial_value_when_loaded)
        if Int(sender.value) < initial_value_when_loaded{ //Checking to see if stepper was decreased
            cart.decreaseItem(item: self.item)
            print("Decreased item quantity")
        }
        if Int(sender.value) > initial_value_when_loaded{ //Checking to see if stepper was increased
            cart.increaseItem(item: self.item)
            print("Increased item quantity")
        }

        let price = self.item.price!
        self.price.text = "$\(price * sender.value)"
        cart.items[self.item.productID]![self.item]! = Int(sender.value)
        self.initial_value_when_loaded = Int(sender.value)
        if superViewCartVC != nil{
            superViewCartVC.checkoutButtonLabel.text = "$\(cart.getTotalPrice())"
        }
        print(cart.items)
    }
    
    
    @IBAction func deleteItemPresssed(_ sender: UIButton){
        self.item.quantity = 0
        cart.items[self.item.productID] = nil
        //Deletes item with animation
        UIView.transition(with: self.tableview, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.tableview.reloadData()
        }, completion: nil)
    }


}
