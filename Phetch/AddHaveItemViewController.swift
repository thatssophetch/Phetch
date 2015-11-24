//
//  AddHaveItemViewController.swift
//  Phetch
//
//  Created by y2bd on 11/24/15.
//  Copyright © 2015 phetch. All rights reserved.
//

import UIKit

class AddHaveItemViewController: UIViewController {

    private var currentGrocery : Grocery?
    
    @IBOutlet weak var quantityField: UITextField!
    
    @IBOutlet weak var itemField: UITextField!
    
    @IBOutlet weak var priceField: UITextField!
    
    @IBAction func tappedAdd(sender: UIButton) {
        let name = itemField.text
        if name == nil || name!.isEmpty {
            alert("Error", message: "Please enter a name for the grocery item.")
            return
        }
        
        guard let quantityText = quantityField.text else {
            alert("Error", message: "Please enter a quantity.")
            return
        }
        
        let quantity = Int(quantityText)
        if quantity == nil || quantity! <= 0 {
            alert("Error", message: "Quantity must be positive.")
            return
        }
        
        if let cg = currentGrocery {
            cg.name = name!
            cg.count = quantity!
            
            currentGrocery = nil
        } else {
            Grocery.addHave(Grocery(name: name!, count: quantity!))
        }
        
        performSegueWithIdentifier("unwindFromAdd", sender: self)
    }
    
    @IBAction func tappedCancel(sender: UIButton) {
        performSegueWithIdentifier("unwindFromAdd", sender: self)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currGroc = currentGrocery {
            quantityField.text = String(currGroc.count)
            itemField.text = currGroc.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func setTo(item:Grocery) {
        currentGrocery = item
    }
    
    private func alert(title: String, message: String) {
        let myAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
}
