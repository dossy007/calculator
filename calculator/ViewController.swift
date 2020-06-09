//
//  ViewController.swift
//  calculator
//
//  Created by 西田俊陽 on 2020/06/09.
//  Copyright © 2020 toshi. All rights reserved.
//

import UIKit
import Expression

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
            //titleを取得
            return
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
            return "式を正しくして"
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
    
   

}

