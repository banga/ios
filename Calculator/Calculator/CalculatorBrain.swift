//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Shrey Banga on 6/29/16.
//  Copyright © 2016 Shrey Banga. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var accumulator = 0.0
    
    internal func setOperand(operand: Double) {
        accumulator = operand
    }
    
    var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "+": Operation.BinaryOperation({$0 + $1}),
        "-": Operation.BinaryOperation({$0 - $1}),
        "×": Operation.BinaryOperation({$0 * $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "=": Operation.Equals
    ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    var pending: PendingBinaryOperationInfo?
    
    internal func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let fn): accumulator = fn(accumulator)
            case .BinaryOperation(let fn): executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: fn, firstOperand: accumulator)
            case .Equals: executePendingBinaryOperation()
            }
        }
    }
    
    func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    internal var result: Double {
        get {
            return accumulator
        }
    }
}