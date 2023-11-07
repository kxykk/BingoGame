//
//  ViewController.swift
//  bingo
//
//  Created by 康 on 2023/11/2.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

//    @IBOutlet var bingoButtons: [BingoButton]!
    @IBOutlet weak var bingoCollectionView: UICollectionView!
    
    let edgeCount = 5
    var numbers: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bingoCollectionView.delegate = self
        bingoCollectionView.dataSource = self
        bingoCollectionView.allowsMultipleSelection = true
        initializeGames()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return edgeCount * edgeCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bingoCell", for: indexPath) as! BingoCell
        if numbers != [] {
            let number = numbers[indexPath.row]
            cell.bingoCellLabel.text = String(number)
            cell.backgroundColor = UIColor.lightGray
            cell.isPressed = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = 10
        let totalSpacing = spacing * edgeCount
        let sideLength = (collectionView.bounds.width - CGFloat(totalSpacing)) / CGFloat(edgeCount)
        return CGSize(width: sideLength, height: sideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BingoCell else {
            return
        }
        cell.backgroundColor = UIColor.green
        var count = 0
        let totalCount = edgeCount * edgeCount
        
        // Check rows
        for row in stride(from: 0, through: totalCount-1, by: edgeCount) {
            var rowIsBingo = true
            for column in 0..<edgeCount {
                let indexPath = IndexPath(item: column + row, section: 0)
                if let bingoCell = collectionView.cellForItem(at: indexPath), !bingoCell.isSelected {
                    rowIsBingo = false
                    break
                }
            }
            if rowIsBingo {
                count += 1
            }
        }
        
        // Check columns
        for column in 0..<edgeCount {
            var columnIsBingo = true
            for row in stride(from: column, through: totalCount-1, by: edgeCount) {
                let indexPath = IndexPath(item: row, section: 0)
                if let bingoCell = collectionView.cellForItem(at: indexPath), !bingoCell.isSelected {
                    columnIsBingo = false
                    break
                }
            }
            if columnIsBingo {
                count += 1
            }
        }
        
        // Check major diagonal
        var majorDiagonalIsBingo = true
        for index in stride(from: 0, through: totalCount-1, by: edgeCount+1) {
            let indexPath = IndexPath(item: index, section: 0)
            if let bingoCell = collectionView.cellForItem(at: indexPath), !bingoCell.isSelected {
                majorDiagonalIsBingo = false
                break
            }
        }
        if majorDiagonalIsBingo {
            count += 1
        }
        
        // Check minor diagonal
        var minorDiagonalIsBingo = true
        for index in stride(from: edgeCount-1, through: totalCount-edgeCount, by: edgeCount-1) {
            let indexPath = IndexPath(item: index, section: 0)
            if let bingoCell = collectionView.cellForItem(at: indexPath), !bingoCell.isSelected {
                minorDiagonalIsBingo = false
                break
            }
        }
        if minorDiagonalIsBingo {
            count += 1
        }
        
        print("Bingo Lines: \(count)")
        if count >= 2 {
            winGameAlert()
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BingoCell else {
                return
            }
        cell.backgroundColor = UIColor.lightGray
    }
    
    private func createRandomNumber() -> [Int]{
        // Create random number
        let totalNumber = edgeCount * edgeCount
        var numbers = Array(1...totalNumber)
        numbers = Array(numbers.shuffled().prefix(upTo: totalNumber))
        return numbers
    }
    
    private func initializeGames() {
        numbers = createRandomNumber()
        bingoCollectionView.reloadData()
    }
    
    private func winGameAlert() {
        let alert = UIAlertController(title: "Congrtulation!", message: "You win!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {[weak self] _ in
            self?.initializeGames()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
