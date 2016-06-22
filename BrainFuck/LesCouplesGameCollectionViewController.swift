//
//  LesCouplesGameCollectionViewController.swift
//  BrainFuck
//
//  Created by Thomas Mac on 18/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class LesCouplesGameCollectionViewController: UICollectionViewController {

    internal var level = 0
    
    internal var lesCouplesLevelCollectionViewController = LesCouplesLevelCollectionViewController()
    
    private var timerWait = NSTimer()
    
    private var timerTempsEcoule = NSTimer()
    
    private var tempsEcoule = 0
    
    private var indice = -1
    private var secondIndice = -1
    
    private var discovered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Trouver les couples"
        
        self.navigationItem.hidesBackButton = true
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.collectionView?.scrollEnabled = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(CollectionViewCellWithLabel.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.timerTempsEcoule = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:#selector(self.time), userInfo:nil, repeats:true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getNumberOfItems() -> Int
    {
        if (self.level > 5)
        {
            return 50
        }
        return self.level * 10
    }
    
    private func setCellValue(cell: CollectionViewCellWithLabel, collectionView: UICollectionView)
    {
        var value = arc4random_uniform(UInt32(self.getNumberOfItems()) / 2) + 1
        while (self.cellValueAllreadyPresent(Int(value), collectionView:collectionView))
        {
            value = arc4random_uniform(UInt32(self.getNumberOfItems()) / 2) + 1
        }
        cell.titleLabel.text = String(value)
    }
    
    private func cellValueAllreadyPresent(value: Int, collectionView:UICollectionView) -> Bool
    {
        var compteur = 0
        var i = 0
        while (i < collectionView.numberOfItemsInSection(0))
        {
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0))
            if (cell != nil && (cell as! CollectionViewCellWithLabel).titleLabel.text == String(value))
            {
                compteur += 1
                if (compteur == 2)
                {
                    return true
                }
            }
            i += 1
        }
        return false
    }
    
    private func allCellDiscovered() -> Bool
    {
        var i = 0
        while (i < self.getNumberOfItems())
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0))
            if ((cell as! CollectionViewCellWithLabel).titleLabel.hidden)
            {
                return false
            }
            i += 1
        }
        return true
    }
    
    private func getObjectifTemps() -> Double
    {
        return Double(self.getNumberOfItems()) * 2.0 * (5.0 - Double(self.level) * 0.1)
    }
    
    @objc private func time()
    {
        self.tempsEcoule += 1
    }
    
    @objc private func wait()
    {
        self.timerWait.invalidate()
        
        let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:self.indice, inSection:0))
        (cell as! CollectionViewCellWithLabel).titleLabel.hidden = true
        let secondCell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:self.secondIndice, inSection:0))
        (secondCell as! CollectionViewCellWithLabel).titleLabel.hidden = true
        
        self.indice = -1
        self.secondIndice = -1
        self.discovered = false
    }
    
    // MARK: UICollectionViewDataSource

    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        var size = (self.view.frame.size.width * (self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - 90.0)) / CGFloat(self.getNumberOfItems())
        size = sqrt(size)
        return CGSizeMake(size, size)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.getNumberOfItems()
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
        
        self.setCellValue((cell as! CollectionViewCellWithLabel), collectionView:collectionView)
        
        (cell as! CollectionViewCellWithLabel).titleLabel.hidden = true
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if (self.discovered || !(cell as! CollectionViewCellWithLabel).titleLabel.hidden)
        {
            return
        }
        (cell as! CollectionViewCellWithLabel).titleLabel.hidden = false
        if (indice != -1)
        {
            self.discovered = true
            let secondCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow:self.indice, inSection:0))
            if ((cell as! CollectionViewCellWithLabel).titleLabel.text == (secondCell as! CollectionViewCellWithLabel).titleLabel.text)
            {
                cell?.backgroundColor = UIColor.whiteColor()
                (cell as! CollectionViewCellWithLabel).titleLabel.textColor = UIColor.blackColor()
                secondCell?.backgroundColor = UIColor.whiteColor()
                (secondCell as! CollectionViewCellWithLabel).titleLabel.textColor = UIColor.blackColor()
                if (self.allCellDiscovered())
                {
                    self.timerTempsEcoule.invalidate()
                    var title = "Défaite"
                    var message = "Vous avez fini le niveau N°" + String(self.level) + " en " + String(self.tempsEcoule) + " secondes contre une limite de temps de " + String(self.getObjectifTemps()) + " secondes."
                    if (Double(self.tempsEcoule) <= self.getObjectifTemps())
                    {
                        title = "Level Completed"
                        message = "Félicitation, vous avez fini le niveau N°" + String(self.level) + " en " + String(self.tempsEcoule) + " secondes."
                        self.lesCouplesLevelCollectionViewController.levelCompleted(self.level)
                    }
                    let alertController = UIAlertController(title:title, message:message, preferredStyle:.Alert)
                    let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in self.navigationController?.popViewControllerAnimated(true) }
                    alertController.addAction(alertAction)
                    
                    presentViewController(alertController, animated:true, completion:nil)
                }
                self.indice = -1
                self.discovered = false
            }
            else
            {
                self.secondIndice = indexPath.row
                self.timerWait = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:#selector(self.wait), userInfo:nil, repeats:true)
            }
        }
        else
        {
            self.indice = indexPath.row
        }
    }

}
