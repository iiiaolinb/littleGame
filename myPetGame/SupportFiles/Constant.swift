//
//  Constraints.swift
//  myPetGame
//
//  Created by Егор Худяев on 23.05.2022.
//

import UIKit

enum Constant {
	enum SizeAndPoint {
		static var rectSide = Int(UIScreen.main.bounds.size.height - 200) / 10
		static var startPoint = CGPoint(x: (Int(UIScreen.main.bounds.size.width) - rectSide * 5) / 2, y: 100)
	}
	
    enum Font {
        static var rectText: UIFont {
            UIFont.systemFont(ofSize: 11, weight: .regular)
        }
        
        static var menuText: UIFont {
            UIFont.systemFont(ofSize: 15, weight: .bold)
        }
    }

    enum ColorOfText {
        static let allies = UIColor.black
        static let neutrals = UIColor.systemGray
    }

    enum ColorOfEntities {
        static let alliesRect = UIColor.systemGreen
        static let neutrals = UIColor.systemGray4
        static let enemysRect = UIColor.systemRed
    }
    
    enum NameOfPicture {
        static let greenCircle = "greenCircle"
        static let redCircle = "redCircle"
        static let redArrowUp = "redArrowUp"
        static let redArrowDown = "redArrowDown"
        static let redArrowLeft = "redArrowLeft"
        static let redArrowRight = "redArrowRight"
        static let blueStar = "blue_star"
        static let goldStar = "gold_star"
    }
}
