//
//  LesCouplesLevelCollectionViewController.swift
//  BrainFuck
//
//  Created by Thomas Mac on 18/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class LesCouplesLevelCollectionViewController: UICollectionViewController {

    private let sauvegarde = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Les couples"
        
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
        return (self.sauvegarde.integerForKey("LesCouplesNumberOfLevelCompleted") + 1)
    }
    
    internal func levelCompleted(level: Int)
    {
        if (level > self.sauvegarde.integerForKey("LesCouplesNumberOfLevelCompleted"))
        {
            self.sauvegarde.setInteger(level, forKey:"LesCouplesNumberOfLevelCompleted");
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
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let lesCouplesGameCollectionViewController = LesCouplesGameCollectionViewController(collectionViewLayout:layout)
        
        lesCouplesGameCollectionViewController.level = indexPath.row + 1
        lesCouplesGameCollectionViewController.lesCouplesLevelCollectionViewController = self
        
        self.navigationController?.pushViewController(lesCouplesGameCollectionViewController, animated:true)
    }

}
