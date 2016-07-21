//
//  CalculMentalGameViewController.swift
//  BrainFuck
//
//  Created by Thomas Mac on 16/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit
import AudioToolbox

class CalculMentalGameViewController: UIViewController {
    
    internal var level = 0
    
    internal var calculMentalLevelCollectionViewController = CalculMentalLevelCollectionViewController()
    
    internal var endlessMod = false
    
    private var paveNumeriqueCollectionViewController = PaveNumeriqueCollectionViewController(collectionViewLayout:UICollectionViewFlowLayout())
    
    private let questionTextView = UITextView()
    
    private let reponseLabel = UILabel()
    
    private var resultat = 0
    
    private var objectif = 0
    
    private var vie = 0
    
    private var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Répondez aux questions"
        
        self.navigationItem.hidesBackButton = true
        
        let decalage = CGFloat(10.0)
        
        self.questionTextView.frame = CGRectMake(decalage, (self.navigationController?.navigationBar.frame.size.height)! + 2 * decalage, self.view.frame.size.width - 2 * decalage, (self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - (self.navigationController?.toolbar.frame.size.height)!) / 5)
        
        self.questionTextView.contentInset = UIEdgeInsetsMake(-self.questionTextView.frame.size.height + 10.0, 0.0, 0.0, 0.0)
        
