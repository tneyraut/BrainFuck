//
//  PGCDLevelCollectionViewController.swift
//  BrainFuck
//
//  Created by Thomas Mac on 18/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PGCDLevelCollectionViewController: UICollectionViewController {

    private let sauvegarde = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Trouver le PGCD"
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
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

    private func getNumberOfItems() -> Int
    {
        return (self.sauvegarde.integerForKey("PGCDNumberOfLevelCompleted") + 1)
    }
    
    internal func levelCompleted(level: Int)
    {
        if (level > self.sauvegarde.integerForKey("PGCDNumberOfLevelCompleted"))
        {
            self.sauvegarde.setInteger(level, forKey:"PGCDNumberOfLevelCompleted");
            self.collectionView?.reloadData()
        }
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
        let pgcdGameViewController = PGCDGameViewController()
        
        pgcdGameViewController.level = indexPath.row + 1
        pgcdGameViewController.pgcdLevelCollectionViewController = self
        
        self.navigationController?.pushViewController(pgcdGameViewController, animated:true)
    }

}
