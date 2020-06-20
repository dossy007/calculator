//
//  ViewController.swift
//  calculator
//
//  Created by 西田俊陽 on 2020/06/09.
//  Copyright © 2020 toshi. All rights reserved.
//

import UIKit
import Expression
import Foundation
class ViewController: UIViewController {
    @IBOutlet weak var history_box: UIView!
    @IBOutlet weak var caret: UILabel!
    @IBOutlet weak var lightShadow: UIButton!
    @IBOutlet var background: UIView!
    @IBOutlet weak var numberbtn: UIButton!
    @IBOutlet var historyCollection: [UILabel]!
    @IBOutlet weak var history1: UILabel!
    @IBOutlet weak var history2: UILabel!
    @IBOutlet weak var history3: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var formulaLabel: UILabel!
    override func viewDidLoad() { //load setup
           super.viewDidLoad()
           formulaLabel.text = ""
           historyLabel .text = ""
           //optional<String>
           // Do any additional setup after loading the view.
        
        //style
        background.backgroundColor = UIColor.hex(string: "#F3F3F3" ,alpha: 1)

        //scroll
        scroll.layer.borderWidth = 1

        //numberbtn
        numberbtn.layer.cornerRadius = 25

        numberbtn.backgroundColor = UIColor.hex(string: "#F3F3F3" ,alpha: 1)
        numberbtn.layer.shadowColor = UIColor.hex(string: "#E1E1E1",alpha: 1).cgColor
        numberbtn.layer.shadowRadius = 3
        numberbtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        numberbtn.layer.shadowOpacity = 5
        
        lightShadow.layer.shadowColor = UIColor.hex(string: "#FFFFFF",alpha: 1).cgColor
        lightShadow.layer.shadowOffset = CGSize(width:-1,height: -1)

        //formula
        formulaLabel.textAlignment = NSTextAlignment.right
        formulaLabel.font = formulaLabel.font.withSize(50)
        //history
        historyLabel.textAlignment = NSTextAlignment.right
        //historylabel
        history1.textAlignment = NSTextAlignment.right
        history2.textAlignment = NSTextAlignment.right
        history3.textAlignment = NSTextAlignment.right

        //historybox
        // history_box.layer.shadowColor = UIColor.hex(string: "#E1E1E1",alpha: 1).cgColor
        history_box.layer.shadowColor = UIColor.hex(string: "#FF0000",alpha: 1).cgColor
        history_box.layer.shadowOffset = CGSize(width: 20, height: 20)



        self.flashLabel() //caret点滅
       }

    @IBAction func back(_ sender: UIButton) {//back
        let result = formulaLabel.text!.dropLast()
        formulaLabel.text = String(result)
    }
    
    @IBAction func answerCalculator(_ sender: UIButton) { // =
        guard let formulaText = formulaLabel.text else{
            return
        }

        switch historyLabel.text{
            case "":
            print("何もしない")
            default:
            history3.text = history2.text
            history2.text = history1.text
            history1.text = historyLabel.text
            scroll.contentSize.height =  scroll.contentSize.height + 20
        }
        let formula: String = formatFormula(formulaText)
        historyLabel.text = formulaText + "=" + evalFormula(formula)
        formulaLabel.text = evalFormula(formula)
//        print(historyCollection[1].text)
        // history.append(historyLabel.text)
        // print(history)
    }

    @IBAction func clearCalculation(_ sender: UIButton) { //c
        formulaLabel.text = ""
        historyLabel.text = ""
        history1.text = ""
        history2.text = ""
        history3.text = ""
    }

    @IBAction func inputFormula(_ sender: UIButton) { //0~9 / * +-.
        guard let formulaText = formulaLabel.text else{
            return
        }
        guard let senderedText = sender.titleLabel?.text else{
            return
        }
        // senderedText 入力値

        let last = formulaText.suffix(1)  //末尾
        let matched = matches(for: "[^0-9]", in: String(last))  //only symbol

        //first input
        if formulaText.count == 0 && matches(for: "[.]", in: String(senderedText)).count == 1{
            formulaLabel.text = formulaText + senderedText
            return
        }

        if matched.count >= 1{ //記号が重複しないようにする
            let now_matched = matches(for: "[^0-9]", in: String(senderedText))
            if now_matched.count == 1{ //formula末尾とnowinputが記号なら、nowinputにreplace
                let r = formulaText.dropLast()
                formulaLabel.text = r + senderedText
                return 
            }
        }

        formulaLabel.text = formulaText + senderedText
      
    }

    private func formatFormula(_ formula: String) -> String{
        // ÷を/にするなどの処理

        let formattedFormula:String = formula.replacingOccurrences(
            of: "(?<=^|[÷×\\+\\-\\(])([0-9]+)(?=[÷×\\+\\-\\)]|$)",
            with: "$1.0",
            options: NSString.CompareOptions.regularExpression,
            range :nil
        ).replacingOccurrences(of: "÷",with: "/").replacingOccurrences(of:"x",with: "*")
        return formattedFormula
    }
    
    private func evalFormula(_ formula:String) -> String{
        do {
            //Expressionで文字列の計算式を評価して答えを求める
            let expression = Expression(formula)
            let answer = try expression.evaluate()
            return formatAnswer(String(answer))
        }catch {
            //不当だった時
            return "無効な式です"
        }
    }

    private func formatAnswer(_ answer:String) -> String{
        let formattedAnswer: String = answer.replacingOccurrences(
            of:"\\.0$",
            with: "",
            options: NSString.CompareOptions.regularExpression,
            range: nil
        )
        return formattedAnswer
    }

    private func matches(for regex: String, in text: String) -> [String] {

    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }

}
    private func flashLabel(){ //caret点滅

        UIView.animate(withDuration: 1.0,
                        delay: 0.0,
                        options: .repeat,
                        animations: {
                            self.caret.alpha = 0.0
            }) { (_) in
                self.caret.alpha = 1.0
            }
    }
}


extension UIColor {
    class func hex ( string : String, alpha : CGFloat) -> UIColor {
        let string_ = string.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: string_ as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            return UIColor.white;
        }
    }
}
