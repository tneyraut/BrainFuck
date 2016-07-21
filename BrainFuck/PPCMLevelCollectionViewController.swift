//
//  PPCMLevelCollectionViewController.swift
//  BrainFuck
//
//  Created by Thomas Mac on 18/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PPCMLevelCollectionViewController: UICollectionViewController {

    private let sauvegarde = NSUserDefaults()
    
    private var endlessMod = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Le PPCM"
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let buttonEndlessMod = UIBarButtonItem(title:"Endless", style:UIBarButtonItemStyle.Done, target:self, action:#selector(self.buttonEndlessModActionListener))
        buttonEndlessMod.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        self.navigationItem.rightBarButtonItem = buttonEndlessMod
        
        let buttonPrevious = UIBarButtonItem(title:"Retour", style:UIBarButtonItemStyle.Done, target:nil, action:nil)
        buttonPrevious.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        self.navigationItem.backBarButtonItem = buttonPrevious
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(CollectionViewCellWithLabel.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func buttonEndlessModActionListener()
    {
        self.endlessMod = !self.endlessMod
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        self.navigationItem.rightBarButtonItem!.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        if (self.endlessMod)
        {
            self.navigationItem.rightBarButtonItem!.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.greenColor(), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        }
    }

    private func getNumberOfItems() -> Int
    {
        return (self.sauvegarde.integerForKey("PPCMNumberOfLevelCompleted") + 1)
    }
    
    internal func levelCompleted(level: Int)
    {
        if (level > self.sauvegarde.integerForKey("PPCMNumberOfLevelCompleted"))
        {
            self.sauvegarde.setInteger(level, forKey:"PPCMNumberOfLevelCompleted");
            self.collectionView?.reloadData()
        }
    }
    
    internal func saveScore(score: Int, identifier: String)
    {
        if (score == 0)
        {
            return
        }
        if (self.sauvegarde.integerForKey("numberOfScoresFor" + identifier) < 10)
        {
            self.sauvegarde.setInteger(self.sauvegarde.integerForKey("numberOfScoresFor" + identifier) + 1, forKey:"numberOfScoresFor" + identifier)
        }
        if (self.sauvegarde.integerForKey("numberOfScoresFor" + identifier) == 1)
        {
            self.sauvegarde.setInteger(score, forKey:"scoreN°0" + identifier)
        }
        else
        {
            var i = 0
            while (i < self.getNumberOfItems())
            {
                if (self.sauvegarde.integerForKey("scoreN°" + String(i) + identifier) < score)
                {
                    self.sauvegarde.setInteger(self.sauvegarde.integerForKey("scoreN°" + String(self.getNumberOfItems() - 2) + identifier), forKey:"scoreN°" + String(self.getNumberOfItems() - 1) + identifier)
                    var j = self.getNumberOfItems() - 2
                    while (j > i)
                    {
                        self.sauvegarde.setInteger(self.sauvegarde.integerForKey("scoreN°" + String(j - 1) + identifier), forKey:"scoreN°" + String(j) + identifier)
                        j -= 1
                    }
                    self.sauvegarde.setInteger(score, forKey:"scoreN°" + String(i) + identifier)
                    break
                }
                i += 1
            }
        }
        self.sauvegarde.synchronize()
    }
    
    private func goToGameViewWithLevel(level: Int)
    {
        let ppcmGameViewController = PPCMGameViewController()
        
        ppcmGameViewController.level = level
        ppcmGameViewController.ppcmLevelCollectionViewController = self
        ppcmGameViewController.endlessMod = self.endlessMod
        
        self.navigationController?.pushViewController(ppcmGameViewController, animated:true)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.getNumberOfItems()
    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        return CGSizeMake(self.view.frame.size.width / 4, self.view.frame.size.width / 4)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.blackColor()
        
        var size = cell.frame.size.width
        if (size > cell.frame.size.height)
        {
            size = cell.frame.size.height
        }
        (cell as! CollectionViewCellWithLabel).titleLabel.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:size/4)
        
        (cell as! CollectionViewCellWithLabel).titleLabel.text = "Level " + String(indexPath.row + 1)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (self.endlessMod)
        {
            let alertController = UIAlertController(title:"Level" + String(indexPath.row + 1), message:"Sélectionnez l'action souhaitée", preferredStyle:.ActionSheet)
            
            let alertActionPlay = UIAlertAction(title:"Play", style:.Default) { (_) in
                self.goToGameViewWithLevel(indexPath.row + 1)
            }
            
            let alertActionScore = UIAlertAction(title:"Scores", style:.Default) { (_) in
                let scoreTableViewController = ScoreTableViewController(style:.Plain)
                
                scoreTableViewController.sauvegarde = self.sauvegarde
                
                scoreTableViewController.identifier = "PPCMLevelN°" + String(indexPath.row + 1)
                
                scoreTableViewController.theTitle = "PPCM : Scores"
                
                self.navigationController?.pushViewController(scoreTableViewController, animated:true)
            }
            
            let alertActionCancel = UIAlertAction(title:"Cancel", style:.Destructive) { (_) in }
            
            alertController.addAction(alertActionPlay)
            alertController.addAction(alertActionScore)
            alertController.addAction(alertActionCancel)
            
            self.presentViewController(alertController, animated:true, completion:nil)
            
            return
        }
        self.goToGameViewWithLevel(indexPath.row + 1)
    }

}
