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
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!

    override func viewDidLoad() { //load setup
           super.viewDidLoad()
           formulaLabel.text = ""
           answerLabel .text = ""
           // Do any additional setup after loading the view.
       }

    @IBAction func answerCalculator(_ sender: UIButton) { // =
        guard let formulaText = formulaLabel.text else{
            return
        }
        let formula: String = formatFormula(formulaText)
        answerLabel.text = evalFormula(formula)

    }

    @IBAction func clearCalculation(_ sender: UIButton) { //c
        formulaLabel.text = ""
        answerLabel.text = ""
    }

    @IBAction func inputFormula(_ sender: UIButton) { //0~9 / * +-.
        guard let formulaText = formulaLabel.text else{
            return
        }
        guard let senderedText = sender.titleLabel?.text else{
            return
        }
        //titleを取得
        // print(formulaText) 式の場所の数値 123 + 4 = 1234としてる
        // print(senderedText) これが現在入力値
        // print(formulaText.suffix(1)) //末尾
        let last = formulaText.suffix(1)
        let matched = matches(for: "[^0-9]", in: String(last))
        let now_matched = matches(for: "[^0-9]", in: String(senderedText))
        print(matched.count) //1なら一文字前が記号

        if matched.count == 1 && now_matched.count == 1{
            return
        }

        // if last.pregMatche(pattern: "+-÷x") {
        //     print("ok")
        // }

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

