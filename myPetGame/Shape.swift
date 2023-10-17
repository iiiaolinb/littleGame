//
//  Shape.swift
//  myPetGame
//
//  Created by Егор Худяев on 22.06.2022.
//

import UIKit

struct Shape {
    struct circles {
        let greenCircle = UIImageView(image: UIImage(named: Constant.NameOfPicture.greenCircle))
        let redCircle = UIImageView(image: UIImage(named: Constant.NameOfPicture.redCircle))
    }
    
    struct arrows {
        let downArrowView = UIImageView(image: UIImage(named: Constant.NameOfPicture.redArrowDown))
        let rightArrowView = UIImageView(image: UIImage(named: Constant.NameOfPicture.redArrowRight))
        let upArrowView = UIImageView(image: UIImage(named: Constant.NameOfPicture.redArrowUp))
        let leftArrowView = UIImageView(image: UIImage(named: Constant.NameOfPicture.redArrowLeft))
    }
    
    struct stars {
        let blueStar = UIImageView(image: UIImage(named: Constant.NameOfPicture.blueStar))
        let goldStar = UIImageView(image: UIImage(named: Constant.NameOfPicture.goldStar))
    }
}
