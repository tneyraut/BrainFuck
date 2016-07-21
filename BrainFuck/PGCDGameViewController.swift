//
//  PGCDGameViewController.swift
//  BrainFuck
//
//  Created by Thomas Mac on 19/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit
import AudioToolbox

class PGCDGameViewController: UIViewController {

    internal var level = 0
    
    internal var pgcdLevelCollectionViewController = PGCDLevelCollectionViewController()
    
    internal var endlessMod = false
    
    private let questionLabel = UILabel()
    
    private var choixMultiplesCollectionViewController = ChoixMultiplesCollectionViewController(collectionViewLayout:UICollectionViewFlowLayout())
    
    private var vie = 0
    
    private var objectif = 0
    
    private var timer = NSTimer()
    
    private var pgcd = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Trouver le PGCD"
        
        self.navigationItem.hidesBackButton = true
        
        let decalage = CGFloat(10.0)
        
        self.questionLabel.frame = CGRectMake(decalage, (self.navigationController?.navigationBar.frame.size.height)! + 2 * decalage, self.view.frame.size.width - 2 * decalage, 50.0)
        
        self.questionLabel.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:18.0)
        self.questionLabel.backgroundColor = UIColor.whiteColor()
        self.questionLabel.textColor = UIColor.blackColor()
        self.questionLabel.textAlignment = NSTextAlignment.Center
        
        self.questionLabel.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        self.questionLabel.layer.borderWidth = 2.5
        self.questionLabel.layer.cornerRadius = 7.5
        self.questionLabel.layer.shadowOffset = CGSizeMake(0, 1)
        self.questionLabel.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.questionLabel.layer.shadowRadius = 8.0
        self.questionLabel.layer.shadowOpacity = 0.8
        self.questionLabel.layer.masksToBounds = false
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.choixMultiplesCollectionViewController = ChoixMultiplesCollectionViewController(collectionViewLayout:layout)
        
        self.choixMultiplesCollectionViewController.collectionView?.frame = CGRectMake(decalage, self.questionLabel.frame.origin.y + self.questionLabel.frame.size.height + decalage, self.questionLabel.frame.size.width, self.view.frame.size.height - self.questionLabel.frame.origin.y - self.questionLabel.frame.size.height - 2 * decalage)
        
        self.choixMultiplesCollectionViewController.viewController = self
        
        self.view.addSubview(self.questionLabel)
        self.view.addSubview(self.choixMultiplesCollectionViewController.collectionView!)
        
        self.objectif = self.getObjectif()
        
        self.vie = self.getVie()
        
        self.setQuestion()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setQuestion()
    {
        self.choixMultiplesCollectionViewController.removeAllItems()
        
        let numberOne = self.getRandomNumber() + 1
        let numberTwo = self.getRandomNumber() + 1
        
        self.questionLabel.text = "Trouver le PGCD des nombres " + String(numberOne) + " et " + String(numberTwo)
        
        self.pgcd = self.getPGCD(numberOne, b:numberTwo)
        
        let limit = self.getNumberOfItems()
        var i = 0
        while (i < limit)
        {
            var a = self.getRandomNumber()
            while (a == self.pgcd)
            {
                a = self.getRandomNumber()
            }
            self.choixMultiplesCollectionViewController.addItems(a)
            i += 1
        }
        let indice = arc4random_uniform(UInt32(limit))
        self.choixMultiplesCollectionViewController.replaceItemAtIndex(Int(indice), item:self.pgcd)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(Double(self.getTempsImparti()), target:self, selector:#selector(self.wrongAnswer), userInfo:nil, repeats:true)
    }
    
    internal func answer(value: Int)
    {
        self.timer.invalidate()
        if (value == self.pgcd)
        {
            self.correctAnswer()
        }
        else
        {
            self.wrongAnswer()
        }
        self.choixMultiplesCollectionViewController.ok = true
    }
    
    private func correctAnswer()
    {
        self.objectif -= 1
        if (self.objectif == 0)
        {
            self.pgcdLevelCollectionViewController.levelCompleted(self.level)
            if (!self.endlessMod)
            {
                let alertController = UIAlertController(title:"Level Completed", message:"Félicitation, vous avez fini le niveau N°" + String(self.level) + ".", preferredStyle:.Alert)
                let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in self.navigationController?.popViewControllerAnimated(true) }
                alertController.addAction(alertAction)
                
                presentViewController(alertController, animated:true, completion:nil)
            }
            else
            {
                self.setQuestion()
            }
        }
        else
        {
            self.setQuestion()
        }
    }
    
    @objc private func wrongAnswer()
    {
        self.timer.invalidate()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        self.vie -= 1
        if (self.vie < 0)
        {
            var message = "Vous avez fait plus de trois fautes !"
            if (self.endlessMod)
            {
                message = message + " Vous avez répondu correctement à " + String(self.getObjectif() - self.objectif) + " questions."
                self.pgcdLevelCollectionViewController.saveScore(self.getObjectif() - self.objectif, identifier:"PGCDLevelN°" + String(self.level))
            }
            let alertController = UIAlertController(title:"Défaite", message:message, preferredStyle:.Alert)
            let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in self.navigationController?.popViewControllerAnimated(true) }
            alertController.addAction(alertAction)
            
            presentViewController(alertController, animated:true, completion:nil)
        }
        else
        {
            self.setQuestion()
        }
    }
    
    private func getPGCD(a: Int, b: Int) -> Int
    {
        if (a % b == 0)
        {
            return b
        }
        if (b % a == 0)
        {
            return a
        }
        var resultat = 1
        let racineCarree = sqrt(Double(max(a, b)))
        var i = 2
        while (Double(i) <= racineCarree)
        {
            if (a % i == 0 && b % i == 0)
            {
                resultat = i
            }
            i += 1
        }
        return resultat
    }
    
    private func getRandomNumber() -> Int
    {
        let i = UInt32(self.level - 1) * 10 + 11
        return Int(arc4random_uniform(i))
    }
    
    private func getNumberOfItems() -> Int
    {
        if  (self.level * 5 > 50)
        {
            return 50
        }
        return self.level * 5
    }
    
    private func getTempsImparti() ->Int
    {
        // A modifier un jour...
        return 5 + (self.level - 1) * 5
    }
    
    private func getObjectif() -> Int
    {
        // A modifier un jour...
        return 10
    }
    
    private func getVie() -> Int
    {
        // A modifier un jour...
        return 3
    }

}
