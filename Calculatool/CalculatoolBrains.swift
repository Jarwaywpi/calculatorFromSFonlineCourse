//
//  CalculatoolBrains.swift
//  Calculatool
//
//  Created by Jarway on 16/10/19.
//  Copyright © 2016年 Jarway. All rights reserved.
//

import Foundation

class CalculatoolBrains {
    
    private enum Op: CustomStringConvertible {
        case Operant(Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self {
                case .Operant(let oprand):
                    return "\(oprand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case . BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knowOps = [String:Op]()
    
    init(){
        knowOps["×"] = Op.BinaryOperation("×", *)
        knowOps["÷"] = Op.BinaryOperation("÷", { $1 / $0 })
        knowOps["+"] = Op.BinaryOperation("+", +)
        knowOps["-"] = Op.BinaryOperation("-", { $1 - $0 })
        knowOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operant(let operant):
                return (operant, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandvaluation = evaluate(ops: remainingOps)
                if let operand = operandvaluation.result {
                    opStack.append(Op.Operant(operation(operand)))
                    return (operation(operand), operandvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operandvaluation = evaluate(ops: remainingOps)
                if let operand = operandvaluation.result {
                    let operandEvaluation = evaluate(ops: operandvaluation.remainingOps)
                    if let operand1 = operandEvaluation.result {
                        print("\(operation) on oprand \(operand) and oprand1 \(operand)")
                        opStack.append(Op.Operant(operation(operand, operand1)))
                        return (operation(operand, operand1), operandEvaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(ops: opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperant (operant: Double) -> Double? {
        opStack.append(Op.Operant(operant))
        return evaluate()
    }
    
    func performOperation (symbol: String) -> Double? {
        if let operation = knowOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
