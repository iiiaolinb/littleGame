//
//  GamePlay.swift
//  myPetGame
//
//  Created by Егор Худяев on 22.06.2022.
//

import UIKit

protocol GamePlayProtocol {
    
}

class GamePlay: GamePlayProtocol {
    let arrows = Shape.arrows()
    var variantsOfMoves: Int = 1
    var countOfUnits: Int = 10
    var rectWithUnits = [Model]()
    var rectWithBarraks = [Model]()
	var arrayOfRect = [[Model]]()
	let rectSide = Constant.SizeAndPoint.rectSide
   // var rectangle = Rectangle()
    
	func selectRect(_ rectangle: Model) {
		rectangle.label.backgroundColor = Constant.ColorOfEntities.alliesRect
    }
    
	func addCircle(_ rectangle: Model) {
		let circle = Shape.circles().greenCircle
		circle.frame = CGRect(x: 0, y: 0, width: rectSide, height: rectSide)
		circle.alpha = 0.5
		rectangle.label.addSubview(circle)
	}
    
    func arrivalTheUnits() {
        for rect in rectWithBarraks {
            arrayOfRect[rect.row][rect.column].numberOfUnits += rect.baracsLevel
            arrayOfRect[rect.row][rect.column].label.text = String(arrayOfRect[rect.row][rect.column].numberOfUnits)
        }
    }
    
    func calculateAllUnits() -> Int {
        var unitsCount = 0
        for rect in rectWithBarraks {
            unitsCount += rect.numberOfUnits
        }
        for rect in rectWithUnits {
            unitsCount += rect.numberOfUnits
        }
        return unitsCount
    }
    
