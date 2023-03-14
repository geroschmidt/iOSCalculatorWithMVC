//
//  HomeViewController.swift
//  iOS-Calculator
//
//  Created by Geronimo Schmidt on 13/02/2023.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorDiv: UIButton!
    @IBOutlet weak var operatorMult: UIButton!
    @IBOutlet weak var operatorSubstraction: UIButton!
    @IBOutlet weak var operatorAddition: UIButton!
    @IBOutlet weak var operatorShowResult: UIButton!
    
    // MARK: Variables
    private var total: Double = 0                   //Total
    private var temp:Double = 0                     //Valor por pantalla
    private var operating = false                   //Indicar si se ha seleccionado un operador
    private var decimal = false                     //Indicar si el valor es decimal
    private var operation: OperationType = .none    //Operacion actual
    
    // MARK: Constantes
    
    private let kDecimalSeparator = Locale.current.decimalSeparator
    private let kMaxLenght = 9
    private let kMaxValue: Double = 999999999
    private let kMinValue: Double = 0.00000001
    private let kTotal = "total"
    
    private enum OperationType {
        case none, addition, substraction, multiplication, division, percent
    }
    
    // Formateo de valores auxiliar
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateo de valores auxiliar
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateo de valores por pantalla por defecto
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 9
        
        return formatter
    }()
    
    // Formateo de valores en formato cientifico
    
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 3
        formatter.exponentSymbol = "e"
        
        return formatter
    }()
    
    // MARK: Initialization
    
    init (){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        total = UserDefaults.standard.double(forKey: kTotal)
        
        result()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //UI
        
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        operatorAC.round()
        operatorPlusMinus.round()
        operatorPercent.round()
        operatorDiv.round()
        operatorMult.round()
        operatorSubstraction.round()
        operatorAddition.round()
        operatorShowResult.round()
    }

    // MARK: IBActions
    
    @IBAction func divAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        operating = true
        operation = .division
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func multAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .multiplication
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func subsAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .substraction
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .addition
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func showResultAction(_ sender: UIButton) {
        result()
        sender.shine()
    }
    
    @IBAction func percentAction(_ sender: UIButton) {
        
        if operation != .percent {
            result()
        }
        operating = true
        operation = .percent
        result()
        
        sender.shine()
    }
    
    @IBAction func plusMinusAction(_ sender: UIButton) {
        temp = temp * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        sender.shine()
    }
    
    @IBAction func acAction(_ sender: UIButton) {
        clear()
        sender.shine()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
        operatorAC.setTitle("C", for: .normal)
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count > kMaxLenght {
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        // seleccionamos operacion
        if operating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        // trabajando con decimales
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator!)"
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        selectVisualOperation()
        sender.shine()
    }
    
    @IBAction func decimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count > kMaxLenght {
            return
        }
        
        resultLabel.text = resultLabel.text! + kDecimalSeparator!
        decimal = true
        
        selectVisualOperation()
        sender.shine()
    }
    
    // Limpia los valores
    private func clear() {
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if temp != 0{
            temp = 0
            resultLabel.text = "0"
        } else{
            total = 0
        }
    }
    
    // Obtiene el resultado final
    private func result() {
        
        switch operation {
            
        case .none:
            
            break
        case .addition:
            total += temp
            break
        case .substraction:
            total -= temp
            break
        case .multiplication:
            total *= temp
            break
        case .division:
            total /= temp
            break
        case .percent:
            temp /= 100
            total = temp
            break
        }
        
        // formateo en pantalla
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLenght {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none
        
        selectVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
        
        print("Total:\(total)")
    }
    
    // Muestra de forma visual la operacion seleccionada
    private func selectVisualOperation(){
        if !operating {
            //no estamos operando
            operatorAddition.selectOperation(false)
            operatorSubstraction.selectOperation(false)
            operatorDiv.selectOperation(false)
            operatorMult.selectOperation(false)
        } else {
            switch operation {
                
            case .none, .percent:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorDiv.selectOperation(false)
                operatorMult.selectOperation(false)
                break
            case .addition:
                operatorAddition.selectOperation(true)
                operatorSubstraction.selectOperation(false)
                operatorDiv.selectOperation(false)
                operatorMult.selectOperation(false)
                break
            case .substraction:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(true)
                operatorDiv.selectOperation(false)
                operatorMult.selectOperation(false)
                break
            case .multiplication:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorDiv.selectOperation(false)
                operatorMult.selectOperation(true)
                break
            case .division:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorDiv.selectOperation(true)
                operatorMult.selectOperation(false)
                break
            }
        }
    }
    
}
