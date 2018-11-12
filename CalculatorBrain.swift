//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Blanca Wang on 09/07/2017.
//  Copyright © 2017 Blanca Wang. All rights reserved.
//

import Foundation

/* has been changed by simplier one
 func changeSign(operand: Double) -> Double {
    return -operand
}


 func multiply (op1: Double, op2: Double) -> Double {
    return op1 * op2
} */

struct CalculatorBrain {
    
    private var accumulator: Double?  //private means it's still in struct
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)   //for 5*3=
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({-$0}),   // used to be changeSign
        "×" : Operation.binaryOperation({$0 * $1}),  // use $0 & $1 insdead of (Double, Double)
        "÷" : Operation.binaryOperation({$0 / $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "−" : Operation.binaryOperation({$0 - $1}),
        "=" : Operation.equals
        
    ]
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)  //! unwrap
                }
            case .equals:
                performPendingBinaryOperation()
            }
    
        }
    }
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
           accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    private var pendingBinaryOperation: PendingBinaryOperation?  //? means it's optional. we are not always in pending
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator!
        }
    }
}
