//
//  NumbersGameCollectionViewController.swift
//  BrainFuck
//
//  Created by Thomas Mac on 19/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NumbersGameCollectionViewController: UICollectionViewController {
    
    private var score = 0
    
    private var indice = -1
    
    internal var numbersScoresTableViewController = NumbersScoresTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.score = 0
        
        self.indice = -1
        
        self.title = "Score : 0"
        
        self.navigationItem.hidesBackButton = true
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.collectionView?.scrollEnabled = false
        
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
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated:true)
        
        self.setCellValue()
        
        super.viewDidAppear(animated)
    }
    
    private func setCellValue()
    {
        var i = 0
        while (i < self.collectionView?.numberOfItemsInSection(0))
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0))
            
            (cell as! CollectionViewCellWithLabel).titleLabel.text = String(self.getRandomNumber())
            
            i += 1
        }
        if (!self.movePossible())
        {
            self.setCellValue()
        }
    }
    
    private func getNumberOfCellWithTitle() -> Int
    {
        var resultat = 0
        var i = 0
        var indice = -1
        while (i < self.collectionView?.numberOfItemsInSection(0))
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! CollectionViewCellWithLabel
            if (cell.titleLabel.text != "")
            {
                indice = i
                resultat += 1
            }
            i += 1
        }
        if (resultat == 1)
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:indice, inSection:0)) as! CollectionViewCellWithLabel
            self.score += Int(cell.titleLabel.text!)!
        }
        return resultat
    }
    
    private func end()
    {
        let test = self.movePossible()
        print("BEGIN : " + String(test))
        if (self.getNumberOfCellWithTitle() == 1 || !test)
        {
            print("TEST1")
            let alertController = UIAlertController(title:"Fin de la partie", message:"La partie est finie, vous avez marqué " + String(self.score) + " points.", preferredStyle:.Alert)
            print("TEST2")
            let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in self.navigationController?.popViewControllerAnimated(true) }
            print("TEST3")
            alertController.addAction(alertAction)
            print("TEST4")
            self.numbersScoresTableViewController.gameFinish(self.score)
            print("TEST5")
            presentViewController(alertController, animated:true, completion:nil)
            print("TEST6")
        }
        print("END")
    }
    
    private func movePossible() -> Bool
    {
        var i = 0
        while (i < self.collectionView?.numberOfItemsInSection(0))
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! CollectionViewCellWithLabel
            if (cell.titleLabel.text != "")
            {
                if (i % self.getNumberColonnes() != 0)
                {
                    let cellGauche = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i - 1, inSection:0)) as! CollectionViewCellWithLabel
                    if (cellGauche.titleLabel.text == cell.titleLabel.text)
                    {
                        return true
                    }
                }
                if (i + 1 % self.getNumberColonnes() != 0)
                {
                    let cellDroite = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i + 1, inSection:0)) as! CollectionViewCellWithLabel
                    if (cellDroite.titleLabel.text == cell.titleLabel.text)
                    {
                        return true
                    }
                }
                if (i > self.getNumberColonnes())
                {
                    let cellHaut = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i - self.getNumberColonnes(), inSection:0)) as! CollectionViewCellWithLabel
                    if (cellHaut.titleLabel.text == cell.titleLabel.text)
                    {
                        return true
                    }
                }
                if (i < self.getNombreLignes() * self.getNumberColonnes() - self.getNumberColonnes())
                {
                    let cellBas = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i + self.getNumberColonnes(), inSection:0)) as! CollectionViewCellWithLabel
                    if (cellBas.titleLabel.text == cell.titleLabel.text)
                    {
                        return true
                    }
                }
            }
            i += 1
        }
        return false
    }
    
    private func setMove(cellOne: CollectionViewCellWithLabel, cellTwo: CollectionViewCellWithLabel)
    {
        cellTwo.titleLabel.text = String(Int(cellOne.titleLabel.text!)! + Int(cellTwo.titleLabel.text!)!)
        cellOne.titleLabel.text = ""
        cellTwo.backgroundColor = UIColor.blackColor()
        cellTwo.titleLabel.textColor = UIColor.whiteColor()
        self.score += Int(cellTwo.titleLabel.text!)!
        
        var i = (self.collectionView?.numberOfItemsInSection(0))! - 1
        while (i > self.getNumberColonnes() - 1)
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem:i, inSection:0)) as! CollectionViewCellWithLabel
            if (cell.titleLabel.text == "")
            {
                let otherCell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem:i - self.getNumberColonnes(), inSection:0)) as! CollectionViewCellWithLabel
                
                cell.backgroundColor = UIColor.blackColor()
                cell.titleLabel.textColor = UIColor.whiteColor()
                cell.titleLabel.text = otherCell.titleLabel.text
                
                otherCell.backgroundColor = UIColor.whiteColor()
                otherCell.titleLabel.textColor = UIColor.blackColor()
                otherCell.titleLabel.text = ""
            }
            i -= 1
        }
        print("OK")
    }
    
    private func resetColorCell(cellOne: CollectionViewCellWithLabel, cellTwo: CollectionViewCellWithLabel)
    {
        cellOne.backgroundColor = UIColor.blackColor()
        cellOne.titleLabel.textColor = UIColor.whiteColor()
        cellTwo.backgroundColor = UIColor.blackColor()
        cellTwo.titleLabel.textColor = UIColor.whiteColor()
    }
    
    private func getRandomNumber() -> Int
    {
        return Int(arc4random_uniform(8)) + 1
    }

    private func getNombreLignes() -> Int
    {
        return 7
    }
    
    private func getNumberColonnes() -> Int
    {
        return 5
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 30
    }

    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        return CGSizeMake(self.view.frame.size.width / CGFloat(self.getNumberColonnes()), (self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)!) / CGFloat(self.getNombreLignes()))
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        cell.backgroundColor = UIColor.blackColor()
        
        var size = cell.frame.size.width
        if (size > cell.frame.size.height)
        {
            size = cell.frame.size.height
        }
        (cell as! CollectionViewCellWithLabel).titleLabel.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:size/3)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCellWithLabel
        if (cell.titleLabel.text == "")
        {
            return
        }
        cell.titleLabel.tintColor = UIColor.blackColor()
        cell.backgroundColor = UIColor.whiteColor()
        if (self.indice != -1)
        {
            let cellOne = (collectionView.cellForItemAtIndexPath(NSIndexPath(forRow:self.indice, inSection:0)) as! CollectionViewCellWithLabel)
            if (self.indice % self.getNumberColonnes() == 0)
            {
                if ((indexPath.row == self.indice + 1 || indexPath.row == self.indice - 5 || indexPath.row == self.indice + 5) && cell.titleLabel.text == cellOne.titleLabel.text)
                {
                    self.setMove(cellOne, cellTwo:cell)
                }
                else
                {
                    self.resetColorCell(cellOne, cellTwo:cell)
                }
            }
            else if ((self.indice + 1) % self.getNumberColonnes() == 0)
            {
                if ((indexPath.row == self.indice + self.getNumberColonnes() || indexPath.row == self.indice - self.getNumberColonnes() || indexPath.row == self.indice - 1) && cell.titleLabel.text == cellOne.titleLabel.text)
                {
                    self.setMove(cellOne, cellTwo:cell)
                }
                else
                {
                    self.resetColorCell(cellOne, cellTwo:cell)
                }
            }
            else if ((indexPath.row == self.indice + 1 || indexPath.row == self.indice - self.getNumberColonnes() || indexPath.row == self.indice + self.getNumberColonnes() || indexPath.row == self.indice - 1) && cell.titleLabel.text == cellOne.titleLabel.text)
            {
                self.setMove(cellOne, cellTwo:cell)
            }
            else
            {
                self.resetColorCell(cellOne, cellTwo:cell)
            }
            self.indice = -1
            self.end()
        }
        else
        {
            self.indice = indexPath.row
        }
    }

}
