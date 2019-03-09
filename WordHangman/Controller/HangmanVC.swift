//
//  HangmanVC.swift
//  WordHangman
//
//  Created by tarek bahie on 3/8/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit

class HangmanVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var wordLbl: UILabel!
    @IBOutlet weak var letterTxtField: UITextField!
    @IBOutlet weak var remainingGuessLbl: UILabel!
    @IBOutlet weak var hintLbl: UILabel!
    @IBOutlet weak var choosenLettersLbl: UITextView!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var hangmanImg: UIImageView!
    
    
    let words = ["Cairo","Real Madrid","Gravity","Batman","Sun","Moon","Egypt","Iphone","Macbook","Spain"]
    let hints = ["an african capital","a spanish club","a force of nature","a DC comics hero","a bright star","seen only at night","an african country","a handheld apple product","an apple device","a european country"]
    var choosenWord = ""
    var index = 0
    var wordAsUnderscores = ""
    var wordToGuess = ""
    var maxGuess = 7
    var newInt: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choosenLettersLbl.isUserInteractionEnabled = false
        restartBtn.isHidden = true
        chooseWordToStartGame()
        wordLbl.text = wordAsUnderscores
        remainingGuessLbl.text = "\(maxGuess) guesses left"
        letterTxtField.delegate = self

    }
    @IBAction func restartBtnPressed(_ sender: Any) {
        wordToGuess = ""
        restartBtn.isHidden = true
        maxGuess = 7
        remainingGuessLbl.text = "\(maxGuess) guesses left"
        wordAsUnderscores = ""
        hangmanImg.isHidden = true
        chooseWordToStartGame()
        wordLbl.text = wordAsUnderscores
        letterTxtField.isEnabled = true
    }
    
    // MARK: - Word Manipulation
    
    func chooseWordToStartGame() {
        choosenLettersLbl.text = ""
        index = createRandomInt(oldInt: newInt)
        hintLbl.text = "Hint: " + hints[index]
        wordToGuess = words[index].lowercased()
        turnStringToUnderscores()
    }
    func turnStringToUnderscores() {
        var myIndex = wordToGuess.startIndex
        while myIndex < wordToGuess.endIndex {
            for _ in 0..<wordToGuess.count {
                if wordToGuess[myIndex] == " " {
                    wordAsUnderscores.append(" ")
                    myIndex = wordToGuess.index(after: myIndex)
                } else {
                    wordAsUnderscores.append("_")
                    myIndex = wordToGuess.index(after: myIndex)
                }
            }
            
        }
    }
    func createRandomInt(oldInt : Int) -> Int {
         newInt = Int.random(in: 0..<10)
        if newInt == oldInt {
            newInt = Int.random(in: 0..<10)
        }
        return newInt
        
    }
    // MARK: - TextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let letterGuessed = textField.text, textField.text != ""
        else { return }
        letterTxtField.text?.removeAll()
        let currentLetterBank : String = choosenLettersLbl.text ?? ""
        if currentLetterBank.contains(letterGuessed) {
            return
        } else {
            if wordToGuess.contains(letterGuessed) {
                processCorrectGuess(letterGuessed: letterGuessed)
            } else {
                processIncorrectGuess()
                choosenLettersLbl.text?.append("\(letterGuessed), ")
            }
            
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = NSCharacterSet.lowercaseLetters
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        if string.isEmpty {
            return true
        } else if newLength == 1 {
            if let _ = string.rangeOfCharacter(from: allowedCharacters, options: .caseInsensitive) {
                return true
            }
        }
        return false
    }
    
    
    // MARK: - character analysis
    func processCorrectGuess(letterGuessed: String) {
        let characterGuessed = Character(letterGuessed)
        var myIndex = wordToGuess.startIndex
        while myIndex < wordToGuess.endIndex {
            for _ in 0..<wordToGuess.count {
                if wordToGuess[myIndex] == characterGuessed {
                    let endIndex = wordToGuess.index(after: myIndex)
                    let charRange = myIndex..<endIndex
                    wordAsUnderscores = wordAsUnderscores.replacingCharacters(in: charRange, with: letterGuessed)
                    
                }
                myIndex = wordToGuess.index(after: myIndex)
                wordLbl.text = wordAsUnderscores
            }
        }
        if !(wordAsUnderscores.contains("_")) {
            remainingGuessLbl.text = "You win! :)"
            letterTxtField.isEnabled = false
            restartBtn.isHidden = false
        }
        
    }
    func processIncorrectGuess() {
        maxGuess -= 1
        hangmanImg.isHidden = false
        if maxGuess == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.hangmanImg.image = UIImage(named: "Unknown")
            }
            remainingGuessLbl.text = "You lost! the correct answer is: \(wordToGuess)"
            wordLbl.text = ""
            letterTxtField.isEnabled = false
            restartBtn.isHidden = false
        } else {
            remainingGuessLbl.text = "\(maxGuess) guesses left"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.hangmanImg.image = UIImage(named: "Unknown\(self.maxGuess)")
            }
        }
    }
}
