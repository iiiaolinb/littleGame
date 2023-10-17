import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var viewModel = ViewModel()
    
    lazy var labelVariantsOfMoves: UILabel = {
        let label = UILabel()
        label.text = String(viewModel.gamePlay.variantsOfMoves)
        label.layer.borderWidth = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelCountOfUnits: UILabel = {
        let label = UILabel()
        label.text = String(viewModel.gamePlay.countOfUnits)
        label.layer.borderWidth = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var refreshButton: UIButton = {
        let refreshButton = UIButton(title: "Refresh", target: self, selector: #selector(onRefreshButton))
        refreshButton.contentHorizontalAlignment = .center
        refreshButton.backgroundColor = .lightGray
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        return refreshButton
    }()
    
    lazy var nextStepButton: UIButton = {
        let nextStepButton = UIButton(title: "Next step", target: self, selector: #selector(onNextStepButton))
        nextStepButton.contentHorizontalAlignment = .center
        nextStepButton.backgroundColor = .lightGray
        nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        return nextStepButton
    }()
    
    lazy var stackForButton: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        stack.contentMode = .scaleAspectFit
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(refreshButton)
        stack.addArrangedSubview(nextStepButton)
        return stack
    }()
	
	lazy var floor: UILabel = {
		var floor = UILabel(frame: CGRect(x: Int(Constant.SizeAndPoint.startPoint.x),
										  y: Int(Constant.SizeAndPoint.startPoint.y),
										  width: Constant.SizeAndPoint.rectSide * 5,
										  height: Constant.SizeAndPoint.rectSide * 10))
		floor.backgroundColor = .clear
		floor.alpha = 1
		return floor
	}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cat vs Dog"
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tap))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        doubleTap.numberOfTapsRequired = 2
        singleTap.require(toFail: doubleTap)
        view.addGestureRecognizer(doubleTap)
        
        view.backgroundColor = .systemBrown
        
        drowRect()
        
        setupConstraints()
    }
	
	func drowRect() {
		viewModel.createRect()
		
		viewModel.gamePlay.arrayOfRect.forEach { labels in
			labels.forEach { label in
				view.addSubview(label.label)
			}
		}
		view.addSubview(floor)
	}
}

extension ViewController {
    
    @objc func onRefreshButton() {
        viewModel.selectedRect = Model(label: UILabel(), xPosition: 0, yPosition: 0, row: 0, column: 0, numberOfUnits: 0)
        viewModel.gamePlay.rectWithUnits.removeAll()
        viewModel.gamePlay.rectWithBarraks.removeAll()
        viewModel.countOfTap = -1
        viewModel.isItRight = false
        viewModel.gamePlay.variantsOfMoves = 1
        viewModel.gamePlay.countOfUnits = 10
        viewModel.clearButtlefield()
        drowRect()
    }
    
    @objc func onNextStepButton() {
        viewModel.gamePlay.variantsOfMoves = viewModel.gamePlay.rectWithBarraks.count > 0 ? viewModel.gamePlay.rectWithBarraks.count : 1
        viewModel.gamePlay.countOfUnits = viewModel.gamePlay.calculateAllUnits()
        labelVariantsOfMoves.text = String(viewModel.gamePlay.variantsOfMoves)
        labelCountOfUnits.text = String(viewModel.gamePlay.countOfUnits)
        viewModel.arrivalTheUnits()
        viewModel.clearArea(viewModel.selectedRect)
        viewModel.countOfTap = 0
    }
    
    @objc func tap(_ gesture: UIGestureRecognizer) {
        guard viewModel.gamePlay.variantsOfMoves > 0 else { return }
        switch viewModel.countOfTap {
        case -1:
            startTap(gesture: gesture)
        case 0:     // Первое нажатие на ячейку
            firstTapOnRect(gesture: gesture)
        case 1:     //второе нажатие на другую ячейку
            secondTapOnRect(gesture: gesture)
            if viewModel.isItRight {
                viewModel.clearArea(viewModel.selectedRect)
                viewModel.isItRight = false
           }
        default:
            viewModel.countOfTap = 0
            break
        }
    }
    
    @objc func doubleTap(_ gesture: UIGestureRecognizer) {
        guard viewModel.gamePlay.variantsOfMoves > 0 && viewModel.countOfTap < 1 else { return }
        checkAndUpgrade(gesture)
    }
    
