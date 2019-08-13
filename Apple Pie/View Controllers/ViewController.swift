//
//  ViewController.swift
//  Apple Pie
//
//  Created by Denis Bystruev on 29/03/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    
    let incorrectMovesAllowed = 7
    
    var currentGame: Game!
    var listOfWords = Names.all
    
    var totalWins = 0 {
        didSet {
            newRound(after: 0.5)
        }
    }
    
    var totalLoses = 0 {
        didSet {
            currentGame.formattedWord = currentGame.word
            newRound(after: 0.5)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWords()
        newRound()
    }
    
    func loadWords() {
        let url = URL(string: "http://localhost:8080/list")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            guard let words = try? jsonDecoder.decode([Word].self, from: data) else {
                print(#line, #function, "Can't decode \(data)")
                
                if let dataAsString = String(data: data, encoding: .utf8) {
                    print(dataAsString)
                }
                
                return
            }
            self.listOfWords = words.map { $0.value }
        }.resume()
    }
    
    func enableButtons(_ enable: Bool, in view: UIView) {
        if view is UIButton {
            (view as! UIButton).isEnabled = enable
        } else {
            for subview in view.subviews {
                enableButtons(enable, in: subview)
            }
        }
    }
    
    func newRound() {
        if !listOfWords.isEmpty {
            let randomIndex = Int(arc4random_uniform(UInt32(listOfWords.count)))
            let newWord = listOfWords.remove(at: randomIndex)
            currentGame = Game(
                word: newWord.lowercased(),
                incorrectMovesRemaining: incorrectMovesAllowed,
                guessedLetters: []
            )
            enableButtons(true, in: view)
            updateUI()
        } else {
            enableButtons(false, in: view)
        }
    }
    
    func newRound(after delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.newRound()
        }
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining < 1 {
            totalLoses += 1
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        }
        updateUI()
    }
    
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        letters[0] = letters[0].capitalized
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Выиграно: \(totalWins), Проиграно: \(totalLoses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    }

}
