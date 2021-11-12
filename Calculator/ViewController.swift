//
//  ViewController.swift
//  CalculatorTask Session 9LVL 2
//
//  Created by abdurhman elbosaty on 20/07/2021.
//

import UIKit

class ViewController: UIViewController {
    
    var op :Int?  // for operation
    var fisrtNum: Float? // first num in operation
    var numberMultiples: Float? // first num multiplies by second number  *-when click equal -*
    var flag = false // to be clear if choose operation or not
    var finalResult: Float? // to check if its Int or Float
    
    @IBOutlet var btnOutlet: [UIButton]!{
        didSet{
            for btn in btnOutlet {
                btn.layer.cornerRadius = btn.frame.height / 2
                btn.setTitleColor(UIColor.white.withAlphaComponent(0.1), for: .highlighted)
            }
        }
    }
    @IBOutlet weak var numPadLBL: UILabel!{
        didSet{
            numPadLBL.lineBreakMode = .byClipping
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBAction
    @IBAction func btnPressed(_ sender: UIButton) {
        let num = sender.tag
        
        switch num {
        // numPad
        case 0...9:
            if flag == true {
                clearNumPad()
                clearZero()
                
                if numPadLBL.text!.contains("."){
                    numPadLBL.text! = (numPadLBL.text! + "\(num)").maxLength(length: 10)
                    numberMultiples = Float(numPadLBL.text!)!
                    flag = false
                }else{
                    numberMultiples = Float((numPadLBL.text! + "\(num)").maxLength(length: 10))!
                    numPadLBL.text! = makeCommaForNumbers(number: numPadLBL.text! + "\(num)").maxLength(length: 10)
                }
                
            }else{
                clearZero()
                if numPadLBL.text!.contains("."){
                    numPadLBL.text! = (numPadLBL.text! + "\(num)").maxLength(length: 10)
                }else{
                    numPadLBL.text! = makeCommaForNumbers(number: numPadLBL.text! + "\(num)").maxLength(length: 10)
                }
            }
            
        // dot
        case 10:
            if numPadLBL.text!.contains(".") {
                break;
            }else if numPadLBL.text! == "0"{
                numPadLBL.text! = ("0" + ".")//.maxLength(length: 11)
            }else{
                numPadLBL.text! = (numPadLBL.text! + ".")//.maxLength(length: 11)
            }
            
        // equal
        case 11:
            print(String(numberMultiples!) + "qqqqq")
            //            guard let sn = Float(numPadLBL.text!) else {return}
            var sn: Float = 0.0
            guard let op = op else {return}
            guard let fn = (fisrtNum) else {return}
            
            
            if numPadLBL.text != nil {
                sn = numberMultiples ?? 0.0
            }
            print("\(fn)" + "w")
            print("\(sn)" + "w")
            calculation(fn: fn, sn: sn, op: op)
            checkForInt()
            fisrtNum = finalResult
            flag = true
            
        // operations
        case 12...15:
            op = num
            let fn = numPadLBL.text!
            if fn.contains(","){
                let newNum = removeComma(number: fn)
                fisrtNum = Float(newNum)
                flag = true
            }else{
                fisrtNum = Float(fn)
                flag = true
            }
            
        // plus/min
        case 16:
            
            if numPadLBL.text!.contains("-"){
                numPadLBL.text!.removeFirst()
                break;
            }else if numPadLBL.text!.contains("."){
                numPadLBL.text! = "-" + numPadLBL.text!
            }else{
                numPadLBL.text! = "-" + makeCommaForNumbers(number: numPadLBL.text!)
            }
            
        // precentage
        case 17:
            if numPadLBL.text! != "0"{
                // guard let num = (numPadLBL.text!) else{return}
                let num = numPadLBL.text!
                if num.contains(","){
                    let newNum = removeComma(number: num)
                    numPadLBL.text! = "\( Float(newNum)! / 100 )"
                }else{
                    numPadLBL.text! = "\( Float(num)! / 100 )"
                }
            }
            
        // clear
        case 18:
            clearNumPad()
            numberMultiples = 0.0
            flag = false
            
        default:
            break;
        }
    }
    
    //MARK: - Helper Functions
    
    func clearNumPad(){
        numPadLBL.text! = "0"
    }
    
    func clearZero(){
        if numPadLBL.text! == "0"{
            numPadLBL.text! = ""
        }else if numPadLBL.text! == "-0"{
            numPadLBL.text! = "-"
        }
    }
    
    func calculation(fn: Float ,sn: Float, op: Int){
        switch op {
        case 12:
            finalResult = fn + sn
        case 13:
            finalResult = (fn - sn)
        case 14:
            finalResult = (fn * sn)
        case 15:
            finalResult = (fn / sn)
        default:
            break;
        }
    }
    
    func checkForInt(){
        var castingFinalResult = String(finalResult!)
        if castingFinalResult.hasSuffix("0"){
            castingFinalResult.removeLast()
            castingFinalResult.removeLast()
            numPadLBL.text! = makeCommaForNumbers(number: castingFinalResult)
        }else{
            numPadLBL.text! = castingFinalResult
        }
    }
    
    func makeCommaForNumbers(number:String) -> String {
        
        if number.contains(","){
            let newNumber = number.replacingOccurrences(of: ",", with: "")
            return putCommaAfterCheck(num: newNumber)
        }else{
            return putCommaAfterCheck(num: number)
        }
    }
    
    func removeComma(number: String) -> String {
        if number.contains(","){
            let newNum = number.replacingOccurrences(of: ",", with: "")
            return newNum
        }else{
            return number
        }
    }
    
    func putCommaAfterCheck(num number:String) -> String{
        guard let num = Int(number) else{return "0"}
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: num))
        return formattedNumber!
    }
}

extension String {
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:NSRange(location: 0,length: nsString.length > length ? length :nsString.length))
        }
        return  str
    }
}
