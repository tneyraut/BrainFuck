//
//  ColorGameViewController.swift
//  BrainFuck
//
//  Created by Thomas Mac on 20/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class ColorGameViewController: UIViewController {

    internal var colorScoresTableViewController = ColorScoresTableViewController()
    
    private let questionLabel = UILabel()
    
    private let responseOneButton = UIButton()
    
    private let responseTwoButton = UIButton()
    
    private var response = ""
    
    private var score = 0
    
    private var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "What is the color ?"
        
        self.navigationItem.hidesBackButton = true
        
        let decalage = CGFloat(10.0)
        
        let enonceLabel = UILabel(frame:CGRectMake(decalage, (self.navigationController?.navigationBar.frame.size.height)! + 2 * decalage, self.view.frame.size.width - 2 * decalage, 50.0))
        enonceLabel.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:15.0)
        enonceLabel.backgroundColor = UIColor.clearColor()
        enonceLabel.textColor = UIColor.blackColor()
        enonceLabel.textAlignment = NSTextAlignment.Center
        enonceLabel.text = "En quelle couleur est écrit le mot ci-dessous ?"
        
        enonceLabel.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        enonceLabel.layer.borderWidth = 2.5
        enonceLabel.layer.cornerRadius = 7.5
        enonceLabel.layer.shadowOffset = CGSizeMake(0, 1)
        enonceLabel.layer.shadowColor = UIColor.lightGrayColor().CGColor
        enonceLabel.layer.shadowRadius = 8.0
        enonceLabel.layer.shadowOpacity = 0.8
        enonceLabel.layer.masksToBounds = false
        
        self.questionLabel.frame = CGRectMake(decalage, enonceLabel.frame.origin.y + enonceLabel.frame.size.height + decalage, enonceLabel.frame.size.width, 50.0)
        self.questionLabel.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:18.0)
        self.questionLabel.backgroundColor = UIColor.clearColor()
        self.questionLabel.textAlignment = NSTextAlignment.Center
        
        self.questionLabel.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        self.questionLabel.layer.borderWidth = 2.5
        self.questionLabel.layer.cornerRadius = 7.5
        //self.questionLabel.layer.shadowOffset = CGSizeMake(0, 1)
        //self.questionLabel.layer.shadowColor = UIColor.lightGrayColor().CGColor
        //self.questionLabel.layer.shadowRadius = 8.0
        //self.questionLabel.layer.shadowOpacity = 0.8
        self.questionLabel.layer.masksToBounds = false
        
        let size = CGFloat(100.0)
        
        self.responseOneButton.frame = CGRectMake((self.view.frame.width - 2 * decalage) / 4 - size / 2, self.questionLabel.frame.origin.y + self.questionLabel.frame.size.height + decalage, size, size)
        self.responseOneButton.titleLabel?.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:18.0)
        self.responseOneButton.titleLabel?.backgroundColor = UIColor.whiteColor()
        self.responseOneButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.responseOneButton.titleLabel?.frame = CGRectMake(0, 0, size, size)
        self.responseOneButton.titleLabel?.backgroundColor = UIColor.clearColor()
        self.responseOneButton.addTarget(self, action:#selector(self.responseButtonActionListener(_:)), forControlEvents:UIControlEvents.TouchUpInside)
        
        self.responseOneButton.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        self.responseOneButton.layer.borderWidth = 2.5
        self.responseOneButton.layer.cornerRadius = 7.5
        //self.responseOneButton.layer.shadowOffset = CGSizeMake(0, 1)
        //self.responseOneButton.layer.shadowColor = UIColor.lightGrayColor().CGColor
        //self.responseOneButton.layer.shadowRadius = 8.0
        //self.responseOneButton.layer.shadowOpacity = 0.8
        self.responseOneButton.layer.masksToBounds = false
        
        self.responseTwoButton.frame = CGRectMake(3 * (self.view.frame.width - 2 * decalage) / 4 - size / 2, self.questionLabel.frame.origin.y + self.questionLabel.frame.size.height + decalage, size, size)
        self.responseTwoButton.titleLabel?.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:18.0)
        self.responseTwoButton.titleLabel?.backgroundColor = UIColor.whiteColor()
        self.responseTwoButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.responseTwoButton.titleLabel?.frame = CGRectMake(0, 0, size, size)
        self.responseTwoButton.titleLabel?.backgroundColor = UIColor.clearColor()
        self.responseTwoButton.addTarget(self, action:#selector(self.responseButtonActionListener(_:)), forControlEvents:UIControlEvents.TouchUpInside)
        
        self.responseTwoButton.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        self.responseTwoButton.layer.borderWidth = 2.5
        self.responseTwoButton.layer.cornerRadius = 7.5
        //self.responseTwoButton.layer.shadowOffset = CGSizeMake(0, 1)
        //self.responseTwoButton.layer.shadowColor = UIColor.lightGrayColor().CGColor
        //self.responseTwoButton.layer.shadowRadius = 8.0
        //self.responseTwoButton.layer.shadowOpacity = 0.8
        self.responseTwoButton.layer.masksToBounds = false
        
        self.view.addSubview(enonceLabel)
        self.view.addSubview(self.questionLabel)
        self.view.addSubview(self.responseOneButton)
        self.view.addSubview(self.responseTwoButton)
        
        self.score = 0
        
        self.setQuestion()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func responseButtonActionListener(sender: UIButton)
    {
        self.timer.invalidate()
        if (sender.titleLabel?.text == self.response)
        {
            self.score += 1
            self.setQuestion()
        }
        else
        {
            self.time()
        }
    }
    
    @objc private func time()
    {
        self.timer.invalidate()
        
        let alertController = UIAlertController(title:"Fin de la partie", message:"La partie est finie, vous avez marqué " + String(self.score) + " points.", preferredStyle:.Alert)
        let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in self.navigationController?.popViewControllerAnimated(true) }
        alertController.addAction(alertAction)
        
        self.colorScoresTableViewController.gameFinish(self.score)
        
        presentViewController(alertController, animated:true, completion:nil)
    }
    
    private func setQuestion()
    {
        self.questionLabel.textColor = self.getRandomColor()
        self.questionLabel.text = self.getStringColor(self.getRandomColor())
        
        self.response = self.getStringColor(self.questionLabel.textColor)
        
        let i = arc4random_uniform(2)
        if (i == 0)
        {
            self.responseOneButton.setTitle(self.getStringColor(self.questionLabel.textColor), forState:UIControlState.Normal)
            self.responseTwoButton.setTitle(self.getStringColor(self.getRandomColor()), forState:UIControlState.Normal)
            while (self.responseTwoButton.titleLabel?.text == self.responseOneButton.titleLabel?.text)
            {
                self.responseTwoButton.setTitle(self.getStringColor(self.getRandomColor()), forState:UIControlState.Normal)
            }
        }
        else
        {
            self.responseTwoButton.setTitle(self.getStringColor(self.questionLabel.textColor), forState:UIControlState.Normal)
            self.responseOneButton.setTitle(self.getStringColor(self.getRandomColor()), forState:UIControlState.Normal)
            while (self.responseOneButton.titleLabel?.text == self.responseTwoButton.titleLabel?.text)
            {
                self.responseOneButton.setTitle(self.getStringColor(self.getRandomColor()), forState:UIControlState.Normal)
            }
        }
        self.responseOneButton.setTitleColor(self.getRandomColor(), forState:UIControlState.Normal)
        self.responseTwoButton.setTitleColor(self.getRandomColor(), forState:UIControlState.Normal)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target:self, selector:#selector(self.time), userInfo:nil, repeats:true)
    }
    
    private func getRandomColor() -> UIColor
    {
        let i = arc4random_uniform(8)
        switch i {
        case 0:
            return UIColor.blueColor()
        case 1:
            return UIColor.brownColor()
        case 2:
            return UIColor.grayColor()
        case 3:
            return UIColor.greenColor()
        case 4:
            return UIColor.orangeColor()
        case 5:
            return UIColor.purpleColor()
        case 6:
            return UIColor.redColor()
        case 7:
            return UIColor.yellowColor()
        default:
            return UIColor.blackColor()
        }
    }
    
    private func getStringColor(color: UIColor) -> String
    {
        switch color {
        case UIColor.blueColor():
            return "Bleu"
        case UIColor.brownColor():
            return "Marron"
        case UIColor.grayColor():
            return "Gris"
        case UIColor.greenColor():
            return "Vert"
        case UIColor.orangeColor():
            return "Orange"
        case UIColor.purpleColor():
            return "Violet"
        case UIColor.redColor():
            return "Rouge"
        case UIColor.yellowColor():
            return "Jaune"
        default:
            return "Noir"
        }
    }
    
}
