//
//  ViewController.swift
//  Gambit challenge
//
//  Created by Hassan on 1.10.2020.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var lblLastUpdate: UILabel!
    @IBOutlet weak var cvModbus: UICollectionView!
    
    //MARK:- Variables
    var arrFileText: [String] = []
    var arrFormat = ["REAL4","LONG","BCD","INTEGER","BIT", "UNKNOWN"]
    
    //MARK:- Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding gradient to the background
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.gray.cgColor]

        view.layer.insertSublayer(gradient, at: 0)
        
        //Load texttfile from the server
        ServerManager.getTextFile { (status, data) in
            
            if status == "success"
            {
                self.parseText(textFile: data!)
                self.cvModbus.reloadData()
            }
            else
            {
                self.showAlert(message: status)
            }
        }
    }
    
    //MARK:- Functions
    func parseText(textFile:String)
    {
        let sentence = textFile
        sentence.enumerateLines { [self] line, _ in
            arrFileText.append(line)
        }
        print(arrFileText)
        lblLastUpdate.text = "Last Update: \(arrFileText[0])"
        
        for (index, value) in arrFileText.enumerated()
        {
            
            //Set color for REAL4
            //REAL4: 1 2 3 4 5 6 7 8 11 12 15 16 19 20 23 24 27 28 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 77 78 79 80 81 82 83 84 85 86 87 88 89 90 97 98 99 100
            if index == 1 || index == 2 || index == 3 || index == 4 || index == 5 || index == 6 || index == 7 || index == 8 || index == 11 || index == 12 || index == 15 || index == 16 || index == 19 || index == 20 || index == 23 || index == 24 || index == 27 || index == 28 || index == 31 || index == 32 || index == 33 || index == 34 || index == 35 || index == 36 || index == 37 || index == 38 || index == 39 || index == 40 || index == 41 || index == 42 || index == 43 || index == 44 || index == 45 || index == 46 || index == 47 || index == 48 || index == 77 || index == 78 || index == 79 || index == 80 || index == 81 || index == 82 || index == 83 || index == 84 || index == 85 || index == 86 || index == 87 || index == 88 || index == 89 || index == 90 || index == 97 || index == 98 || index == 99 || index == 100
            {
                arrFileText[index] = "\(value):\(arrFormat[0])"
            }
            
            //Set Colors for LONG
            //LONG: 9 10 13 14 17 18 21 22 25 26 29 30
            else if index == 9 || index == 10 || index == 13 || index == 14 || index == 17 || index == 18 || index == 21 || index == 22 || index == 25 || index == 26 || index == 29 || index == 30
            {
                arrFileText[index] = "\(value):\(arrFormat[1])"
            }
            
            //Set Colors for BCD
            //BCD: 49 50 51 53 55 56
            else if index == 49 || index == 50 || index == 51 || index == 53 || index == 55 || index == 56
            {
                arrFileText[index] = "\(value):\(arrFormat[2])"
            }
            
            //Set Colors for INTEGER
            //INTEGER: 59 60 61 62 62 92 93 94 96
            else if index == 59 || index == 60 || index == 61 || index == 62 || index == 92 || index == 93 || index == 94 || index == 96
            {
                arrFileText[index] = "\(value):\(arrFormat[3])"
            }
            
            //Set Colors for BIT
            //BIT: 72
            else if index == 72
            {
                arrFileText[index] = "\(value):\(arrFormat[4])"
            }
            else
            {
                arrFileText[index] = "\(value):\(arrFormat[5])"
            }
        }
        arrFileText.remove(at: 0)
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Gambit Challenge", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- CollectionView DataSource
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrFileText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let modbusCCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModbusCCell", for: indexPath) as! ModbusCCell
    
        let modbusText = arrFileText[indexPath.row].components(separatedBy: ":")
        
        modbusCCell.lblRegister.text = modbusText[0]
        modbusCCell.lblValue.text = modbusText[1]
        
        modbusCCell.vwBackground.layer.cornerRadius = 50
        
        if modbusText[2] == arrFormat[0]{
            modbusCCell.vwBackground.backgroundColor = UIColor.systemRed
        }
       else if modbusText[2] == arrFormat[1]{
            modbusCCell.vwBackground.backgroundColor = UIColor.systemGreen
        }
       else if modbusText[2] == arrFormat[2]{
            modbusCCell.vwBackground.backgroundColor = UIColor.systemBlue
        }
       else if modbusText[2] == arrFormat[3]{
            modbusCCell.vwBackground.backgroundColor = UIColor.systemOrange
        }
       else if modbusText[2] == arrFormat[4]{
            modbusCCell.vwBackground.backgroundColor = UIColor.systemYellow
        }
        else{
            modbusCCell.vwBackground.backgroundColor = UIColor.systemGray
        }
        
        
        modbusCCell.vwBackground.layer.borderWidth = 1
        modbusCCell.vwBackground.layer.borderColor = UIColor.black.cgColor
        modbusCCell.vwBackground.layer.masksToBounds = false
        modbusCCell.vwBackground.layer.shadowColor = UIColor.lightGray.cgColor
        modbusCCell.vwBackground.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        modbusCCell.vwBackground.layer.shadowOpacity = 0.5

        return modbusCCell
    }
    
    
}

//MARK:- CollectionView Delegate FlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = 100
        let yourHeight = 100

        return CGSize(width: yourWidth, height: yourHeight)
    }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets.zero
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            
            return 5
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
}

