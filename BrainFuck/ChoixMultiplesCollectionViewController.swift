//
//  ChoixMultiplesCollectionViewController.swift
//  BrainFuck
//
//  Created by Thomas Mac on 19/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ChoixMultiplesCollectionViewController: UICollectionViewController {

    private let itemsArray = NSMutableArray()
    
    internal var viewController = UIViewController()

    internal var ok = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.collectionView?.scrollEnabled = false
        
        self.ok = true
        
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
    
    internal func removeAllItems()
    {
        self.itemsArray.removeAllObjects()
        self.collectionView?.reloadData()
    }

    internal func addItems(item:NSObject)
    {
        self.itemsArray.addObject(item)
        self.collectionView?.reloadData()
    }
    
    internal func replaceItemAtIndex(indice:Int, item:NSObject)
    {
        self.itemsArray.replaceObjectAtIndex(indice, withObject:item)
        self.collectionView?.reloadData()
    }
    
    internal func getItem(indice:Int) -> NSString
    {
        return String(self.itemsArray.objectAtIndex(indice))
    }
    
    internal func getNumberOfItems() -> Int
    {
        return self.itemsArray.count
    }
    
    // MARK: UICollectionViewDataSource

    private func getCellWidth() -> CGFloat
    {
        return self.collectionView!.frame.size.width / 5
    }
    
    private func getCellHeigth() -> CGFloat
    {
        var size = self.collectionView!.frame.size.width / 5
        if (size > self.collectionView!.frame.size.height / CGFloat(self.itemsArray.count % 5))
        {
            size = self.collectionView!.frame.size.height / CGFloat(self.itemsArray.count % 5)
        }
        return size
    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        return CGSizeMake(self.getCellWidth(), self.getCellHeigth())
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.itemsArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        var size = cell.frame.size.width
        if (size > cell.frame.size.height)
        {
            size = cell.frame.size.height
        }
        (cell as! CollectionViewCellWithLabel).titleLabel.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:size/2)
        cell.backgroundColor = UIColor.blackColor()
        
        (cell as! CollectionViewCellWithLabel).titleLabel.text = String(self.itemsArray.objectAtIndex(indexPath.row))
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (!ok)
        {
            return
        }
        self.ok = false
        
        if (self.viewController.isKindOfClass(DiviseGameViewController))
        {
            (self.viewController as! DiviseGameViewController).answer(Int(self.itemsArray.objectAtIndex(indexPath.row) as! NSNumber))
        }
        else if (self.viewController.isKindOfClass(PremierGameViewController))
        {
            (self.viewController as! PremierGameViewController).answer(Int(self.itemsArray.objectAtIndex(indexPath.row) as! NSNumber))
        }
        else if (self.viewController.isKindOfClass(PGCDGameViewController))
        {
            (self.viewController as! PGCDGameViewController).answer(Int(self.itemsArray.objectAtIndex(indexPath.row) as! NSNumber))
        }
        else if (self.viewController.isKindOfClass(PPCMGameViewController))
        {
            (self.viewController as! PPCMGameViewController).answer(Int(self.itemsArray.objectAtIndex(indexPath.row) as! NSNumber))
        }
    }

}