    func startTap(gesture: UIGestureRecognizer) {
        print("RECT WITH UNITS - ", viewModel.gamePlay.rectWithUnits.count)
        
        for row in 0..<5 {
            for column in 0..<10 {
                let selectedRect = viewModel.gamePlay.arrayOfRect[row][column]
                let tapLocation = gesture.location(in: selectedRect.label.superview)
                if (selectedRect.label.layer.presentation()?.frame.contains(tapLocation))! {
                    viewModel.startTapOnRect(selectedRect)
                    modifyTheNumberOfVariantsOfMoves()
                    modifyTheNumberOfCountOfUnits(selectedRect)
                    print("APPENDING - ", selectedRect.numberOfUnits)
                }
            }
        }
        viewModel.gamePlay.rectWithUnits.forEach { print($0.row, $0.column, $0.numberOfUnits) }
        print("RECT WITH UNITS - ", viewModel.gamePlay.rectWithUnits.count)
    }
    
    func firstTapOnRect(gesture: UIGestureRecognizer) {
        for row in 0..<5 {
            for column in 0..<10 {
                let selectedRect = viewModel.gamePlay.arrayOfRect[row][column]
                let tapLocation = gesture.location(in: selectedRect.label.superview)
                if (selectedRect.numberOfUnits > 0) && (viewModel.gamePlay.rectWithUnits.contains(selectedRect)) && (selectedRect.label.layer.presentation()?.frame.contains(tapLocation))! {
                    viewModel.selectedRect = selectedRect
                    viewModel.firstTapOnRect(row: row, column: column, floor: floor)
                    viewModel.countOfTap += 1
                }
            }
        }
    }
    
