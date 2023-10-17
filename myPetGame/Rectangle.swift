import UIKit
import SnapKit

protocol RectanglesProtocol {
    func createRect()
    func drowRect(inView: UIViewController)
    //func tapOnRectAnimation(row: Int, column: Int)
    func pickUpCoordinates(ofRect: Model) -> (Int, Int)
}

class Rectangle: RectanglesProtocol {
    lazy var rectSide = Int(UIScreen.main.bounds.size.height - 200) / 10
    var arrayOfRect = [[Model]]()
    lazy var startPoint = CGPoint(x: (Int(UIScreen.main.bounds.size.width) - rectSide * 5) / 2, y: 100)
    
    lazy var floor: UILabel = {
        var floor = UILabel(frame: CGRect(x: Int(startPoint.x),
                                          y: Int(startPoint.y),
                                          width: rectSide * 5,
                                          height: rectSide * 10))
        floor.backgroundColor = .clear
        floor.alpha = 1
        return floor
    }()
    
    init(withView view: UIViewController) {
        drowRect(inView: view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createRect() {
        var x: Int = 0
        var y: Int = 0
        var array = [[Model]]()
        for horizontal in 0..<5 {
            var column = [Model]()
            var randomNumber: Int = 0
            for vertical in 0..<10 {
                lazy var label: UILabel = {
                    let frame = CGRect(x: Int(startPoint.x) + x,
                                       y: Int(startPoint.y) + y,
                                       width: rectSide,
                                       height: rectSide)
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
                y += rectSide
            }
            array.append(column)
            column.removeAll()
            x += rectSide
            y = 0
        }
        arrayOfRect = array
    }
    
    func drowRect(inView view: UIViewController) {
        createRect()
        
        arrayOfRect.forEach { labels in
            labels.forEach { label in
                view.view.addSubview(label.label)
            }
        }
        view.view.addSubview(floor)
    }
    
    func pickUpCoordinates(ofRect rect: Model) -> (Int, Int){
        let coord = (rect.xPosition, rect.yPosition)
        return coord
    }
    
    func setUpConstraints() {
        
    }
}
