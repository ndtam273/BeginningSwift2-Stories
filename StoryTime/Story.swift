//
//  Story.swift
//  StoryTime
//
//  Created by Nguyen Duc Tam on 2017/03/04.
//  Copyright © 2017年 Tammy Coron. All rights reserved.
//

import Foundation
enum StoryType : Int {
    case zombies = 0 , vampires, aliens
    static let genres = [zombies, vampires, aliens]
}
class Story : NSObject, NSCoding {
    var titles = "untitles story"
    var name : String?
    var verb : String?
    var  number : Int?
    var type : StoryType
    var didWin  = false
    
    
    var winStory = "<name> entered the room and saw <number> <monster>!\n Without missing a beat, <name> <verb> all of the <monsters>! \n\nPoor <monsters>. Fantastic! \n\n<name will live to fight a nother day.>"
    var loseStory = "<name> entered the room and saw <number> <monsters>!<name> ran down the hall.Sadly, <name> was <verb> by all the <monsters>!\n\nPoor <name>. Better luck next time!"
    required init?(coder aDecoder: NSCoder) {
        self.titles = aDecoder.decodeObject(forKey: "titles") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.verb = aDecoder.decodeObject(forKey: "verb") as? String
        self.number = aDecoder.decodeObject(forKey: "number") as? Int
        self.didWin = aDecoder.decodeBool(forKey: "didWin")
        if let type = aDecoder.decodeInteger(forKey: "type") as Int? {
            self.type = StoryType(rawValue: type)!
        } else {
            self.type = StoryType.zombies
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.titles, forKey :"titles")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.verb, forKey: "verb")
        aCoder.encode(self.number, forKey: "verb")
        aCoder.encode(self.didWin, forKey: "verb")
        aCoder.encode(self.type.rawValue, forKey: "verb")
    }
    init(type: StoryType) {
        self.type = type
        if type == .zombies {
            self.titles = "Untitled zombie story"
        } else if type == .vampires {
            self.titles = "Untitled vampire story"
        } else if type == .aliens {
            self.titles = "Untitled alien story"
        }
    }
    fileprivate func replaceText(_ text : String, withText: String, inString: String) -> String {
        return inString.replacingOccurrences(of: text, with: withText, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func generateStory(_ monsterWin: Bool) -> String {
        var storyText = ""
        
        if monsterWin {
            storyText = winStory
        } else {
            storyText = loseStory
        }
        var monster = "zombies"
        if type == .vampires {
            monster = "vampires"
        } else if type == .aliens {
            monster = "aliens"
        }
        
        if verb != nil {
            storyText = replaceText("<verb>", withText: verb!, inString: storyText)
        }
        if number != nil {
            storyText = replaceText("<number>", withText: String(number!), inString: storyText)
        }
        
        storyText = replaceText("<monsters>", withText: monster, inString: storyText)
        return storyText
    }
}