    func secondTapOnRect(gesture: UIGestureRecognizer) {
        var choiseArr = [Model]()
        let selectedRow = viewModel.selectedRect.row
        let selectedColumn = viewModel.selectedRect.column
        
        switch (selectedRow, selectedColumn) {
        case (0, 0):
            choiseArr = [viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn + 1],
                         viewModel.gamePlay.arrayOfRect[selectedRow + 1][selectedColumn]]
        case (0, 9):
            choiseArr = [viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn - 1],
                         viewModel.gamePlay.arrayOfRect[selectedRow + 1][selectedColumn]]
        case (4, 0):
            choiseArr = [viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn + 1],
                         viewModel.gamePlay.arrayOfRect[selectedRow - 1][selectedColumn]]
        case (4, 9):
            choiseArr = [viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn - 1],
                         viewModel.gamePlay.arrayOfRect[selectedRow - 1][selectedColumn]]
        case (1...3, 0):
            choiseArr = [viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn + 1],
                         viewModel.gamePlay.arrayOfRect[selectedRow - 1][selectedColumn],
                         viewModel.gamePlay.arrayOfRect[selectedRow + 1][selectedColumn]]
        case (1...3, 9):
            choiseArr = [viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn - 1],
                         viewModel.gamePlay.arrayOfRect[selectedRow - 1][selectedColumn],
                         viewModel.gamePlay.arrayOfRect[selectedRow + 1][selectedColumn]]
        case (0, 1...8):
            choiseArr = [viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn + 1],
                         viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn - 1],
                         viewModel.gamePlay.arrayOfRect[selectedRow + 1][selectedColumn]]
        case (4, 1...8):
            choiseArr = [viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn + 1],
                         viewModel.gamePlay.arrayOfRect[selectedRow - 1][selectedColumn],
                         viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn - 1]]
        case (1...3, 1...8):
            choiseArr = [viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn + 1],
                         viewModel.gamePlay.arrayOfRect[selectedRow - 1][selectedColumn],
                         viewModel.gamePlay.arrayOfRect[selectedRow + 1][selectedColumn],
                         viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn - 1]]
        default:
            print("invalid")
            break
        }
        choiseArr.append(viewModel.gamePlay.arrayOfRect[selectedRow][selectedColumn])
        
        for choise in choiseArr {
            let selectedRect = choise
            let tapLocation = gesture.location(in: selectedRect.label.superview)
            
            //тап на ту же ячейку (сбрасываем выделение)
            if (selectedRect.label.layer.presentation()?.frame.contains(tapLocation))! && ((viewModel.selectedRect.row == selectedRow) && (viewModel.selectedRect.column == selectedColumn)) {
                viewModel.clearArea(choise)
                viewModel.countOfTap = 0
            // для перехода на ячейку с бараком или союзную ячейку
            } else if (selectedRect.label.layer.presentation()?.frame.contains(tapLocation))! &&
                ((viewModel.gamePlay.rectWithUnits.contains(selectedRect)) ||
                 (viewModel.gamePlay.rectWithBarraks.contains(selectedRect))) {
                viewModel.secondTapOnRect(row: selectedRect.row, column: selectedRect.column, floor: floor)
                viewModel.countOfTap = 0
                viewModel.isItRight = true
                modifyTheNumberOfVariantsOfMoves()
            // для перехода на нейтральную ячейку
            } else if (selectedRect.label.layer.presentation()?.frame.contains(tapLocation))! && (viewModel.selectedRect.numberOfUnits >= selectedRect.numberOfUnits) {
                viewModel.gamePlay.rectWithUnits.append(selectedRect)
                viewModel.secondTapOnRect(row: selectedRect.row, column: selectedRect.column, floor: floor)
                viewModel.countOfTap = 0
                viewModel.isItRight = true
                modifyTheNumberOfVariantsOfMoves()
                modifyTheNumberOfCountOfUnits(selectedRect)
            //сбрасываем выделение
            } else {
                viewModel.clearArea(choise)
                viewModel.countOfTap = 0
            }
        }
    }
    
    func upgrade(rect: Model) {
        view.alpha = 1
		if viewModel.canUpgrade(row: rect.row, column: rect.column) {
			viewModel.upgrade(row: rect.row, column: rect.column)
		} else {
			viewModel.wrongChoise(floor)
		}
        modifyTheNumberOfVariantsOfMoves()
        modifyTheNumberOfCountOfUnits(rect)
    }
    
    func modifyTheNumberOfVariantsOfMoves() {
        viewModel.gamePlay.variantsOfMoves -= 1
        self.labelVariantsOfMoves.text = String(viewModel.gamePlay.variantsOfMoves)
    }
    
    func modifyTheNumberOfCountOfUnits(_ selectedRect: Model) {
        viewModel.gamePlay.countOfUnits -= selectedRect.costOfUpgrade
        self.labelCountOfUnits.text = String(viewModel.gamePlay.countOfUnits)
    }
    
    private func checkAndUpgrade(_ gesture: UIGestureRecognizer) {
        for row in 0..<5 {
            for column in 0..<10 {
				let selectedRect = viewModel.gamePlay.arrayOfRect[row][column]
                let tapLocation = gesture.location(in: selectedRect.label.superview)
                if (viewModel.gamePlay.rectWithUnits.contains(selectedRect)) && (selectedRect.label.layer.presentation()?.frame.contains(tapLocation))! {
                    selectedRect.numberOfUnits >= selectedRect.costOfUpgrade ? upgrade(rect: selectedRect) : nil
                }
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubview(stackForButton)
        stackForButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.bottomMargin).inset(40)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width).inset(50)
            make.height.equalTo(50)
        }
        refreshButton.snp.makeConstraints { make in
            make.left.equalTo(stackForButton.snp.left)
            make.top.equalTo(stackForButton.snp.top)
            make.width.equalTo(stackForButton.snp.width).dividedBy(3)
            make.height.equalTo(50)
        }
        nextStepButton.snp.makeConstraints { make in
            make.right.equalTo(stackForButton.snp.right)
            make.top.equalTo(stackForButton.snp.top)
            make.width.equalTo(stackForButton.snp.width).dividedBy(3)
            make.height.equalTo(50)
        }
        
        view.addSubview(labelVariantsOfMoves)
        labelVariantsOfMoves.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.height.width.equalTo(30)
        }
        
        view.addSubview(labelCountOfUnits)
        labelCountOfUnits.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.height.width.equalTo(30)
        }
    }
}

extension UIButton {
    convenience init(title: String, target: Any, selector: Selector) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        addTarget(target, action: selector, for: .touchUpInside)
    }
}
