//
//  StoryViewController.swift
//  StoryTime
/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class StoryViewController: UIViewController , UITextFieldDelegate{
    var currentStory: Story?
  var currentNumber = 50
  var currentSwitchValue = true
  var storyType = 0
  var monsters = "zombies"
  var winStory = "<name> entered the room and saw <number> <monsters>! Without missing a beat, <name> <verb> all of the <monsters>! \n\nPoor <monsters>. Fantastic! \n\n<name> will live to fight another day."
  var loseStory = "<name> entered the room and saw <number> <monsters>! <name> ran down the hall. Sadly, <name> was <verb> by all the <monsters>! \n\nPoor <name>. Better luck next time!"
  
  @IBOutlet weak var backgroundImage: UIImageView! // background image
  @IBOutlet weak var storyTitle: UITextField!
  @IBOutlet weak var nameText: UITextField! // name
  @IBOutlet weak var verbText: UITextField! // verb
  @IBOutlet weak var monsterAmount: UISlider! // number
  @IBOutlet weak var monstersWin: UISwitch! // win or lose
  @IBOutlet weak var textview: UITextView! // generated story
  @IBOutlet weak var generateStoryButton: UIButton! // generate story
  @IBOutlet weak var numberLabel: UILabel! // label for number
    
  override func viewDidLoad() {
    super.viewDidLoad()
 
    textview.layer.borderColor = UIColor.darkGray.cgColor
    textview.layer.borderWidth = 1.0
    
    numberLabel.text = "Number (\(currentNumber))"
    
    if currentStory != nil {
        var image: UIImage!
        if currentStory?.type == .zombies {
            image = UIImage(named: "zombies")
        } else if currentStory?.type == .vampires {
            image = UIImage(named: "vampires")
            } else {
                image = UIImage(named: "aliens")
            }
        backgroundImage.image = image
        storyTitle.text = currentStory?.titles
        nameText.text = currentStory?.name
        verbText.text = currentStory?.verb
        if let monstersCount = currentStory?.number {
            monsterAmount.value = Float(monstersCount)
            currentNumber = monstersCount
        }
        if let didWin = currentStory?.didWin {
            monstersWin.isOn = didWin
        }
        
        }
    }
  
  @IBAction func sliderMoved(_ sender: UISlider) {
    currentNumber = lroundf(sender.value)
    numberLabel.text = "Number (\(currentNumber))"
  }
    
  @IBAction func switchValueChanged(_ sender: UISwitch) {
    if (sender.isOn) {
        currentSwitchValue = true
    } else {
        currentSwitchValue = false
    }
  }
    
    @IBAction func save(_ sender: Any) {
        updateStory()
        _ = navigationController?.popViewController(animated: true)
    }
  @IBAction func generateStory(_ sender: UIButton) {
    if nameText.text?.isEmpty == true || verbText.text?.isEmpty == true {
      showAlert()
      return
    }
    populateStory()
  }
  
    fileprivate func updateStory() {
        if let name = nameText.text, let title = storyTitle.text, let verb = verbText.text {
            currentStory?.titles = title
            currentStory?.name = name
            currentStory?.verb = verb
            currentStory?.number = Int(monsterAmount.value)
        }
    }
    func populateStory() {
        if currentStory != nil {
            updateStory()
            textview.text = currentStory?.generateStory(monstersWin.isOn)
        }
    }
  func resetStory() {
    nameText.text = ""
    verbText.text = ""
    monsterAmount.value = 50
    monstersWin.isOn = true
    textview.text = "your generated story will appear here"
    currentNumber = 50
    currentSwitchValue = true
    
    generateStoryButton.setTitle("Generate Story", for: UIControlState())
    generateStoryButton.tag = 1
    checkValidationStatus()
    numberLabel.text = "Number (\(currentNumber))"
  }
  
  func showAlert() {
    let alertController = UIAlertController(title: "Missing Data!", message: "Hey, you're missing something!", preferredStyle: .alert)
    
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    present(alertController, animated: true, completion: nil)
  }
    
  func checkValidationStatus() {
    if ((nameText.text?.isEmpty)! || (verbText.text?.isEmpty)!) {
      generateStoryButton.isEnabled = false
      generateStoryButton.alpha = 0.50
    } else {
      generateStoryButton.isEnabled = true
      generateStoryButton.alpha = 1.0
    }
  }
  
  func generateStoryText() -> String {
    var storyText = ""
    
    if monstersWin.isOn {
      storyText = winStory
    } else {
      storyText = loseStory
    }
    
    
    storyText = replaceText("<verb>", withText: verbText.text! , inString: storyText)
    storyText = replaceText("<number>", withText: String(Int(monsterAmount.value)), inString: storyText)
    storyText = replaceText("<name>", withText: nameText.text!, inString: storyText)
    storyText = replaceText("<monsters>", withText: monsters, inString: storyText)
    
    return storyText
  }
  
  fileprivate func replaceText(_ text: String, withText: String, inString: String) -> String {
    return inString.replacingOccurrences(of: text, with: withText, options: NSString.CompareOptions.literal, range: nil)
  }
    
    // MARK: - UITextFieldDeleage
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidationStatus()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkValidationStatus()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
  
}

