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
    
    var rectangle = Rectangle()
    
    func selectRect(row: Int, column: Int) {
        rectangle.arrayOfRect[row][column].label.backgroundColor = Constant.ColorOfEntities.alliesRect
    }
    
    func addCircle(row: Int, column: Int) {
        let circle = Shape.circles().greenCircle
        circle.frame = CGRect(x: 0, y: 0, width: rectangle.rectSide, height: rectangle.rectSide)
        circle.alpha = 0.5
        rectangle.arrayOfRect[row][column].label.addSubview(circle)
    }
    
//    func addNumberOfUnits(row: Int, column: Int) {
//        Rectangle.arrayOfRect[row][column].numberOfUnits = 10 - Rectangle.arrayOfRect[row][column].numberOfUnits
//        Rectangle.arrayOfRect[row][column].label.text = String(Rectangle.arrayOfRect[row][column].numberOfUnits)
//    }
    
    func arrivalTheUnits() {
        for rect in rectWithBarraks {
            rectangle.arrayOfRect[rect.row][rect.column].numberOfUnits += rect.baracsLevel
            rectangle.arrayOfRect[rect.row][rect.column].label.text = String(rectangle.arrayOfRect[rect.row][rect.column].numberOfUnits)
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
    
    func addRedArrows(row: Int, column: Int) {
        let rect = rectangle.arrayOfRect[row][column]
        
        arrows.downArrowView.frame = CGRect(x: rect.xPosition, y: rect.yPosition + (rectangle.rectSide/2), width: rectangle.rectSide, height: rectangle.rectSide)
        arrows.rightArrowView.frame = CGRect(x: rect.xPosition + (rectangle.rectSide/2), y: rect.yPosition, width: rectangle.rectSide, height: rectangle.rectSide)
        arrows.upArrowView.frame = CGRect(x: rect.xPosition, y: rect.yPosition - (rectangle.rectSide/2), width: rectangle.rectSide, height: rectangle.rectSide)
        arrows.leftArrowView.frame = CGRect(x: rect.xPosition - (rectangle.rectSide/2), y: rect.yPosition, width: rectangle.rectSide, height: rectangle.rectSide)
        
        //левый верхний угол
        if row == rectangle.arrayOfRect.startIndex && column == rectangle.arrayOfRect[row].startIndex {
            canAddDownArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.downArrowView) : nil
            canAddRightArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.rightArrowView) : nil
        //левый нижний угол
        } else if row == rectangle.arrayOfRect.startIndex && column == rectangle.arrayOfRect[row].endIndex-1 {
            canAddRightArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.rightArrowView) : nil
            canAddUpArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.upArrowView) : nil
        //правый верхний угол
        } else if row == rectangle.arrayOfRect.endIndex-1 && column == rectangle.arrayOfRect[row].startIndex {
            canAddDownArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.downArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.leftArrowView) : nil
        //правый нижний угол
        } else if row == rectangle.arrayOfRect.endIndex-1 && column == rectangle.arrayOfRect[row].endIndex-1 {
            canAddUpArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.upArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.leftArrowView) : nil
        //левая граница
        } else if row == rectangle.arrayOfRect.startIndex {
            canAddDownArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.downArrowView) : nil
            canAddRightArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.rightArrowView) : nil
            canAddUpArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.upArrowView) : nil
        //правая граница
        } else if row == rectangle.arrayOfRect.endIndex-1 {
            canAddDownArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.downArrowView) : nil
            canAddUpArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.upArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.leftArrowView) : nil
        //верхняя граница
        } else if column == rectangle.arrayOfRect[row].startIndex {
            canAddDownArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.downArrowView) : nil
            canAddRightArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.rightArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.leftArrowView) : nil
        //нижняя граница
        } else if column == rectangle.arrayOfRect[row].endIndex-1 {
            canAddRightArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.rightArrowView) : nil
            canAddUpArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.upArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.leftArrowView) : nil
        //остальное поле
        } else {
            canAddDownArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.downArrowView) : nil
            canAddRightArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.rightArrowView) : nil
            canAddUpArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.upArrowView) : nil
            canAddLeftArrow(row: row, column: column) ? rectangle.floor.addSubview(arrows.leftArrowView) : nil
        }
    }
    
    func canAddDownArrow(row: Int, column: Int) -> Bool {
        (rectangle.arrayOfRect[row][column].numberOfUnits >= rectangle.arrayOfRect[row][column+1].numberOfUnits)  || (rectWithBarraks.contains(rectangle.arrayOfRect[row][column+1])) ? true : false
    }
    
    func canAddUpArrow(row: Int, column: Int) -> Bool {
        (rectangle.arrayOfRect[row][column].numberOfUnits >= rectangle.arrayOfRect[row][column-1].numberOfUnits) || (rectWithBarraks.contains(rectangle.arrayOfRect[row][column-1])) ? true : false
    }
    
    func canAddRightArrow(row: Int, column: Int) -> Bool {
        (rectangle.arrayOfRect[row][column].numberOfUnits >= rectangle.arrayOfRect[row+1][column].numberOfUnits) || (rectWithBarraks.contains(rectangle.arrayOfRect[row+1][column])) ? true : false
    }
    
    func canAddLeftArrow(row: Int, column: Int) -> Bool {
        (rectangle.arrayOfRect[row][column].numberOfUnits >= rectangle.arrayOfRect[row-1][column].numberOfUnits) || (rectWithBarraks.contains(rectangle.arrayOfRect[row-1][column])) ? true : false
    }
    
    func addStar(row: Int, column: Int) {
        let star = Shape.stars().goldStar
        star.frame = CGRect(x: 0, y: 0, width: rectangle.rectSide, height: rectangle.rectSide)
        star.alpha = 0.5
        let itemForDelete = rectangle.arrayOfRect[row][column].label.subviews
        for item in itemForDelete {
            item.removeFromSuperview()
        }
        rectangle.arrayOfRect[row][column].label.addSubview(star)
    }
    
    func removeRedArrow() {
        arrows.rightArrowView.removeFromSuperview()
        arrows.downArrowView.removeFromSuperview()
        arrows.leftArrowView.removeFromSuperview()
        arrows.upArrowView.removeFromSuperview()
    }
    
    func upgrade(row: Int, column: Int) {
        if rectWithBarraks.contains(rectangle.arrayOfRect[row][column]) {
            rectangle.arrayOfRect[row][column].numberOfUnits -= rectangle.arrayOfRect[row][column].costOfUpgrade
            rectangle.arrayOfRect[row][column].label.text = String(rectangle.arrayOfRect[row][column].numberOfUnits)
            rectangle.arrayOfRect[row][column].baracsLevel += 1
            //добавить изменение общего количества юнитов
        } else {
            rectWithBarraks.append(Model.init(label: UILabel(),
                                                               xPosition: rectangle.arrayOfRect[row][column].xPosition,
                                                               yPosition: rectangle.arrayOfRect[row][column].yPosition,
                                                               row: row,
                                                               column: column,
                                                               numberOfUnits: rectangle.arrayOfRect[row][column].numberOfUnits,
                                                               baracsLevel: rectangle.arrayOfRect[row][column].baracsLevel + 1,
                                                               costOfUpgrade: rectangle.arrayOfRect[row][column].costOfUpgrade,
                                                               isItTapped: false))
            rectangle.arrayOfRect[row][column].numberOfUnits -= rectangle.arrayOfRect[row][column].costOfUpgrade
            rectangle.arrayOfRect[row][column].label.text = String(rectangle.arrayOfRect[row][column].numberOfUnits)
            //добавить изменение общего количества юнитов
            addStar(row: row, column: column)
        }
        increaseTheCostOfUpgrade(&rectangle.arrayOfRect[row][column])
        print("rect with barraks - \(rectWithBarraks.count)")
    }
    
    func clearBattlefield() {
        for row in 0..<5 {
            for column in 0..<10 {
                rectangle.arrayOfRect[row][column].label.removeFromSuperview()
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