	func addRedArrows(row: Int, column: Int, floor: UILabel) {
        let rect = arrayOfRect[row][column]
        
        arrows.downArrowView.frame = CGRect(x: rect.xPosition, y: rect.yPosition + (rectSide/2), width: rectSide, height: rectSide)
        arrows.rightArrowView.frame = CGRect(x: rect.xPosition + (rectSide/2), y: rect.yPosition, width: rectSide, height: rectSide)
        arrows.upArrowView.frame = CGRect(x: rect.xPosition, y: rect.yPosition - (rectSide/2), width: rectSide, height: rectSide)
        arrows.leftArrowView.frame = CGRect(x: rect.xPosition - (rectSide/2), y: rect.yPosition, width: rectSide, height: rectSide)
        
        //левый верхний угол
        if row == arrayOfRect.startIndex && column == arrayOfRect[row].startIndex {
            canAddDownArrow(row: row, column: column) ? floor.addSubview(arrows.downArrowView) : nil
            canAddRightArrow(row: row, column: column) ? floor.addSubview(arrows.rightArrowView) : nil
        //левый нижний угол
        } else if row == arrayOfRect.startIndex && column == arrayOfRect[row].endIndex-1 {
            canAddRightArrow(row: row, column: column) ? floor.addSubview(arrows.rightArrowView) : nil
            canAddUpArrow(row: row, column: column) ? floor.addSubview(arrows.upArrowView) : nil
        //правый верхний угол
        } else if row == arrayOfRect.endIndex-1 && column == arrayOfRect[row].startIndex {
            canAddDownArrow(row: row, column: column) ? floor.addSubview(arrows.downArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? floor.addSubview(arrows.leftArrowView) : nil
        //правый нижний угол
        } else if row == arrayOfRect.endIndex-1 && column == arrayOfRect[row].endIndex-1 {
            canAddUpArrow(row: row, column: column) ? floor.addSubview(arrows.upArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? floor.addSubview(arrows.leftArrowView) : nil
        //левая граница
        } else if row == arrayOfRect.startIndex {
            canAddDownArrow(row: row, column: column) ? floor.addSubview(arrows.downArrowView) : nil
            canAddRightArrow(row: row, column: column) ? floor.addSubview(arrows.rightArrowView) : nil
            canAddUpArrow(row: row, column: column) ? floor.addSubview(arrows.upArrowView) : nil
        //правая граница
        } else if row == arrayOfRect.endIndex-1 {
            canAddDownArrow(row: row, column: column) ? floor.addSubview(arrows.downArrowView) : nil
            canAddUpArrow(row: row, column: column) ? floor.addSubview(arrows.upArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? floor.addSubview(arrows.leftArrowView) : nil
        //верхняя граница
        } else if column == arrayOfRect[row].startIndex {
            canAddDownArrow(row: row, column: column) ? floor.addSubview(arrows.downArrowView) : nil
            canAddRightArrow(row: row, column: column) ? floor.addSubview(arrows.rightArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? floor.addSubview(arrows.leftArrowView) : nil
        //нижняя граница
        } else if column == arrayOfRect[row].endIndex-1 {
            canAddRightArrow(row: row, column: column) ? floor.addSubview(arrows.rightArrowView) : nil
            canAddUpArrow(row: row, column: column) ? floor.addSubview(arrows.upArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? floor.addSubview(arrows.leftArrowView) : nil
        //остальное поле
        } else {
            canAddDownArrow(row: row, column: column) ? floor.addSubview(arrows.downArrowView) : nil
            canAddRightArrow(row: row, column: column) ? floor.addSubview(arrows.rightArrowView) : nil
            canAddUpArrow(row: row, column: column) ? floor.addSubview(arrows.upArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? floor.addSubview(arrows.leftArrowView) : nil
        }
    }
    
    func canAddDownArrow(row: Int, column: Int) -> Bool {
        (arrayOfRect[row][column].numberOfUnits >= arrayOfRect[row][column+1].numberOfUnits)  || (rectWithBarraks.contains(arrayOfRect[row][column+1])) ? true : false
    }
    
    func canAddUpArrow(row: Int, column: Int) -> Bool {
        (arrayOfRect[row][column].numberOfUnits >= arrayOfRect[row][column-1].numberOfUnits) || (rectWithBarraks.contains(arrayOfRect[row][column-1])) ? true : false
    }
    
    func canAddRightArrow(row: Int, column: Int) -> Bool {
        (arrayOfRect[row][column].numberOfUnits >= arrayOfRect[row+1][column].numberOfUnits) || (rectWithBarraks.contains(arrayOfRect[row+1][column])) ? true : false
    }
    
    func canAddLeftArrow(row: Int, column: Int) -> Bool {
        (arrayOfRect[row][column].numberOfUnits >= arrayOfRect[row-1][column].numberOfUnits) || (rectWithBarraks.contains(arrayOfRect[row-1][column])) ? true : false
    }
    
    func addStar(row: Int, column: Int) {
        let star = Shape.stars().goldStar
        star.frame = CGRect(x: 0, y: 0, width: rectSide, height: rectSide)
        star.alpha = 0.5
        let itemForDelete = arrayOfRect[row][column].label.subviews
        for item in itemForDelete {
            item.removeFromSuperview()
        }
        arrayOfRect[row][column].label.addSubview(star)
    }
    
    func removeRedArrow() {
        arrows.rightArrowView.removeFromSuperview()
        arrows.downArrowView.removeFromSuperview()
        arrows.leftArrowView.removeFromSuperview()
        arrows.upArrowView.removeFromSuperview()
    }
    
    func upgrade(row: Int, column: Int) {
        if rectWithBarraks.contains(arrayOfRect[row][column]) {
            arrayOfRect[row][column].numberOfUnits -= arrayOfRect[row][column].costOfUpgrade
            arrayOfRect[row][column].label.text = String(arrayOfRect[row][column].numberOfUnits)
            arrayOfRect[row][column].baracsLevel += 1
            //добавить изменение общего количества юнитов
        } else {
            rectWithBarraks.append(Model.init(label: UILabel(),
                                                               xPosition: arrayOfRect[row][column].xPosition,
                                                               yPosition: arrayOfRect[row][column].yPosition,
                                                               row: row,
                                                               column: column,
                                                               numberOfUnits: arrayOfRect[row][column].numberOfUnits,
                                                               baracsLevel: arrayOfRect[row][column].baracsLevel + 1,
                                                               costOfUpgrade: arrayOfRect[row][column].costOfUpgrade,
                                                               isItTapped: false))
            arrayOfRect[row][column].numberOfUnits -= arrayOfRect[row][column].costOfUpgrade
            arrayOfRect[row][column].label.text = String(arrayOfRect[row][column].numberOfUnits)
            //добавить изменение общего количества юнитов
            addStar(row: row, column: column)
        }
        increaseTheCostOfUpgrade(&arrayOfRect[row][column])
        print("rect with barraks - \(rectWithBarraks.count)")
    }
    
    func clearBattlefield() {
        for row in 0..<5 {
            for column in 0..<10 {
                arrayOfRect[row][column].label.removeFromSuperview()
            }
        }
        removeRedArrow()
    }
    
    private func increaseTheCostOfUpgrade( _ rect: inout Model) {
        rect.costOfUpgrade *= 2
    }
}


//доработать: показывать не только количество ходов, но еще и количество всех юнитов
// - при добавлении в rectWithBarracs добавляется 2 элемента (а должен быть 1)
// -
//
//переделать: нормальное разделение на VM и M
// - убрать static свойства и методы
