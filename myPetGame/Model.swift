//
//  ViewModel.swift
//  myPetGame
//
//  Created by Егор Худяев on 21.06.2022.
//

import Foundation
import UIKit

struct Model: Equatable {
    let label: UILabel
    let xPosition: Int
    let yPosition: Int
    let row: Int
    let column: Int
    var numberOfUnits: Int
    var baracsLevel: Int = 0
    var costOfUpgrade: Int = 2
    var isItTapped: Bool = false
}
