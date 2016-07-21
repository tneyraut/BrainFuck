//
//  ScoreTableViewController.swift
//  LePendu
//
//  Created by Thomas Mac on 17/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class ScoreTableViewController: UITableViewController {

    internal var sauvegarde = NSUserDefaults()
    
    internal var identifier = ""
    
    internal var theTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.theTitle
        
        self.tableView.registerClass(TableViewCellWithImage.classForCoder(), forCellReuseIdentifier:"cell")
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier:"cell1")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getNumberOfItems() -> Int
    {
        return self.sauvegarde.integerForKey("numberOfScoresFor" + self.identifier)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (self.getNumberOfItems() == 0)
        {
            return 1
        }
        return self.getNumberOfItems()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.getNumberOfItems() == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
            
            cell.textLabel?.text = "Aucun score enregistré"
            
            cell.textLabel?.textAlignment = .Center
            
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.selectionStyle = .None
        
        cell.imageView?.image = UIImage(named:NSLocalizedString("ICON_SCORE", comment:""))
        
        cell.textLabel?.text = "Score N°" + String(indexPath.row + 1) + " : " + String(self.sauvegarde.integerForKey("scoreN°" + String(indexPath.row) + self.identifier))
        
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.lineBreakMode = .ByWordWrapping

        return cell
    }

}
