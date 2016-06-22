//
//  AccueilTableViewController.swift
//  BrainFuck
//
//  Created by Thomas Mac on 16/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class AccueilTableViewController: UITableViewController {
    
    private let menuArray: NSArray = ["Calcul mental", "Les couples", "Trouver le diviseur", "Trouver le nombre premier", "Trouver le PGCD", "Trouver le PPCM", "Numbers the game", "What is the color ?"]
    
    private let imageArray: NSArray = [NSLocalizedString("ICON_CALCUL_MENTAL", comment:""), NSLocalizedString("ICON_CALCUL_MENTAL", comment:""), NSLocalizedString("ICON_CALCUL_MENTAL", comment:""), NSLocalizedString("ICON_CALCUL_MENTAL", comment:""), NSLocalizedString("ICON_CALCUL_MENTAL", comment:""), NSLocalizedString("ICON_CALCUL_MENTAL", comment:""), NSLocalizedString("ICON_CALCUL_MENTAL", comment:""), NSLocalizedString("ICON_CALCUL_MENTAL", comment:"")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.registerClass(TableViewCellWithImage.classForCoder(), forCellReuseIdentifier:"cell")
        
        self.title = "Brain Fuck : Menu Principal"
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let buttonPrevious = UIBarButtonItem(title:"Retour", style:UIBarButtonItemStyle.Done, target:nil, action:nil)
        buttonPrevious.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        self.navigationItem.backBarButtonItem = buttonPrevious
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated:true)
        
        super.viewDidAppear(animated)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.menuArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        cell.textLabel?.text = self.menuArray[indexPath.row] as? String
        
        cell.imageView?.image = UIImage(named:self.imageArray[indexPath.row] as! String)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        if (indexPath.row == 0)
        {
            let calculMentalLevelCollectionViewController = CalculMentalLevelCollectionViewController(collectionViewLayout:layout)
            
            self.navigationController?.pushViewController(calculMentalLevelCollectionViewController, animated:true)
        }
        else if (indexPath.row == 1)
        {
            let lesCouplesLevelCollectionViewController = LesCouplesLevelCollectionViewController(collectionViewLayout:layout)
            
            self.navigationController?.pushViewController(lesCouplesLevelCollectionViewController, animated:true)
        }
        else if (indexPath.row == 2)
        {
            let diviseLevelCollectionViewController = DiviseLevelCollectionViewController(collectionViewLayout:layout)
            
            self.navigationController?.pushViewController(diviseLevelCollectionViewController, animated:true)
        }
        else if (indexPath.row == 3)
        {
            let premierLevelCollectionViewController = PremierLevelCollectionViewController(collectionViewLayout:layout)
            
            self.navigationController?.pushViewController(premierLevelCollectionViewController, animated:true)
        }
        else if (indexPath.row == 4)
        {
            let pgcdLevelCollectionViewController = PGCDLevelCollectionViewController(collectionViewLayout:layout)
            
            self.navigationController?.pushViewController(pgcdLevelCollectionViewController, animated:true)
        }
        else if (indexPath.row == 5)
        {
            let ppcmLevelCollectionViewController = PPCMLevelCollectionViewController(collectionViewLayout:layout)
            
            self.navigationController?.pushViewController(ppcmLevelCollectionViewController, animated:true)
        }
        else if (indexPath.row == 6)
        {
            let numbersScoresTableViewController = NumbersScoresTableViewController(style:.Plain)
            
            self.navigationController?.pushViewController(numbersScoresTableViewController, animated:true)
        }
        else if (indexPath.row == 7)
        {
            let colorScoresTableViewController = ColorScoresTableViewController(style:.Plain)
            
            self.navigationController?.pushViewController(colorScoresTableViewController, animated:true)
        }
    }
    
}
