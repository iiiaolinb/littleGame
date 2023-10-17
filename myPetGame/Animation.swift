////
////  Animation.swift
////  myPetGame
////
////  Created by Егор Худяев on 22.06.2022.
////
//
//import UIKit
//
//protocol AnimationProtocol {
//    
//}
//
//class Animation {
//    var gamePlay = GamePlay()
//    private var temporaryVariable: Model?
//    
//    func startTapOnRectAnimation(row: Int, column: Int) {
//        UIView.animate(withDuration: 0,
//                       delay: 0,
//                       options: [.curveEaseIn , .allowUserInteraction],
//                       animations: {
//            Rectangle.arrayOfRect[row][column].numberOfUnits = 10 - Rectangle.arrayOfRect[row][column].numberOfUnits
//            Rectangle.arrayOfRect[row][column].label.text = String(Rectangle.arrayOfRect[row][column].numberOfUnits)
//            self.gamePlay.addCircle(row: row, column: column)
//            GamePlay.rectWithUnits.append(Rectangle.arrayOfRect[row][column])
//        },
//                       completion: { _ in
//            Rectangle.arrayOfRect[row][column].isItTapped = true
//        })
//    }
//    
//    func firstTapOnRectAnimation(row: Int, column: Int) {
//        UIView.animate(withDuration: 0,
//                       delay: 0,
//                       options: [.curveEaseIn , .allowUserInteraction],
//                       animations: {
//            self.gamePlay.selectRect(row: row, column: column)
//            self.gamePlay.addRedArrows(row: row, column: column)
//        },
//                       completion: { _ in
//            Rectangle.arrayOfRect[row][column].isItTapped = true
//            self.temporaryVariable = Rectangle.arrayOfRect[row][column]
//        })
//    }
//    
//    func secondTapOnRectAnimation(row: Int, column: Int) {
//        let rect = self.temporaryVariable ?? Model(label: UILabel(), xPosition: 0, yPosition: 0, row: 0, column: 0, numberOfUnits: 0)
//        UIView.animate(withDuration: 0,
//                       delay: 0,
//                       options: [.curveEaseIn , .allowUserInteraction],
//                       animations: {
//            
//            //go to new area
//            if !(Rectangle.arrayOfRect[row][column].isItTapped) && (Rectangle.arrayOfRect[row][column].numberOfUnits <= rect.numberOfUnits) {
//                print("1 - units go to new rect")
//                self.gamePlay.addCircle(row: row, column: column)
//                Rectangle.arrayOfRect[row][column].numberOfUnits = rect.numberOfUnits - Rectangle.arrayOfRect[row][column].numberOfUnits
//                Rectangle.arrayOfRect[row][column].label.text = String(Rectangle.arrayOfRect[row][column].numberOfUnits)
//                Rectangle.arrayOfRect[rect.row][rect.column].numberOfUnits = 0
//                Rectangle.arrayOfRect[rect.row][rect.column].label.text = "0"
//                Rectangle.arrayOfRect[row][column].isItTapped = true
//            //wrong choise (you are too tiny)
//            } else if !(Rectangle.arrayOfRect[row][column].isItTapped) && (Rectangle.arrayOfRect[row][column].numberOfUnits > rect.numberOfUnits) {
//                print("2 - to many units for this step")
//                self.wrongChoise(row: row, column: column)
//            //tap on the same rect
//            } else if ((row == rect.row) && (column == rect.column)) {
//                self.clearArea(Rectangle.arrayOfRect[row][column])
//            //go to area with alias
//            } else {
//                print("3 - units go to alies rect")
//                Rectangle.arrayOfRect[row][column].numberOfUnits = rect.numberOfUnits + Rectangle.arrayOfRect[row][column].numberOfUnits
//                Rectangle.arrayOfRect[row][column].label.text = String(Rectangle.arrayOfRect[row][column].numberOfUnits)
//                Rectangle.arrayOfRect[rect.row][rect.column].numberOfUnits = 0
//                Rectangle.arrayOfRect[rect.row][rect.column].label.text = "0"
//            }
//        },
//                       completion: { _ in
//            print("second tap")
//        })
//    }
//    
//    func clearArea(_ rect: Model) {
//        UIView.animate(withDuration: 0,
//                       delay: 0,
//                       options: [.curveEaseIn , .allowUserInteraction],
//                       animations: {
//            rect.label.backgroundColor = Constant.ColorOfEntities.neutrals
//            self.gamePlay.removeRedArrow()
//        },
//                       completion: nil)
//    }
//    
//    func upgrade(row: Int, column: Int) {
//        if Rectangle.arrayOfRect[row][column].numberOfUnits >= Rectangle.arrayOfRect[row][column].costOfUpgrade {
//            gamePlay.upgrade(row: row, column: column)
//            UIView.animate(withDuration: 0,
//                           delay: 0,
//                           options: [.curveEaseIn , .allowUserInteraction],
//                           animations: {
//                Rectangle.arrayOfRect[row][column].label.alpha += 0.1
//            },
//                           completion: nil)
//        } else {
//            wrongChoise(row: row, column: column)
//        }
//        
//    }
//    
//    func wrongChoise(row: Int, column: Int) {
//        let text = UILabel(frame: CGRect(x: 50, y: 100, width: 100, height: 50))
//        text.textColor = .red
//        //text.text = "wrong tap"
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       options: [.allowUserInteraction],
//                       animations: {
//            Rectangle.floor.addSubview(text)
//            Rectangle.floor.backgroundColor = .red
//            //Rectangle.arrayOfRect[row][column].label.backgroundColor = .red
//        },
//                       completion: { _ in
//            UIView.animate(withDuration: 0.5,
//                           delay: 0,
//                           options: [.allowUserInteraction],
//                           animations: {
//                text.removeFromSuperview()
//                Rectangle.floor.backgroundColor = .clear
//                //Rectangle.arrayOfRect[row][column].label.backgroundColor = Constant.ColorOfEntities.neutrals
//            },
//                           completion: nil
//        )})
//    }
//    
//    func clearButtlefield() {
//        gamePlay.clearBattlefield()
//    }
//    
//    func arrivalTheUnitsAnimation() {
//        UIView.animate(withDuration: 1,
//                       delay: 0,
//                       options: [.curveEaseIn , .allowUserInteraction],
//                       animations: {
//            self.gamePlay.arrivalTheUnits()
//        },
//                       completion: nil)
//        
//    }
//    
//    func upgradeAnimation() {
//        
//    }
//}
//
