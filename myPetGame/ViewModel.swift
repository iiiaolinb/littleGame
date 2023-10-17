import Foundation
import UIKit

class ViewModel {
    var battlefield: Rectangle
    //var animation = Animation()
    var selectedRect = Model(label: UILabel(), xPosition: 0, yPosition: 0, row: 0, column: 0, numberOfUnits: 0)
    var countOfTap = -1
    var isItRight: Bool = false
    
    var gamePlay = GamePlay()

    //private var temporaryVariable: Model?
    
    init(wthView view: UIViewController) {
        battlefield = Rectangle(withView: view)
    }
    
    func startTapOnRect(row: Int, column: Int) {
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: [.curveEaseIn , .allowUserInteraction],
                       animations: {
            self.battlefield.arrayOfRect[row][column].numberOfUnits = 10 - self.battlefield.arrayOfRect[row][column].numberOfUnits
            self.battlefield.arrayOfRect[row][column].label.text = String(self.battlefield.arrayOfRect[row][column].numberOfUnits)
            self.gamePlay.addCircle(row: row, column: column)
            self.gamePlay.rectWithUnits.append(self.battlefield.arrayOfRect[row][column])
        },
                       completion: { _ in
            self.battlefield.arrayOfRect[row][column].isItTapped = true
        })
    }
    
    func firstTapOnRect(row: Int, column: Int) {
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: [.curveEaseIn , .allowUserInteraction],
                       animations: {
            self.gamePlay.selectRect(row: row, column: column)
            self.gamePlay.addRedArrows(row: row, column: column)
        },
                       completion: { _ in
            self.battlefield.arrayOfRect[row][column].isItTapped = true
            self.temporaryVariable = self.battlefield.arrayOfRect[row][column]
        })
    }
    
    func secondTapOnRect(row: Int, column: Int) {
        let rect = self.temporaryVariable ?? Model(label: UILabel(), xPosition: 0, yPosition: 0, row: 0, column: 0, numberOfUnits: 0)
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: [.curveEaseIn , .allowUserInteraction],
                       animations: {
            
            //go to new area
            if !(self.battlefield.arrayOfRect[row][column].isItTapped) && (self.battlefield.arrayOfRect[row][column].numberOfUnits <= rect.numberOfUnits) {
                print("1 - units go to new rect")
                self.gamePlay.addCircle(row: row, column: column)
                self.battlefield.arrayOfRect[row][column].numberOfUnits = rect.numberOfUnits - self.battlefield.arrayOfRect[row][column].numberOfUnits
                self.battlefield.arrayOfRect[row][column].label.text = String(self.battlefield.arrayOfRect[row][column].numberOfUnits)
                self.battlefield.arrayOfRect[rect.row][rect.column].numberOfUnits = 0
                self.battlefield.arrayOfRect[rect.row][rect.column].label.text = "0"
                self.battlefield.arrayOfRect[row][column].isItTapped = true
            //wrong choise (you are too tiny)
            } else if !(self.battlefield.arrayOfRect[row][column].isItTapped) && (self.battlefield.arrayOfRect[row][column].numberOfUnits > rect.numberOfUnits) {
                print("2 - to many units for this step")
                self.wrongChoise(row: row, column: column)
            //tap on the same rect
            } else if ((row == rect.row) && (column == rect.column)) {
                self.clearArea(self.battlefield.arrayOfRect[row][column])
            //go to area with alias
            } else {
                print("3 - units go to alies rect")
                self.battlefield.arrayOfRect[row][column].numberOfUnits = rect.numberOfUnits + self.battlefield.arrayOfRect[row][column].numberOfUnits
                self.battlefield.arrayOfRect[row][column].label.text = String(self.battlefield.arrayOfRect[row][column].numberOfUnits)
                self.battlefield.arrayOfRect[rect.row][rect.column].numberOfUnits = 0
                self.battlefield.arrayOfRect[rect.row][rect.column].label.text = "0"
            }
        },
                       completion: { _ in
            print("second tap")
        })
    }
    
    func clearArea(_ rect: Model) {
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: [.curveEaseIn , .allowUserInteraction],
                       animations: {
            rect.label.backgroundColor = Constant.ColorOfEntities.neutrals
            self.gamePlay.removeRedArrow()
        },
                       completion: nil)
    }
    
    func upgrade(row: Int, column: Int) {
        if battlefield.arrayOfRect[row][column].numberOfUnits >= battlefield.arrayOfRect[row][column].costOfUpgrade {
            gamePlay.upgrade(row: row, column: column)
            UIView.animate(withDuration: 0,
                           delay: 0,
                           options: [.curveEaseIn , .allowUserInteraction],
                           animations: {
                self.battlefield.arrayOfRect[row][column].label.alpha += 0.1
            },
                           completion: nil)
        } else {
            wrongChoise(row: row, column: column)
        }
        
    }
    
    func wrongChoise(row: Int, column: Int) {
        let text = UILabel(frame: CGRect(x: 50, y: 100, width: 100, height: 50))
        text.textColor = .red
        //text.text = "wrong tap"
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.allowUserInteraction],
                       animations: {
            self.battlefield.floor.addSubview(text)
            self.battlefield.floor.backgroundColor = .red
            //battlefield.arrayOfRect[row][column].label.backgroundColor = .red
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: [.allowUserInteraction],
                           animations: {
                text.removeFromSuperview()
                self.battlefield.floor.backgroundColor = .clear
                //battlefield.arrayOfRect[row][column].label.backgroundColor = Constant.ColorOfEntities.neutrals
            },
                           completion: nil
        )})
    }
    
    func clearButtlefield() {
        gamePlay.clearBattlefield()
    }
    
    func arrivalTheUnits() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.curveEaseIn , .allowUserInteraction],
                       animations: {
            self.gamePlay.arrivalTheUnits()
        },
                       completion: nil)
        
    }
}
