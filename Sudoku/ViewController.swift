//
//  ViewController.swift
//  Sudoku
//
//  Created by Phanindra purighalla on 24/07/17.
//  Copyright © 2017 Aarna Solutions Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isEliminatePressed = false
    
    var isSolvePressed = false
    
    var selectedSymbol = ""
    
    var matrix = [["2","7","0","0","0","8","3","0","0"],
                  ["0","0","0","7","0","0","0","8","0"],
                  ["0","0","0","0","0","0","0","5","1"],
                  ["7","0","0","6","0","1","0","9","5"],
                  ["8","0","0","4","2","3","0","0","7"],
                  ["1","4","0","5","0","7","0","0","8"],
                  ["9","1","0","0","0","0","0","0","0"],
                  ["0","6","0","0","0","5","0","0","0"],
                  ["0","0","3","8","0","0","0","1","9"]]
    
    var solvedMatrix = [["2","7","9","1","5","8","3","4","6"],
                  ["3","5","1","7","4","6","9","8","2"],
                  ["6","8","4","2","3","9","7","5","1"],
                  ["7","3","2","6","8","1","4","9","5"],
                  ["8","9","5","4","2","3","1","6","7"],
                  ["1","4","6","5","9","7","2","3","8"],
                  ["9","1","8","3","6","2","5","7","4"],
                  ["4","6","7","9","1","5","8","2","3"],
                  ["5","2","3","8","7","4","6","1","9"]]
    
    var colArray = [["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"]]
    
    var rowArray = [["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"],
                    ["0","0","0","0","0","0","0","0","0"]]
    
    var block1 = [["0","0","0"],["0","0","0"],["0","0","0"]]
    var block2 = [["0","0","0"],["0","0","0"],["0","0","0"]]
    var block3 = [["0","0","0"],["0","0","0"],["0","0","0"]]
    var block4 = [["0","0","0"],["0","0","0"],["0","0","0"]]
    var block5 = [["0","0","0"],["0","0","0"],["0","0","0"]]
    var block6 = [["0","0","0"],["0","0","0"],["0","0","0"]]
    var block7 = [["0","0","0"],["0","0","0"],["0","0","0"]]
    var block8 = [["0","0","0"],["0","0","0"],["0","0","0"]]
    var block9 = [["0","0","0"],["0","0","0"],["0","0","0"]]
    
    var candidatesDictionary = Dictionary<String, [[String]]>()
    
    func generateArrays() {
        for row in 0...8 {
            for col in 0...8 {
                colArray[row][col] = matrix[col][row]
                rowArray[row][col] = matrix[row][col]
                switch row {
                case 0...2:
                    switch col {
                    case 0...2:
                        block1[row][col] = matrix[row][col]
                    case 3...5:
                        block2[row][col-3] = matrix[row][col]
                    case 6...8:
                        block3[row][col-6] = matrix[row][col]
                    default:
                        break
                    }
                case 3...5:
                    switch col {
                    case 0...2:
                        block4[row-3][col] = matrix[row][col]
                    case 3...5:
                        block5[row-3][col-3] = matrix[row][col]
                    case 6...8:
                        block6[row-3][col-6] = matrix[row][col]
                    default:
                        break
                    }
                case 6...8:
                    switch col {
                    case 0...2:
                        block7[row-6][col] = matrix[row][col]
                    case 3...5:
                        block8[row-6][col-3] = matrix[row][col]
                    case 6...8:
                        block9[row-6][col-6] = matrix[row][col]
                    default:
                        break
                    }
                default:
                    break
                }
            }
        }
    }
    
    func printArrays() {
        for i in 0...8 {
            print ("Column Array: \(i+1): \(colArray[i])")
            print ("Row Array: \(i+1): \(rowArray[i])")
        }
        print ("Block1: \(block1)")
        print ("Block2: \(block2)")
        print ("Block3: \(block3)")
        print ("Block4: \(block4)")
        print ("Block5: \(block5)")
        print ("Block6: \(block6)")
        print ("Block7: \(block7)")
        print ("Block8: \(block8)")
        print ("Block9: \(block9)")
    }
    
    func solveOpenSinglesInRegion (region : inout [Int]) {
        var openSingleInRegion = 0
        for element in region {
            if element == 0 {
                openSingleInRegion += 1
                if openSingleInRegion == 2 {
                    break
                }
            }
        }
        if openSingleInRegion == 1 {
            for number in 1...9 {
                if !region.contains(number) {
                    for index in 0...8 {
                        if region[index] == 0 {
                            region.remove(at: index)
                            region.insert(number, at: index)
                        }
                    }
                }
            }
        }
    }
    
    func checkIfBlockContainsSymbol (block : [[String]], symbolToCheck: String) -> Bool {
        var blockContainsSymbol = false
        for row in 0...2 {
            if block[row].contains(symbolToCheck) {
                blockContainsSymbol = true
                break
            }
        }
        return blockContainsSymbol
    }
    
    
    func visuallyEliminateSymbol (symbol: String) {
        for row in 0...8 {
            for col in 0...8 {
                if matrix[row][col] == "0" {
                    switch row {
                    case 0...2:
                        switch col {
                        case 0...2:
                            if (checkIfBlockContainsSymbol(block: block1, symbolToCheck: symbol) == true || rowArray[row].contains(symbol) || colArray[col].contains(symbol)) {
                                matrix[row][col] = "X"
                                block1[row][col] = "X"
                                rowArray[row][col] = "X"
                                colArray[col][row] = "X"
                            }
                        case 3...5:
                            if (checkIfBlockContainsSymbol(block: block2, symbolToCheck: symbol) == true || rowArray[row].contains(symbol) || colArray[col].contains(symbol)) {
                                matrix[row][col] = "X"
                                block2[row][col-3] = "X"
                                rowArray[row][col] = "X"
                                colArray[col][row] = "X"
                            }
                        case 6...8:
                            if (checkIfBlockContainsSymbol(block: block3, symbolToCheck: symbol) == true || rowArray[row].contains(symbol) || colArray[col].contains(symbol)) {
                                matrix[row][col] = "X"
                                block3[row][col-6] = "X"
                                rowArray[row][col] = "X"
                                colArray[col][row] = "X"
                            }
                        default:
                            break
                        }
                    case 3...5:
                        switch col {
                        case 0...2:
                            if (checkIfBlockContainsSymbol(block: block4, symbolToCheck: symbol) == true || rowArray[row].contains(symbol) || colArray[col].contains(symbol)) {
                                matrix[row][col] = "X"
                                block4[row-3][col] = "X"
                                rowArray[row][col] = "X"
                                colArray[col][row] = "X"
                            }
                        case 3...5:
                            if (checkIfBlockContainsSymbol(block: block5, symbolToCheck: symbol) == true || rowArray[row].contains(symbol) || colArray[col].contains(symbol)) {
                                matrix[row][col] = "X"
                                block5[row-3][col-3] = "X"
                                rowArray[row][col] = "X"
                                colArray[col][row] = "X"
                            }
                        case 6...8:
                            if (checkIfBlockContainsSymbol(block: block6, symbolToCheck: symbol) == true || rowArray[row].contains(symbol) || colArray[col].contains(symbol)) {
                                matrix[row][col] = "X"
                                block6[row-3][col-6] = "X"
                                rowArray[row][col] = "X"
                                colArray[col][row] = "X"
                            }
                        default:
                            break
                        }
                    case 6...8:
                        switch col {
                        case 0...2:
                            if (checkIfBlockContainsSymbol(block: block7, symbolToCheck: symbol) == true || rowArray[row].contains(symbol) || colArray[col].contains(symbol)) {
                                matrix[row][col] = "X"
                                block7[row-6][col] = "X"
                                rowArray[row][col] = "X"
                                colArray[col][row] = "X"
                            }
                        case 3...5:
                            if (checkIfBlockContainsSymbol(block: block8, symbolToCheck: symbol) == true || rowArray[row].contains(symbol) || colArray[col].contains(symbol)) {
                                matrix[row][col] = "X"
                                block8[row-6][col-3] = "X"
                                rowArray[row][col] = "X"
                                colArray[col][row] = "X"
                            }
                        case 6...8:
                            if (checkIfBlockContainsSymbol(block: block9, symbolToCheck: symbol) == true || rowArray[row].contains(symbol) || colArray[col].contains(symbol)) {
                                matrix[row][col] = "X"
                                block9[row-6][col-6] = "X"
                                rowArray[row][col] = "X"
                                colArray[col][row] = "X"
                            }
                        default:
                            break
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func printSudokuUsingBlocks() {
        for row in 0...8 {
            var curRow = ""
            for col in 0...8 {
                switch row {
                case 0...2:
                    switch col {
                    case 0...2:
                        curRow += " " + block1[row][col]
                    case 3...5:
                        curRow += " " + block2[row][col-3]
                    case 6...8:
                        curRow += " " + block3[row][col-6]
                    default:
                        break
                    }
                case 3...5:
                    switch col {
                    case 0...2:
                        curRow += " " + block4[row-3][col]
                    case 3...5:
                        curRow += " " + block5[row-3][col-3]
                    case 6...8:
                        curRow += " " + block6[row-3][col-6]
                    default:
                        break
                    }
                case 6...8:
                    switch col {
                    case 0...2:
                        curRow += " " + block7[row-6][col]
                    case 3...5:
                        curRow += " " + block8[row-6][col-3]
                    case 6...8:
                        curRow += " " + block9[row-6][col-6]
                    default:
                        break
                    }
                default:
                    break
                }
            }
            print ("\(curRow)")
        }
    }
    
    func printSudokuUsingRowsAndCols() {
        for row in 0...8 {
            var curRow = ""
            for col in 0...8 {
                curRow += " " + matrix[row][col]
            }
            print ("\(curRow)")
        }
    }
    
    func numberOfBlanksInBlock (block: [[String]]) -> Int {
        var numberOfBlanks = 0
        for row in 0...2 {
            numberOfBlanks += block[row].reduce(0) { $1 == "0" ? $0 + 1 : $0 }
        }
        return numberOfBlanks
    }
    
    func replaceBlankWithSolution (solution: String) {
        for row in 0...8 {
            var blanksInRow = 0
            for col in 0...8 {
                var blanksInCol = 0
                if matrix[row][col] == "0" {
                    blanksInRow += 1
                    if blanksInRow == 2 {
                        break
                    }
                }
                for row in 0...8 {
                    if matrix[row][col] == "0" {
                        blanksInCol += 1
                        if blanksInCol == 2 {
                            break
                        }
                    }
                }
                if blanksInCol == 1 {
                    for row in 0...8 {
                        if matrix[row][col] == "0" {
                            matrix[row][col] = solution
                            rowArray[row][col] = solution
                            colArray[col][row] = solution
                            
                            // set all other blanks in the same row, column and block to X
                            visuallyEliminateSymbol(symbol: solution)
                            
                            switch row {
                            case 0...2:
                                switch col {
                                case 0...2:
                                    block1[row][col] = solution
                                    // set all other blanks in the same row, column and block to X
                                    visuallyEliminateSymbol(symbol: solution)
                                    
                                case 3...5:
                                    block2[row][col-3] = solution
                                    // set all other blanks in the same row, column and block to X
                                    visuallyEliminateSymbol(symbol: solution)
                                    
                                case 6...8:
                                    block3[row][col-6] = solution
                                    // set all other blanks in the same row, column and block to X
                                    visuallyEliminateSymbol(symbol: solution)
                                    
                                default:
                                    break
                                }
                            case 3...5:
                                switch col {
                                case 0...2:
                                    block4[row-3][col] = solution
                                    // set all other blanks in the same row, column and block to X
                                    visuallyEliminateSymbol(symbol: solution)
                                    
                                case 3...5:
                                    block5[row-3][col-3] = solution
                                    // set all other blanks in the same row, column and block to X
                                    visuallyEliminateSymbol(symbol: solution)
                                    
                                case 6...8:
                                    block6[row-3][col-6] = solution
                                    // set all other blanks in the same row, column and block to X
                                    visuallyEliminateSymbol(symbol: solution)
                                    
                                default:
                                    break
                                }
                            case 6...8:
                                switch col {
                                case 0...2:
                                    block7[row-6][col] = solution
                                    // set all other blanks in the same row, column and block to X
                                    visuallyEliminateSymbol(symbol: solution)
                                    
                                case 3...5:
                                    block8[row-6][col-3] = solution
                                    // set all other blanks in the same row, column and block to X
                                    visuallyEliminateSymbol(symbol: solution)
                                    
                                case 6...8:
                                    block9[row-6][col-6] = solution
                                    // set all other blanks in the same row, column and block to X
                                    visuallyEliminateSymbol(symbol: solution)
                                    
                                default:
                                    break
                                }
                            default:
                                break
                            }
                            break
                        }
                    }
                }
            }
            if blanksInRow == 1 {
                for col in 0...8 {
                    if matrix[row][col] == "0" {
                        matrix[row][col] = solution
                        rowArray[row][col] = solution
                        colArray[col][row] = solution
                        
                        // set all other blanks in the same row, column and block to X
                        visuallyEliminateSymbol(symbol: solution)
                        
                        switch row {
                        case 0...2:
                            switch col {
                            case 0...2:
                                block1[row][col] = solution
                                // set all other blanks in the same row, column and block to X
                                visuallyEliminateSymbol(symbol: solution)
                                
                            case 3...5:
                                block2[row][col-3] = solution
                                // set all other blanks in the same row, column and block to X
                                visuallyEliminateSymbol(symbol: solution)
                                
                            case 6...8:
                                block3[row][col-6] = solution
                                // set all other blanks in the same row, column and block to X
                                visuallyEliminateSymbol(symbol: solution)
                                
                            default:
                                break
                            }
                        case 3...5:
                            switch col {
                            case 0...2:
                                block4[row-3][col] = solution
                                // set all other blanks in the same row, column and block to X
                                visuallyEliminateSymbol(symbol: solution)
                                
                            case 3...5:
                                block5[row-3][col-3] = solution
                                // set all other blanks in the same row, column and block to X
                                visuallyEliminateSymbol(symbol: solution)
                                
                            case 6...8:
                                block6[row-3][col-6] = solution
                                // set all other blanks in the same row, column and block to X
                                visuallyEliminateSymbol(symbol: solution)
                                
                            default:
                                break
                            }
                        case 6...8:
                            switch col {
                            case 0...2:
                                block7[row-6][col] = solution
                                // set all other blanks in the same row, column and block to X
                                visuallyEliminateSymbol(symbol: solution)
                                
                            case 3...5:
                                block8[row-6][col-3] = solution
                                // set all other blanks in the same row, column and block to X
                                visuallyEliminateSymbol(symbol: solution)
                                
                            case 6...8:
                                block9[row-6][col-6] = solution
                                // set all other blanks in the same row, column and block to X
                                visuallyEliminateSymbol(symbol: solution)
                                
                            default:
                                break
                            }
                        default:
                            break
                        }
                        break
                    }
                }
            }
        }
    }
    
    func replaceXWithBlank () {
        for row in 0...8 {
            for col in 0...8 {
                if matrix[row][col] == "X" {
                    matrix[row][col] = "0"
                    rowArray[row][col] = "0"
                    colArray[col][row] = "0"
                    switch row {
                    case 0...2:
                        switch col {
                        case 0...2:
                            block1[row][col] = "0"
                        case 3...5:
                            block2[row][col-3] = "0"
                        case 6...8:
                            block3[row][col-6] = "0"
                        default:
                            break
                        }
                    case 3...5:
                        switch col {
                        case 0...2:
                            block4[row-3][col] = "0"
                        case 3...5:
                            block5[row-3][col-3] = "0"
                        case 6...8:
                            block6[row-3][col-6] = "0"
                        default:
                            break
                        }
                    case 6...8:
                        switch col {
                        case 0...2:
                            block7[row-6][col] = "0"
                        case 3...5:
                            block8[row-6][col-3] = "0"
                        case 6...8:
                            block9[row-6][col-6] = "0"
                        default:
                            break
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func numberOfBlanks () -> Int {
        var blanks = 0
        for row in 0...8 {
            for col in 0...8 {
                if matrix[row][col] == "0" {
                    blanks += 1
                }
            }
        }
        return blanks
    }
    
    func numberOfCellsSolvedByVisualElimination () -> Int {
        let blanksInitial = numberOfBlanks()
        for iteration in 1...9 {
            visuallyEliminateSymbol(symbol: String(iteration))
            //print ("Check after visually eliminating \(iteration)")
            //printSudokuUsingBlocks()
            //print ("If each row, col or block contains only one 0, replace that cell with \(iteration)")
            replaceBlankWithSolution(solution: String(iteration))
            //printSudokuUsingBlocks()
            replaceXWithBlank()
            //print ("Ready for next iteration to solve \(numberOfBlanks()) blank cells: ")
            //printSudokuUsingBlocks()
        }
        let blanksFinal = numberOfBlanks()
        
        return (blanksFinal - blanksInitial)
        
    }
    
    func findCandidateCellsAtSpecifiedLocation (emptyCellRow: Int, emptyCellCol: Int) -> [[String]] {
        var candidateValues = [["1","2","3"],["4","5","6"],["7","8","9"]]
        for row in 0...2 {
            for col in 0...2 {
                if rowArray[emptyCellRow].contains(candidateValues[row][col]) || colArray[emptyCellCol].contains(candidateValues[row][col]) {
                    candidateValues[row][col] = "0"
                }
                if candidateValues[row][col] == "0" {
                    continue
                }
                switch emptyCellRow {
                case 0...2:
                    switch emptyCellCol {
                    case 0...2:
                        if checkIfBlockContainsSymbol(block: block1, symbolToCheck: candidateValues[row][col]) {
                            candidateValues[row][col] = "0"
                        }
                    case 3...5:
                        if checkIfBlockContainsSymbol(block: block2, symbolToCheck: candidateValues[row][col]) {
                            candidateValues[row][col] = "0"
                        }
                    case 6...8:
                        if checkIfBlockContainsSymbol(block: block3, symbolToCheck: candidateValues[row][col]) {
                            candidateValues[row][col] = "0"
                        }
                    default:
                        break
                    }
                case 3...5:
                    switch emptyCellCol {
                    case 0...2:
                        if checkIfBlockContainsSymbol(block: block4, symbolToCheck: candidateValues[row][col]) {
                            candidateValues[row][col] = "0"
                        }
                    case 3...5:
                        if checkIfBlockContainsSymbol(block: block5, symbolToCheck: candidateValues[row][col]) {
                            candidateValues[row][col] = "0"
                        }
                    case 6...8:
                        if checkIfBlockContainsSymbol(block: block6, symbolToCheck: candidateValues[row][col]) {
                            candidateValues[row][col] = "0"
                        }
                    default:
                        break
                    }
                case 6...8:
                    switch emptyCellCol {
                    case 0...2:
                        if checkIfBlockContainsSymbol(block: block7, symbolToCheck: candidateValues[row][col]) {
                            candidateValues[row][col] = "0"
                        }
                    case 3...5:
                        if checkIfBlockContainsSymbol(block: block8, symbolToCheck: candidateValues[row][col]) {
                            candidateValues[row][col] = "0"
                        }
                    case 6...8:
                        if checkIfBlockContainsSymbol(block: block9, symbolToCheck: candidateValues[row][col]) {
                            candidateValues[row][col] = "0"
                        }
                    default:
                        break
                    }
                default:
                    break
                }
            }
        }
        return candidateValues
    }
    
    func calculateCandidateCells () ->Int {
        let blanksInitial = numberOfBlanks()
        for row in 0...8 {
            for col in 0...8 {
                if matrix[row][col] == "0" {
                    candidatesDictionary[String(row) + String(col)] = findCandidateCellsAtSpecifiedLocation(emptyCellRow: row, emptyCellCol: col)
                }
            }
        }
        analyzeCandidateCells()
        let blanksFinal = numberOfBlanks()
        return (blanksFinal - blanksInitial)
    }
    
    func analyzeCandidateCells () {
        for row in 0...8 {
            for col in 0...8 {
                if matrix[row][col] == "0" {
                    if let candidateCells = candidatesDictionary[String(row)+String(col)] {
                        matrix[row][col] = identifyLoneSingles(candidateValues: candidateCells)
                        if (matrix[row][col] != "0") {
                            candidatesDictionary.removeValue(forKey: String(row) + String(col))
                            generateArrays()
                        }
                    }
                }
            }
        }
    }
    
    func identifyLoneSingles (candidateValues: [[String]]) -> String {
        var countOfBlanks = 0
        for row in 0...2 {
            for col in 0...2 {
                if candidateValues[row][col] == "0" {
                    countOfBlanks += 1
                }
            }
        }
        if countOfBlanks == 8 {
            for row in 0...2 {
                for col in 0...2 {
                    if candidateValues[row][col] != "0" {
                        return candidateValues[row][col]
                    }
                }
            }
        }
        return "0"
    }
    
    func populateInitialState() {
        
        generateArrays()
        
        for row in 0...8 {
            for col in 0...8 {
                if let currentCell = view.subviews[0].subviews[row].subviews[col] as? UIButton {
                    currentCell.setTitle(matrix[row][col], for: .normal)
                    currentCell.setTitleColor(UIColor.blue, for: .normal)
                    if matrix[row][col] == "0" {
                        currentCell.isEnabled = true
                    }
                    else {
                        currentCell.isEnabled = false
                    }
                }
            }
        }
        
        restoreBackgroundColor()
    }
    
    func populateUI() {
        
        generateArrays()
        
        for row in 0...8 {
            for col in 0...8 {
                if let currentCell = view.subviews[0].subviews[row].subviews[col] as? UIButton {
                    currentCell.setTitle(matrix[row][col], for: .normal)
                }
            }
        }
    }
    
    func highlightSymbol(symbol: String) {
        
        for row in 0...8 {
            for col in 0...8 {
                if let currentCell = view.subviews[0].subviews[row].subviews[col] as? UIButton {
                    currentCell.setTitle(matrix[row][col], for: .normal)
                    if matrix[row][col] == symbol {
                        currentCell.backgroundColor = UIColor.green
                    }
                }
            }
        }
    }
    
    func restoreBackgroundColor () {
        for row in 0...8 {
            for col in 0...8 {
                if let currentCell = view.subviews[0].subviews[row].subviews[col] as? UIButton {
                    switch row {
                    case 0...2:
                        switch col {
                        case 0...2:
                            currentCell.backgroundColor = UIColor.lightGray
                        case 3...5:
                            currentCell.backgroundColor = UIColor.darkGray
                        case 6...8:
                            currentCell.backgroundColor = UIColor.lightGray
                        default:
                            break
                        }
                    case 3...5:
                        switch col {
                        case 0...2:
                            currentCell.backgroundColor = UIColor.darkGray
                        case 3...5:
                            currentCell.backgroundColor = UIColor.lightGray
                        case 6...8:
                            currentCell.backgroundColor = UIColor.darkGray
                        default:
                            break
                        }
                    case 6...8:
                        switch col {
                        case 0...2:
                            currentCell.backgroundColor = UIColor.lightGray
                        case 3...5:
                            currentCell.backgroundColor = UIColor.darkGray
                        case 6...8:
                            currentCell.backgroundColor = UIColor.lightGray
                        default:
                            break
                        }
                    default:
                        break
                    }
                }
            }
        }
        
        Nine.isEnabled = true
        Eight.isEnabled = true
        Seven.isEnabled = true
        Six.isEnabled = true
        Five.isEnabled = true
        Four.isEnabled = true
        Three.isEnabled = true
        Two.isEnabled = true
        One.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        populateInitialState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var Eliminate: UIButton!
    
    
    @IBAction func EliminatePressed(_ sender: UIButton) {
        if selectedSymbol != "" {
            visuallyEliminateSymbol(symbol: selectedSymbol)
            populateUI()
            highlightSymbol(symbol: selectedSymbol)
        }
    }
    
    @IBOutlet weak var ClearXs: UIButton!
    
    
    @IBAction func ClearXsPressed(_ sender: UIButton) {
        replaceXWithBlank()
        populateUI()
        restoreBackgroundColor()
    }
    
    @IBOutlet weak var Nine: UIButton!

    @IBAction func NinePressed(_ sender: UIButton) {
        Eight.isEnabled = false
        Seven.isEnabled = false
        Six.isEnabled = false
        Five.isEnabled = false
        Four.isEnabled = false
        Three.isEnabled = false
        Two.isEnabled = false
        One.isEnabled = false
        
        selectedSymbol = "9"
    }
    
    @IBOutlet weak var Eight: UIButton!
    
    @IBAction func EightPressed(_ sender: UIButton) {
        Nine.isEnabled = false
        Seven.isEnabled = false
        Six.isEnabled = false
        Five.isEnabled = false
        Four.isEnabled = false
        Three.isEnabled = false
        Two.isEnabled = false
        One.isEnabled = false
        
        selectedSymbol = "8"
    }
    
    
    @IBOutlet weak var Seven: UIButton!
    
    
    @IBAction func SevenPressed(_ sender: UIButton) {
        Nine.isEnabled = false
        Eight.isEnabled = false
        Six.isEnabled = false
        Five.isEnabled = false
        Four.isEnabled = false
        Three.isEnabled = false
        Two.isEnabled = false
        One.isEnabled = false
        
        selectedSymbol = "7"
    }
    
    @IBOutlet weak var Six: UIButton!
    
    @IBAction func SixPressed(_ sender: UIButton) {
        Nine.isEnabled = false
        Eight.isEnabled = false
        Seven.isEnabled = false
        Five.isEnabled = false
        Four.isEnabled = false
        Three.isEnabled = false
        Two.isEnabled = false
        One.isEnabled = false
        
        selectedSymbol = "6"
    }
    
    @IBOutlet weak var Five: UIButton!
    
    
    @IBAction func FivePressed(_ sender: UIButton) {
        Nine.isEnabled = false
        Eight.isEnabled = false
        Seven.isEnabled = false
        Six.isEnabled = false
        Four.isEnabled = false
        Three.isEnabled = false
        Two.isEnabled = false
        One.isEnabled = false
        
        selectedSymbol = "5"
    }
    
    @IBOutlet weak var Four: UIButton!
    
    
    @IBAction func FourPressed(_ sender: UIButton) {
        Nine.isEnabled = false
        Eight.isEnabled = false
        Seven.isEnabled = false
        Six.isEnabled = false
        Five.isEnabled = false
        Three.isEnabled = false
        Two.isEnabled = false
        One.isEnabled = false
            
        selectedSymbol = "4"
    }
    
    @IBOutlet weak var Three: UIButton!
    
    @IBAction func ThreePressed(_ sender: UIButton) {
        Nine.isEnabled = false
        Eight.isEnabled = false
        Seven.isEnabled = false
        Six.isEnabled = false
        Five.isEnabled = false
        Four.isEnabled = false
        Two.isEnabled = false
        One.isEnabled = false
        
        selectedSymbol = "3"
    }
    
    @IBOutlet weak var Two: UIButton!
    
    @IBAction func TwoPressed(_ sender: UIButton) {
        Nine.isEnabled = false
        Eight.isEnabled = false
        Seven.isEnabled = false
        Six.isEnabled = false
        Five.isEnabled = false
        Four.isEnabled = false
        Three.isEnabled = false
        One.isEnabled = false
            
        selectedSymbol = "2"
    }
    
    @IBOutlet weak var One: UIButton!
    
    @IBAction func OnePressed(_ sender: UIButton) {
        
        Nine.isEnabled = false
        Eight.isEnabled = false
        Seven.isEnabled = false
        Six.isEnabled = false
        Five.isEnabled = false
        Four.isEnabled = false
        Three.isEnabled = false
        Two.isEnabled = false
        
        selectedSymbol = "1"
    }
    
    @IBAction func Solve(_ sender: UIButton) {
    }
    
    @IBAction func SolvePressed(_ sender: UIButton) {
        isSolvePressed = true
    }
    
    @IBOutlet var SudokuCells: [UIButton]!
    
    @IBAction func SudokuCellSelected(_ sender: UIButton) {
        
        if isSolvePressed == true && selectedSymbol != "" {
            for row in 0...8 {
                for col in 0...8 {
                    if sender == view.subviews[0].subviews[row].subviews[col] as? UIButton {
                        print ("Selected cell at: \(row) \(col) requested to be set a value of \(selectedSymbol)")
                        if solvedMatrix[row][col] == selectedSymbol {
                            matrix[row][col] = selectedSymbol
                            selectedSymbol = ""
                            populateUI()
                            restoreBackgroundColor()
                        }
                    }
                }
            }
            isSolvePressed = false
        }
    }
}

