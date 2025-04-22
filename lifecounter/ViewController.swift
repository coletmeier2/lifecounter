//
//  ViewController.swift
//  lifecounter
//
//  Created by Cole Meier on 4/22/25.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var player1LifeLabel: UILabel!
    @IBOutlet weak var player2LifeLabel: UILabel!
    @IBOutlet weak var loseMessageLabel: UILabel!


    var player1Life = 20
    var player2Life = 20


    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }


    @IBAction func player1PlusTapped(_ sender: UIButton) {
        player1Life += 1
        updateLife(forPlayer: 1)
    }

    @IBAction func player1MinusTapped(_ sender: UIButton) {
        player1Life -= 1
        updateLife(forPlayer: 1)
    }

    @IBAction func player1Plus5Tapped(_ sender: UIButton) {
        player1Life += 5
        updateLife(forPlayer: 1)
    }

    @IBAction func player1Minus5Tapped(_ sender: UIButton) {
        player1Life -= 5
        updateLife(forPlayer: 1)
    }


    @IBAction func player2PlusTapped(_ sender: UIButton) {
        player2Life += 1
        updateLife(forPlayer: 2)
    }

    @IBAction func player2MinusTapped(_ sender: UIButton) {
        player2Life -= 1
        updateLife(forPlayer: 2)
    }

    @IBAction func player2Plus5Tapped(_ sender: UIButton) {
        player2Life += 5
        updateLife(forPlayer: 2)
    }

    @IBAction func player2Minus5Tapped(_ sender: UIButton) {
        player2Life -= 5
        updateLife(forPlayer: 2)
    }

    func updateLife(forPlayer player: Int) {
        if player == 1 {
            player1LifeLabel.text = "\(player1Life)"
            if player1Life <= 0 {
                showLossMessage(forPlayer: 1)
            }
        } else {
            player2LifeLabel.text = "\(player2Life)"
            if player2Life <= 0 {
                showLossMessage(forPlayer: 2)
            }
        }
    }

    func showLossMessage(forPlayer player: Int) {
        loseMessageLabel.text = "Player \(player) LOSES!"
        loseMessageLabel.isHidden = false
    }

    func updateUI() {
        player1LifeLabel.text = "\(player1Life)"
        player2LifeLabel.text = "\(player2Life)"
        loseMessageLabel.isHidden = true
    }
}


