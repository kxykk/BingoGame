//
//  BingoButton.swift
//  bingo
//
//  Created by 康 on 2023/11/2.
//

import UIKit

protocol isPressed {
    var isPressed: Bool { get set }
}

class BingoButton: UIButton, isPressed {
    var isPressed = false
}

