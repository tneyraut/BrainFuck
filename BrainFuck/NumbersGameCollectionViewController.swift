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
    
    // ajouter un mode de retour de coup
    // ajouter des bonus
    
    private var score = 0
    
    private var indice = -1
    
    internal var numbersScoresTableViewController = NumbersScoresTableViewController()
    
    private var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.score = 0
        
        self.indice = -1
        
        self.title = "Score : 0"
        
        self.navigationItem.hidesBackButton = true
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.collectionView?.scrollEnabled = false
        
        self.activityIndicatorView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)
        self.activityIndicatorView.color = UIColor.whiteColor()
        self.activityIndicatorView.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicatorView)
        self.collectionView?.addSubview(self.activityIndicatorView)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(CollectionViewCellWithLabel.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.navigationController?.setToolbarHidden(true, animated:true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setCellValue()
        
        super.viewDidAppear(animated)
    }
    
    private func setCellValue()
    {
        self.activityIndicatorView.startAnimating()
        var i = 0
        while (i < self.collectionView?.numberOfItemsInSection(0))
        {
            (self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! CollectionViewCellWithLabel).titleLabel.text = ""
            i += 1
        }
        
        i = Int(arc4random_uniform(UInt32(self.getNumberColonnes())))
        var cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i + self.getNumberColonnes() * self.getNombreLignes() - self.getNumberColonnes(), inSection:0)) as! CollectionViewCellWithLabel
        
        let min = 7 * self.getNombreLignes() * self.getNumberColonnes()
        let max = 9 * self.getNombreLignes() * self.getNumberColonnes()
        let value = Int(arc4random_uniform(UInt32(max - min))) + min
        
        cell.titleLabel.text = String(value)
        
        while (self.getNumberOfCellWithTitle() != self.collectionView?.numberOfItemsInSection(0))
        {
            cell = self.getCellMaxDuplicable()
            if (cell.titleLabel.text == "1")
            {
                self.setCellValue()
                return
            }
            let neighbourCell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:self.getCellNeighbourIndiceWithoutTitle((self.collectionView?.indexPathForCell(cell)?.row)!), inSection:0)) as! CollectionViewCellWithLabel
            var newCellValue = ""
            var newNeighbourCellValue = ""
            if (Int(cell.titleLabel.text!)! % 2 == 0)
            {
                newCellValue = String(Int(cell.titleLabel.text!)! / 2)
                newNeighbourCellValue = String(Int(cell.titleLabel.text!)! / 2)
            }
            else
            {
                if (arc4random_uniform(2) == 0)
                {
                    newCellValue = String((Int(cell.titleLabel.text!)! + 1) / 2)
                    newNeighbourCellValue = String((Int(cell.titleLabel.text!)! - 1) / 2)
                }
                else
                {
                    newCellValue = String((Int(cell.titleLabel.text!)! - 1) / 2)
                    newNeighbourCellValue = String((Int(cell.titleLabel.text!)! + 1) / 2)
                }
            }
            neighbourCell.titleLabel.text = newNeighbourCellValue
            cell.titleLabel.text = newCellValue
        }
        self.activityIndicatorView.stopAnimating()
    }
    
    private func getCellMaxDuplicable() -> CollectionViewCellWithLabel
    {
        let array = self.getAllCellDuplicable()
        var cell = array[0] as! CollectionViewCellWithLabel
        var i = 1
        while (i < array.count)
        {
            let otherCell = array[i] as! CollectionViewCellWithLabel
            if (Int(otherCell.titleLabel.text!)! > Int(cell.titleLabel.text!)!)
            {
                cell = otherCell
            }
            i += 1
        }
        return cell
    }
    
    private func getAllCellDuplicable() -> NSArray
    {
        let array = NSMutableArray()
        var i = 0
        while (i < self.collectionView?.numberOfItemsInSection(0))
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! CollectionViewCellWithLabel
            if (cell.titleLabel.text != "" && self.getCellNeighbourIndiceWithoutTitle(i) != -1)
            {
                array.addObject(cell)
            }
            i += 1
        }
        return array
    }
    
    private func getCellNeighbourIndiceWithoutTitle(indice: Int) -> Int
    {
        var indiceCellGauche = -1
        var indiceCellDroite = -1
        var indiceCellHaut = -1
        var indiceCellBas = -1
        
        if (indice % self.getNumberColonnes() != 0)
        {
            indiceCellGauche = indice - 1
        }
        if (indice + 1 % self.getNumberColonnes() != 0)
        {
            indiceCellDroite = indice + 1
        }
        if (indice > self.getNumberColonnes())
        {
            indiceCellHaut = indice - self.getNumberColonnes()
        }
        if (indice < self.getNombreLignes() * self.getNumberColonnes() - self.getNumberColonnes())
        {
            indiceCellBas = indice + self.getNumberColonnes()
        }
        
        let array = NSMutableArray()
        if (indiceCellGauche != -1 && indiceCellGauche < self.collectionView?.numberOfItemsInSection(0) && (self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:indiceCellGauche, inSection:0)) as! CollectionViewCellWithLabel).titleLabel.text == "")
        {
            array.addObject(indiceCellGauche)
        }
        if (indiceCellDroite != -1 && indiceCellDroite < self.collectionView?.numberOfItemsInSection(0) && (self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:indiceCellDroite, inSection:0)) as! CollectionViewCellWithLabel).titleLabel.text == "")
        {
            array.addObject(indiceCellDroite)
        }
        if (indiceCellHaut != -1 && indiceCellHaut < self.collectionView?.numberOfItemsInSection(0) && (self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:indiceCellHaut, inSection:0)) as! CollectionViewCellWithLabel).titleLabel.text == "")
        {
            array.addObject(indiceCellHaut)
        }
        if (indiceCellBas != -1 && indiceCellBas < self.collectionView?.numberOfItemsInSection(0) && (self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:indiceCellBas, inSection:0)) as! CollectionViewCellWithLabel).titleLabel.text == "")
        {
            array.addObject(indiceCellBas)
        }
        if (array.count > 0)
        {
            return Int(array[Int(arc4random_uniform(UInt32(array.count)))] as! NSNumber)
        }
        return -1
    }
    
    private func getNumberOfCellWithTitle() -> Int
    {
        var resultat = 0
        var i = 0
        while (i < self.collectionView?.numberOfItemsInSection(0))
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! CollectionViewCellWithLabel
            if (cell.titleLabel.text != "")
            {
                resultat += 1
            }
            i += 1
        }
        return resultat
    }
    
    private func end()
    {
        let test = self.movePossible()
        let i = self.getNumberOfCellWithTitle()
        if (i == 1 || !test)
        {
            var message = "Aucun mouvement possible... La partie est finie, vous avez marqué " + String(self.score) + " points."
            if (i == 1)
            {
                let cell = self.getCellMaxDuplicable()
                self.score += Int(cell.titleLabel.text!)!
                
                message = "Félicitation vous avez réussi ! La partie est finie, vous avez marqué " + String(self.score) + " points."
            }
            let alertController = UIAlertController(title:"Partie finie", message:message, preferredStyle:.Alert)
            let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in self.navigationController?.popViewControllerAnimated(true) }
            alertController.addAction(alertAction)
            
            self.numbersScoresTableViewController.gameFinish(self.score)
            
            self.presentViewController(alertController, animated:true, completion:nil)
        }
    }
    
    private func movePossible() -> Bool
    {
        var i = 0
        while (i < self.collectionView?.numberOfItemsInSection(0))
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! CollectionViewCellWithLabel
            if (cell.titleLabel.text != "")
            {
                if (i % self.getNumberColonnes() != 0 && i - 1 < self.collectionView?.numberOfItemsInSection(0))
                {
                    let cellGauche = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i - 1, inSection:0)) as! CollectionViewCellWithLabel
                    if (cellGauche.titleLabel.text == cell.titleLabel.text)
                    {
                        return true
                    }
                }
                if (i + 1 % self.getNumberColonnes() != 0 && i + 1 < self.collectionView?.numberOfItemsInSection(0))
                {
                    let cellDroite = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i + 1, inSection:0)) as! CollectionViewCellWithLabel
                    if (cellDroite.titleLabel.text == cell.titleLabel.text)
                    {
                        return true
                    }
                }
                if (i > self.getNumberColonnes() && i - self.getNumberColonnes() < self.collectionView?.numberOfItemsInSection(0))
                {
                    let cellHaut = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i - self.getNumberColonnes(), inSection:0)) as! CollectionViewCellWithLabel
                    if (cellHaut.titleLabel.text == cell.titleLabel.text)
                    {
                        return true
                    }
                }
                if (i < self.getNombreLignes() * self.getNumberColonnes() - self.getNumberColonnes() && i + self.getNumberColonnes() < self.collectionView?.numberOfItemsInSection(0))
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
        self.title = "Score : " + String(self.score)
        
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
        self.setAllColorCell()
    }
    
    private func setAllColorCell()
    {
        var i = 0
        while (i < self.collectionView?.numberOfItemsInSection(0))
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! CollectionViewCellWithLabel
            if (cell.titleLabel.text == "")
            {
                cell.backgroundColor = UIColor.whiteColor()
            }
            i += 1
        }
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
        return 6
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
        return CGSizeMake(self.view.frame.size.width / CGFloat(self.getNumberColonnes()), (self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)!) / CGFloat(self.getNombreLignes()) - 5.0)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCellWithLabel
    
        cell.backgroundColor = UIColor.blackColor()
        
        var size = cell.frame.size.width
        if (size > cell.frame.size.height)
        {
            size = cell.frame.size.height
        }
        cell.titleLabel.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:size/3)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCellWithLabel
        if (cell.titleLabel.text == "" || self.activityIndicatorView.isAnimating())
        {
            return
        }
        self.activityIndicatorView.startAnimating()
        
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
        self.activityIndicatorView.stopAnimating()
    }

}
