//
//  ViewController.swift
//  lifecounter v2
//
//  Created by Cole Meier on 4/22/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playersStackView: UIStackView!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var playerLifeTotals: [Int] = []
    var playerViews: [UIView] = []
    var history: [String] = []
    var gameStarted = false
    let startingLife = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStartingPlayers()
    }
    
    func setupStartingPlayers() {
        addPlayer()
        addPlayer()
        addPlayer()
        addPlayer()
    }
    
    func addPlayer() {
        guard playerLifeTotals.count < 8 else { return }
        
        let playerIndex = playerLifeTotals.count
        playerLifeTotals.append(startingLife)
        
        let playerView = UIStackView()
        playerView.axis = .horizontal
        playerView.spacing = 8
        playerView.alignment = .center
        playerView.tag = playerIndex
        
        let nameLabel = UILabel()
        nameLabel.text = "Player \(playerIndex + 1)"
        nameLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nameTapped(_:)))
        nameLabel.addGestureRecognizer(tapGesture)
        nameLabel.tag = 100
        
        let lifeLabel = UILabel()
        lifeLabel.text = "\(startingLife)"
        lifeLabel.tag = 101
        
        let amountField = UITextField()
        amountField.text = "1"
        amountField.keyboardType = .numberPad
        amountField.widthAnchor.constraint(equalToConstant: 40).isActive = true
        amountField.tag = 102
        
        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.addTarget(self, action: #selector(plusTapped(_:)), for: .touchUpInside)
        
        let minusButton = UIButton(type: .system)
        minusButton.setTitle("-", for: .normal)
        minusButton.addTarget(self, action: #selector(minusTapped(_:)), for: .touchUpInside)
        
        let removeButton = UIButton(type: .system)
        removeButton.setTitle("Remove", for: .normal)
        removeButton.addTarget(self, action: #selector(removePlayer(_:)), for: .touchUpInside)
        
        [nameLabel, lifeLabel, amountField, plusButton, minusButton, removeButton].forEach { playerView.addArrangedSubview($0) }
        
        playersStackView.addArrangedSubview(playerView)
        playerViews.append(playerView)
    }
    
    func resetGame() {
        playerLifeTotals.removeAll()
        playerViews.forEach { $0.removeFromSuperview() }
        playerViews.removeAll()
        history.removeAll()
        gameStarted = false
        addPlayerButton.isEnabled = true
        setupStartingPlayers()
    }
    
    @IBAction func addPlayerButtonTapped(_ sender: UIButton) {
        addPlayer()
        if gameStarted {
            addPlayerButton.isEnabled = false
        }
    }
    
    @IBAction func historyButtonTapped(_ sender: UIButton) {
        let historyText = history.joined(separator: "\n")
        let alert = UIAlertController(title: "Game History", message: historyText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        resetGame()
    }
    
    @objc func plusTapped(_ sender: UIButton) {
        changeLife(sender: sender, delta: +1)
    }
    
    @objc func minusTapped(_ sender: UIButton) {
        changeLife(sender: sender, delta: -1)
    }
    
    func changeLife(sender: UIButton, delta: Int) {
        guard let playerView = sender.superview as? UIStackView else { return }
        let index = playerView.tag
        guard index < playerLifeTotals.count else { return }
        
        if !gameStarted {
            gameStarted = true
            addPlayerButton.isEnabled = false
        }
        
        let amountField = playerView.viewWithTag(102) as? UITextField
        let amount = Int(amountField?.text ?? "1") ?? 1
        
        playerLifeTotals[index] += delta * amount
        
        playerLifeTotals[index] = max(0, playerLifeTotals[index])
        
        let lifeLabel = playerView.viewWithTag(101) as? UILabel
        lifeLabel?.text = "\(playerLifeTotals[index])"
        
        let nameLabel = playerView.viewWithTag(100) as? UILabel
        let name = nameLabel?.text ?? "Player \(index + 1)"
        
        history.append("\(name) \(delta > 0 ? "gained" : "lost") \(amount) life.")
        
        if playerLifeTotals[index] <= 0 {
            history.append("\(name) has LOST!")
            checkGameOver()
        }
    }
    
    @objc func nameTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let playerView = label.superview as? UIStackView else { return }
        let _ = playerView.tag
        
        let alert = UIAlertController(title: "Change Name", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let newName = alert.textFields?.first?.text, !newName.isEmpty {
                label.text = newName
            }
        }))
        present(alert, animated: true)
    }
    
    func checkGameOver() {
        let alive = playerLifeTotals.filter { $0 > 0 }
        if alive.count == 1 {
            if let winnerIndex = playerLifeTotals.firstIndex(where: { $0 > 0 }) {
                let winnerName = (playerViews[winnerIndex].viewWithTag(100) as? UILabel)?.text ?? "Winner"
                let alert = UIAlertController(title: "Game Over", message: "\(winnerName) wins!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.resetGame()
                }))
                present(alert, animated: true)
            }
        }
    }
    
    @objc func removePlayer(_ sender: UIButton) {
        guard let playerView = sender.superview as? UIStackView else { return }
        let index = playerView.tag
        guard playerLifeTotals.count > 2 else { return }
        
        playerLifeTotals.remove(at: index)
        playerViews.remove(at: index)
        
        for (newIndex, playerView) in playerViews.enumerated() {
            playerView.tag = newIndex
            let nameLabel = playerView.viewWithTag(100) as? UILabel
            nameLabel?.text = "Player \(newIndex + 1)"
        }
        
        playerView.removeFromSuperview()
        
        if !gameStarted {
            addPlayerButton.isEnabled = playerLifeTotals.count < 8
        }
    }
}
