//
//  SecondViewController.swift
//  Phetch
//
//  Created by y2bd on 11/18/15.
//  Copyright (c) 2015 phetch. All rights reserved.
//

import UIKit

class WantTableViewController: UITableViewController {
    
    private var groceryItemToEdit : Grocery? = nil
    
    @IBAction func unwindFromAdd(sender: UIStoryboardSegue) {
        // shouldReload()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? AddWantItemViewController,
            let groc = groceryItemToEdit {
                dest.setTo(groc)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        shouldReload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Want"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Grocery.getWants().count
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryTableViewCell2", forIndexPath: indexPath)
        
        guard let gtvc = cell as? GroceryTableViewCell else {
            return cell
        }
        
        gtvc.setFrom(Grocery.getWants()[indexPath.row])
        return gtvc
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        groceryItemToEdit = Grocery.getWants()[indexPath.row]
        performSegueWithIdentifier("OpenAdd", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            confirmDeleteItem(Grocery.getWants()[indexPath.row], indexPath: indexPath)
        }
    }
    
    func confirmDeleteItem(grocery: Grocery, indexPath: NSIndexPath) {
        let alert = UIAlertController(
            title: "Removing \(grocery.name)",
            message: "Do you want to add \"\(grocery.name)\" to the Have list?",
            preferredStyle: .ActionSheet)
        
        let transferAction = UIAlertAction(title: "Transfer to Have", style: .Default, handler: {(aa) -> () in self.transferItem(aa, grocery: grocery, indexPath: indexPath)})
        let removeAction = UIAlertAction(title: "Just Remove", style: .Destructive, handler: {(aa) -> () in self.removeItem(aa, grocery: grocery, indexPath: indexPath)})
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(transferAction)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func transferItem(alertAction: UIAlertAction!, grocery: Grocery, indexPath: NSIndexPath) {
        Grocery.removeFromWants(grocery)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        Grocery.addHave(grocery)
    }
    
    func removeItem(alertAction: UIAlertAction!, grocery: Grocery, indexPath: NSIndexPath) {
        Grocery.removeFromWants(grocery)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func shouldReload() {
        self.tableView.reloadData()
    }
}
