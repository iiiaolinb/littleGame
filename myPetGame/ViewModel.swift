import Foundation
import UIKit

class ViewModel {
   // var battlefield: Rectangle
    //var animation = Animation()
    var selectedRect = Model(label: UILabel(), xPosition: 0, yPosition: 0, row: 0, column: 0, numberOfUnits: 0)
    var countOfTap = -1
    var isItRight: Bool = false
    
    var gamePlay = GamePlay()
	
//	var arrayOfRect = [[Model]]()
	
//	var rectWithUnits = [Model]()
//	var rectWithBarraks = [Model]()

    private var temporaryVariable: Model?
	
	init() {}
	
	func createRect() {
		var x: Int = 0
		var y: Int = 0
		var array = [[Model]]()
		for horizontal in 0..<5 {
			var column = [Model]()
			var randomNumber: Int = 0
			for vertical in 0..<10 {
				lazy var label: UILabel = {
					let frame = CGRect(x: Int(Constant.SizeAndPoint.startPoint.x) + x,
									   y: Int(Constant.SizeAndPoint.startPoint.y) + y,
									   width: Constant.SizeAndPoint.rectSide,
									   height: Constant.SizeAndPoint.rectSide)
					let label = UILabel(frame: frame)
					label.backgroundColor = Constant.ColorOfEntities.neutrals
					label.layer.borderWidth = 2
					label.textAlignment = .center
					label.numberOfLines = 0
					randomNumber = Int.random(in: 1...10)
					label.text = "\(randomNumber)"
					return label
				}()
				column.append(Model(label: label,
											xPosition: x,
											yPosition: y,
											row: horizontal,
											column: vertical,
											numberOfUnits: randomNumber))
				y += Constant.SizeAndPoint.rectSide
			}
			array.append(column)
			column.removeAll()
			x += Constant.SizeAndPoint.rectSide
			y = 0
		}
			gamePlay.arrayOfRect = array
	}
	
//	func drowRect(inView view: UIViewController) {
//		createRect()
//		
//		arrayOfRect.forEach { labels in
//			labels.forEach { label in
//				view.view.addSubview(label.label)
//			}
//		}
//		view.view.addSubview(floor)
//	}
	
	func pickUpCoordinates(ofRect rect: Model) -> (Int, Int){
		let coord = (rect.xPosition, rect.yPosition)
		return coord
	}
    
	func startTapOnRect(_ selectedRect: Model) {
		
		self.selectedRect = selectedRect
		//gamePlay.rectWithUnits.append(selectedRect)
		countOfTap += 1
		
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: [.curveEaseIn , .allowUserInteraction],
                       animations: {
			self.gamePlay.arrayOfRect[selectedRect.row][selectedRect.column].numberOfUnits = 10 - self.gamePlay.arrayOfRect[selectedRect.row][selectedRect.column].numberOfUnits
			self.gamePlay.arrayOfRect[selectedRect.row][selectedRect.column].label.text = String(self.gamePlay.arrayOfRect[selectedRect.row][selectedRect.column].numberOfUnits)
			self.gamePlay.addCircle(self.selectedRect)
			self.gamePlay.rectWithUnits.append(self.gamePlay.arrayOfRect[selectedRect.row][selectedRect.column])
        },
                       completion: { _ in
			self.gamePlay.arrayOfRect[selectedRect.row][selectedRect.column].isItTapped = true
        })
    }
    
	func firstTapOnRect(row: Int, column: Int, floor: UILabel) {
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: [.curveEaseIn , .allowUserInteraction],
                       animations: {
			self.gamePlay.selectRect(self.selectedRect)
            self.gamePlay.addRedArrows(row: row, column: column, floor: floor)
        },
                       completion: { _ in
            self.gamePlay.arrayOfRect[row][column].isItTapped = true
            self.temporaryVariable = self.gamePlay.arrayOfRect[row][column]
        })
    }
    
	func secondTapOnRect(row: Int, column: Int, floor: UILabel) {
        let rect = self.temporaryVariable ?? Model(label: UILabel(), xPosition: 0, yPosition: 0, row: 0, column: 0, numberOfUnits: 0)
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: [.curveEaseIn , .allowUserInteraction],
                       animations: {
            
            //go to new area
            if !(self.gamePlay.arrayOfRect[row][column].isItTapped) && (self.gamePlay.arrayOfRect[row][column].numberOfUnits <= rect.numberOfUnits) {
                print("1 - units go to new rect")
				self.gamePlay.addCircle(self.selectedRect)
                self.gamePlay.arrayOfRect[row][column].numberOfUnits = rect.numberOfUnits - self.gamePlay.arrayOfRect[row][column].numberOfUnits
                self.gamePlay.arrayOfRect[row][column].label.text = String(self.gamePlay.arrayOfRect[row][column].numberOfUnits)
                self.gamePlay.arrayOfRect[rect.row][rect.column].numberOfUnits = 0
                self.gamePlay.arrayOfRect[rect.row][rect.column].label.text = "0"
                self.gamePlay.arrayOfRect[row][column].isItTapped = true
            //wrong choise (you are too tiny)
            } else if !(self.gamePlay.arrayOfRect[row][column].isItTapped) && (self.gamePlay.arrayOfRect[row][column].numberOfUnits > rect.numberOfUnits) {
                print("2 - too many units for this step")
                self.wrongChoise(floor)
            //tap on the same rect
            } else if ((row == rect.row) && (column == rect.column)) {
				self.clearArea(self.gamePlay.arrayOfRect[row][column])
            //go to area with alias
            } else {
                print("3 - units go to alies rect")
                self.gamePlay.arrayOfRect[row][column].numberOfUnits = rect.numberOfUnits + self.gamePlay.arrayOfRect[row][column].numberOfUnits
                self.gamePlay.arrayOfRect[row][column].label.text = String(self.gamePlay.arrayOfRect[row][column].numberOfUnits)
                self.gamePlay.arrayOfRect[rect.row][rect.column].numberOfUnits = 0
                self.gamePlay.arrayOfRect[rect.row][rect.column].label.text = "0"
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
    
	func canUpgrade(row: Int, column: Int) -> Bool {
		gamePlay.arrayOfRect[row][column].numberOfUnits >= gamePlay.arrayOfRect[row][column].costOfUpgrade ? true : false
	}
	
    func upgrade(row: Int, column: Int) {
//        if arrayOfRect[row][column].numberOfUnits >= arrayOfRect[row][column].costOfUpgrade {
            gamePlay.upgrade(row: row, column: column)
		
            UIView.animate(withDuration: 0,
                           delay: 0,
                           options: [.curveEaseIn , .allowUserInteraction],
                           animations: {
                self.gamePlay.arrayOfRect[row][column].label.alpha += 0.1
            },
                           completion: nil)
//        } else {
//            wrongChoise()
//        }
        
    }
    
	func wrongChoise(_ floor: UILabel) {
        let text = UILabel(frame: CGRect(x: 50, y: 100, width: 100, height: 50))
        text.textColor = .red
        //text.text = "wrong tap"
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.allowUserInteraction],
                       animations: {
            floor.addSubview(text)
            floor.backgroundColor = .red
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: [.allowUserInteraction],
                           animations: {
                text.removeFromSuperview()
                floor.backgroundColor = .clear
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
