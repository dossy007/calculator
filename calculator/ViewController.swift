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
    @IBOutlet weak var history1: UILabel!
    @IBOutlet weak var history2: UILabel!
    @IBOutlet weak var history3: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var formulaLabel: UILabel!
    // var history: [Optional<String>]
    override func viewDidLoad() { //load setup
           super.viewDidLoad()
           formulaLabel.text = ""
           historyLabel .text = ""
           //optional<String>
           // Do any additional setup after loading the view.

           scroll.layer.borderColor = UIColor.red.cgColor
           scroll.layer.borderWidth = 1
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
            history1.text = historyLabel.text
        }
        let formula: String = formatFormula(formulaText)
        historyLabel.text = formulaText + "=" + evalFormula(formula)
        formulaLabel.text = evalFormula(formula)

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

}