        self.questionTextView.scrollEnabled = false
        self.questionTextView.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:18.0)
        self.questionTextView.backgroundColor = UIColor.whiteColor()
        self.questionTextView.textColor = UIColor.blackColor()
        self.questionTextView.textAlignment = NSTextAlignment.Center
        self.questionTextView.editable = false
        
        self.questionTextView.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        self.questionTextView.layer.borderWidth = 2.5
        self.questionTextView.layer.cornerRadius = 7.5
        self.questionTextView.layer.shadowOffset = CGSizeMake(0, 1)
        self.questionTextView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.questionTextView.layer.shadowRadius = 8.0
        self.questionTextView.layer.shadowOpacity = 0.8
        self.questionTextView.layer.masksToBounds = false
        
        self.reponseLabel.frame = CGRectMake(decalage, self.questionTextView.frame.origin.y + self.questionTextView.frame.size.height + decalage, self.questionTextView.frame.size.width - 3 * decalage - 50.0, 50.0)
        self.reponseLabel.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:18.0)
        self.reponseLabel.backgroundColor = UIColor.whiteColor()
        self.reponseLabel.textColor = UIColor.blackColor()
        self.reponseLabel.textAlignment = NSTextAlignment.Center
        self.reponseLabel.text = ""
        
        self.reponseLabel.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        self.reponseLabel.layer.borderWidth = 2.5
        self.reponseLabel.layer.cornerRadius = 7.5
        self.reponseLabel.layer.shadowOffset = CGSizeMake(0, 1)
        self.reponseLabel.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.reponseLabel.layer.shadowRadius = 8.0
        self.reponseLabel.layer.shadowOpacity = 0.8
        self.reponseLabel.layer.masksToBounds = false
        
        let correctionButton = UIButton(frame:CGRectMake(self.reponseLabel.frame.origin.x + self.reponseLabel.frame.size.width + decalage, self.reponseLabel.frame.origin.y, self.view.frame.size.width - self.reponseLabel.frame.origin.x - self.reponseLabel.frame.size.width - 2 * decalage, 50.0))
        correctionButton.setImage(UIImage(named:NSLocalizedString("ICON_SUPPR", comment:"")), forState:UIControlState.Normal)
        correctionButton.addTarget(self, action:#selector(self.correctionButtonActionListener), forControlEvents:UIControlEvents.TouchUpInside)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.paveNumeriqueCollectionViewController = PaveNumeriqueCollectionViewController(collectionViewLayout:layout)
        
        let y = self.reponseLabel.frame.origin.y + self.reponseLabel.frame.size.height + decalage
        self.paveNumeriqueCollectionViewController.collectionView?.frame = CGRectMake(decalage, y, self.view.frame.size.width - 2 * decalage, self.view.frame.size.height - y - decalage - (self.navigationController?.toolbar.frame.size.height)!)
        self.paveNumeriqueCollectionViewController.reponseLabel = self.reponseLabel
        
        self.view.addSubview(self.questionTextView)
        self.view.addSubview(self.reponseLabel)
        self.view.addSubview(correctionButton)
        self.view.addSubview(self.paveNumeriqueCollectionViewController.collectionView!)
        
        self.objectif = self.getObjectif()
        
        self.vie = self.getVie()
        
        self.setQuestion()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated:true)
        
        self.navigationController?.toolbar.barTintColor = UIColor(red:0.439, green:0.776, blue:0.737, alpha:1)
        
        let shadow = NSShadow()
        
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let validateButton = UIBarButtonItem(title:"Valider", style:.Plain, target:self, action:#selector(self.validateButtonActionListener))
        
        validateButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:nil, action:nil)
        
        self.navigationController?.toolbar.setItems([flexibleSpace, validateButton, flexibleSpace], animated:true)
        
        super.viewDidAppear(animated)
    }
    
    @objc private func validateButtonActionListener()
    {
        if (self.reponseLabel.text == "")
        {
            return
        }
        self.timer.invalidate()
        if (self.reponseLabel.text != "" && Int(self.reponseLabel.text!)! == self.resultat)
        {
            self.objectif -= 1
            if (self.objectif == 0)
            {
                self.calculMentalLevelCollectionViewController.levelCompleted(self.level)
                if (!self.endlessMod)
                {
                    let alertController = UIAlertController(title:"Level Completed", message:"Félicitation, vous avez fini le niveau N°" + String(self.level) + ".", preferredStyle:.Alert)
                    let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in
                        self.timer.invalidate()
                        self.navigationController?.popViewControllerAnimated(true)
                    }
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
        else
        {
            self.wrongAnswer()
        }
    }
    
    @objc private func correctionButtonActionListener()
    {
        if (self.reponseLabel.text != "")
        {
            self.reponseLabel.text = self.reponseLabel.text?.substringToIndex(self.reponseLabel.text!.endIndex.predecessor())
        }
    }
    
    private func setQuestion()
    {
        self.timer.invalidate()
        self.reponseLabel.text = ""
        
        var timeBonus = 0
        
        let number = self.getRandomNumber()
        if (number > 10)
        {
            timeBonus += 1
        }
        var question = String(number)
        self.resultat = number
        
        var nombreOperations = Int(arc4random_uniform(UInt32(self.getNombreMaxOperations()))) + 1
        
        timeBonus += nombreOperations - 1
        
        while (nombreOperations > 0)
        {
            var number = self.getRandomNumber()
            let operation = self.getOperation()
            if (operation == "/")
            {
                while (self.resultat % number != 0)
                {
                    number = self.getRandomNumber()
                }
            }
            if (number > 10)
            {
                timeBonus += 1
            }
            question = "( " + question + " " + operation + " " + String(number) + " )"
            self.calculResultat(number, operation:operation)
            nombreOperations -= 1;
        }
        self.questionTextView.text = question + " = ?"
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(Double(self.getTempsImparti(timeBonus)), target:self, selector:#selector(self.wrongAnswer), userInfo:nil, repeats:true)
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
                self.calculMentalLevelCollectionViewController.saveScore(self.getObjectif() - self.objectif, identifier:"CalculMentalLevelN°" + String(self.level))
            }
            let alertController = UIAlertController(title:"Défaite", message:message, preferredStyle:.Alert)
            let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in
                self.timer.invalidate()
                self.navigationController?.popViewControllerAnimated(true)
            }
            alertController.addAction(alertAction)
            
            presentViewController(alertController, animated:true, completion:nil)
        }
        self.setQuestion()
    }
    
    private func calculResultat(number:Int, operation:String)
    {
        if (operation == "+")
        {
            self.resultat += number
        }
        else if (operation == "-")
        {
            self.resultat -= number
        }
        else if (operation == "*")
        {
            self.resultat *= number
        }
        else if (operation == "/")
        {
            self.resultat /= number
        }
    }
    
    private func getOperation() -> String
    {
        let random = arc4random_uniform(4)
        if (random == 0)
        {
            return "+"
        }
        else if (random == 1)
        {
            return "-"
        }
        else if (random == 2)
        {
            return "*"
        }
        return "/"
    }
    
    private func getRandomNumber() -> Int
    {
        return Int(arc4random_uniform(UInt32(self.getNumberMax())) + 1)
    }
    
    private func getNumberMax() -> Int
    {
        var i = 0
        while (true)
        {
            if (self.level < (5 + i * 4))
            {
                return 9 + i * 10
            }
            i += 1
        }
    }
    
    private func getNombreMaxOperations() -> Int
    {
        var i = 0
        while (true)
        {
            var compteur = 0
            var resultat = 5
            while (self.level + compteur < (5 + i * 4))
            {
                compteur += 1
                resultat -= 1
            }
            if (compteur != 0)
            {
                return resultat
            }
            i += 1
        }
    }
    
    private func getTempsImparti(timeBonus: Int) ->Int
    {
        // A modifier un jour...
        return 5 + timeBonus
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
