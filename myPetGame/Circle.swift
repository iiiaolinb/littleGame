//import UIKit
//
//class Circle: UIView {
//    var arrayOfCircle = [[UIImageView]]()
//    var rectangle = Rectangle()
//    
//    func insertInto(rect: Rectangle) {
//
//    }
//
//    func createBlankCircle() {
//        var x: Int = 0
//        var y: Int = 0
//        var array = [[UIImageView]]()
//        for horizontal in 0..<5 {
//            var column = [UIImageView]()
//            for vertical in 0..<10 {
//                lazy var label: UIImageView = {
//                    let image = UIImage()
//                    let view = UIImageView(image: image)
//                    
//                    let label = UILabel(frame: CGRect(x: 50+x, y: 100+y, width: Rectangle.rectSide, height: Rectangle.rectSide))
//                    label.backgroundColor = Constant.ColorOfEntities.neutrals
//                    label.layer.borderWidth = 2
//                    label.textAlignment = .center
//                    let randomNumber = Int.random(in: 1...10)
//                    label.text = "\(randomNumber)"
//                    return view
//                }()
//                column.append(label)
//                y += Rectangle.rectSide
//            }
//            array.append(column)
//            column.removeAll()
//            x += Rectangle.rectSide
//            y = 0
//        }
//        arrayOfCircle = array
//    }
//    
////    func createCircle(_ color: String, withX x: Int, withY y: Int) {
////        let image = UIImage(named: color)
////        let view = UIImageView(image: image)
////        view.frame = CGRect(x: x, y: y, width: Rectangle.rectSide, height: Rectangle.rectSide)
////        view.contentMode = .scaleAspectFit
////        circleArray.append(view)
////    }
//}
