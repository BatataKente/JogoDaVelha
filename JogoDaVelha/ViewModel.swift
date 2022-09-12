//
//  ViewModel.swift
//  JogoDaVelha
//
//  Created by Josicleison on 11/09/22.
//

import UIKit

protocol ViewModelDelegate {
    
    func freezeStack()
    func setupBoard()
    func showResult(_ result: String)
}

class ViewModel {
    
    var playerSelection: UIImage? = nil
    var cpuSelection: UIImage? = nil
    
    var delegate: ViewModelDelegate?
    
    func createImageView(_ image: UIImage?) -> UIImageView {
        
        let button = UIImageView()
        button.image = image
        button.backgroundColor = App.background
        
        return button
    }
    
    func createPlayerChoseButton(_ image: UIImage?) -> UIButton {
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.constraint(to: button, by: [.top,.leading,.trailing,.bottom])
        button.tintColor = App.button
        button.backgroundColor = App.background
        
        let action = UIAction{action in
            
            self.playerSelection = button.currentImage
            if button.currentImage == App.circle{self.cpuSelection = App.x}
            else if button.currentImage == App.x{self.cpuSelection = App.circle}
            self.delegate?.freezeStack()
        }
        
        button.addAction(action, for: .touchUpInside)
        
        return button
    }
    
    func createButton() -> UIButton {
        
        let button = UIButton()
        button.imageView?.constraint(to: button, by: [.top,.leading,.trailing,.bottom])
        button.tintColor = App.button
        button.backgroundColor = App.background
        
        let action = UIAction{action in
            
            guard let playerSelection = self.playerSelection else {return}
            
            if button.currentImage == nil {
                
                button.setImage(playerSelection, for: .normal)
                self.delegate?.setupBoard()
            }
        }
        
        button.addAction(action, for: .touchUpInside)
        
        return button
    }
    
    func createStack(_ arrangedSubviews: [UIView], spacing: CGFloat = 5) -> UIStackView {
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .black
        stackView.spacing = spacing
        
        return stackView
    }
    
    private func verifyButtons(of stackView: UIStackView) -> [UIButton] {
        
        var buttons:[UIButton] = []

        for i in 0...stackView.arrangedSubviews.count-1 {

            guard let stackView = stackView.arrangedSubviews[i] as? UIStackView else {return []}
            for j in 0...stackView.arrangedSubviews.count-1 {

                guard let button = stackView.arrangedSubviews[j] as? UIButton else {return []}
                buttons.append(button)
            }
        }
        
        return buttons
    }
    
    private func boardState(_ board: UIStackView) -> [Int] {
        
        var boardState:[Int] = []
        let buttons:[UIButton] = verifyButtons(of: board)
        
        for i in 0...buttons.count-1 {
            
            if buttons[i].currentImage == nil {

                boardState.append(i)
            }
        }

        return boardState
    }
    
    private func game(_ board: UIStackView,
                      playerSelection: UIImage?,
                      cpuSelection: UIImage?) -> Bool {
        
        var images:[UIImage?] = []
        let buttons:[UIButton] = verifyButtons(of: board)
        
        for button in buttons {
            
            images.append(button.currentImage)
        }
        
        let win = {(i: Int,j: Int,k: Int) -> Bool in
            
            if images[i] == images[j] && images[j] == images[k] && images[i] != nil && images[j] != nil && images[k] != nil {
                
                board.isUserInteractionEnabled = false
                
                guard let playerSelection = playerSelection else {return false}
                if images[i] == playerSelection {
                    
                    self.delegate?.showResult("You Win")
                    return true
                }
                else if images[i] == cpuSelection {
                    
                    self.delegate?.showResult("You Lose")
                    return true
                }
            }
            return false
        }
                      
        if win(0,1,2) {return true}
        if win(3,4,5) {return true}
        if win(6,7,8) {return true}
        
        if win(0,4,8) {return true}
        if win(2,4,6) {return true}
        
        if win(0,3,6) {return true}
        if win(1,4,7) {return true}
        if win(2,5,8) {return true}
        
        for image in images {
            
            if image == nil {return false}
        }
        
        self.delegate?.showResult("Draw")
        return true
    }
    
    func clearBoard(_ board: UIStackView) {
        
        let buttons:[UIButton] = verifyButtons(of: board)
        
        for button in buttons {
            
            button.setImage(nil, for: .normal)
        }
    }

    func cpuPlay(_ board: UIStackView) {
        
        if game(board,
                playerSelection: playerSelection,
                cpuSelection: cpuSelection) {return}
        
        let boardState:[Int] = boardState(board)

        if boardState != [] {

            var cpuChose = Int.random(in: 0...boardState.count-1)
            cpuChose = boardState[cpuChose]
            
            let buttons:[UIButton] = verifyButtons(of: board)
            
            for i in 0...buttons.count-1 {
                
                if cpuChose == i {

                    buttons[i].setImage(cpuSelection, for: .normal)
                }
            }
        }
        
        if game(board,
                playerSelection: playerSelection,
                cpuSelection: cpuSelection) {return}
    }
}
