//
//  ViewController.swift
//  JogoDaVelha
//
//  Created by Josicleison on 11/09/22.
//

import UIKit

class View: UIViewController {
    
    private lazy var viewModel: ViewModel = {
        
        let viewModel = ViewModel()
        viewModel.delegate = self
        
        return viewModel
    }()
    
    private lazy var playerChoseButtonsStackView: UIStackView = {
        
        let xButton = viewModel.createPlayerChoseButton(App.x)
        
        let circleButton = viewModel.createPlayerChoseButton(App.circle)
        
        let playerChoseButtonsStackView = viewModel.createStack([xButton, circleButton],
                                                                spacing: 0)
        
        return playerChoseButtonsStackView
    }()
    
    private lazy var jogoDaVelhaStackView: UIStackView = {
        
        var lines: [UIStackView] = []
        
        for _ in 0...2 {
            
            let line = viewModel.createStack([viewModel.createButton(),
                                              viewModel.createButton(),
                                              viewModel.createButton()])
            lines.append(line)
        }
        
        let jogoDaVelhaStackView = viewModel.createStack([lines[0], lines[1], lines[2]])
        jogoDaVelhaStackView.axis = .vertical
        
        return jogoDaVelhaStackView
    }()
    
    private lazy var resultButton: UIButton = {
        
        let resultButton = UIButton()
        resultButton.titleLabel?.font = App.font
        resultButton.titleLabel?.textColor = .white
        resultButton.titleLabel?.textAlignment = .center
        resultButton.addTarget(self, action: #selector(resultTarget), for: .touchUpInside)
        
        return resultButton
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubviews([playerChoseButtonsStackView, jogoDaVelhaStackView, resultButton])
        
        view.backgroundColor = App.background
        
        playerChoseButtonsStackView.constraint(to: view.safeAreaLayoutGuide,
                                               by: [.leading,.top,.trailing])
        playerChoseButtonsStackView.constraint(to: playerChoseButtonsStackView,
                                               with: [.height:.width], multiplier: 0.5)
        
        jogoDaVelhaStackView.constraint(to: playerChoseButtonsStackView, with: [.top:.bottom])
        jogoDaVelhaStackView.constraint(to: view.safeAreaLayoutGuide, by: [.leading,.trailing])
        jogoDaVelhaStackView.constraint(to: jogoDaVelhaStackView, with: [.height:.width])
        
        resultButton.constraint(to: jogoDaVelhaStackView, with: [.top:.bottom])
        resultButton.constraint(to: view.safeAreaLayoutGuide, by: [.leading,.trailing,.bottom])
    }
    
    @objc func resultTarget(_ sender: UIButton) {
        
        sender.setTitle(nil, for: .normal)
        playerChoseButtonsStackView.isUserInteractionEnabled = true
        jogoDaVelhaStackView.isUserInteractionEnabled = true
        
        viewModel.playerSelection = nil
        viewModel.cpuSelection = nil
        viewModel.clearBoard(jogoDaVelhaStackView)
    }
}

extension View: ViewModelDelegate {
    
    func freezeStack() {
        
        playerChoseButtonsStackView.isUserInteractionEnabled = false
    }
    
    func setupBoard() {
        
        viewModel.cpuPlay(jogoDaVelhaStackView)
    }
    
    func showResult(_ result: String) {
        
        resultButton.setTitle(result, for: .normal)
    }
}
