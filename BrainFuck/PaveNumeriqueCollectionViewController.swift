//
//  PaveNumeriqueCollectionViewController.swift
//  BrainFuck
//
//  Created by Thomas Mac on 16/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PaveNumeriqueCollectionViewController: UICollectionViewController {
    
    internal var reponseLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.collectionView?.scrollEnabled = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(CollectionViewCellWithLabel.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellWithOutLabel")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    private func getCellWidth() -> CGFloat
    {
        return self.collectionView!.frame.size.width / 3
    }
    
    private func getCellHeigth() -> CGFloat
    {
        return self.collectionView!.frame.size.height / 4
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
        return 12
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (indexPath.row == 9)
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellWithOutLabel", forIndexPath: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        var size = cell.frame.size.width
        if (size > cell.frame.size.height)
        {
            size = cell.frame.size.height
        }
        (cell as! CollectionViewCellWithLabel).titleLabel.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:size/2)
        cell.backgroundColor = UIColor.blackColor()
        if (indexPath.row == 10)
        {
            (cell as! CollectionViewCellWithLabel).titleLabel.text = "0"
        }
        else if (indexPath.row == 11)
        {
            (cell as! CollectionViewCellWithLabel).titleLabel.text = "-"
        }
        else
        {
            (cell as! CollectionViewCellWithLabel).titleLabel.text = String(indexPath.row + 1)
        }
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 10)
        {
            self.reponseLabel.text = self.reponseLabel.text! + "0"
        }
        else if (indexPath.row == 11)
        {
            self.reponseLabel.text = self.reponseLabel.text! + "-"
        }
        else
        {
            self.reponseLabel.text = self.reponseLabel.text! + String(indexPath.row + 1)
        }
    }
    
}
