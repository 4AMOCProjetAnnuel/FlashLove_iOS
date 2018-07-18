//
//  Conversation.swift
//  FlashLuv
//
//  Created by Isma Dia on 13/07/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import Firebase

class Conversation: NSObject {
    var fromId : String?
    var timestamp : NSNumber?
    var toId : String?
    var recordedHeartBeat : String?
    var recordedHumidity : String?
    var recordedTemperature : String?
    var quiz : [QuizItem]?
    var conversationId : String?
    

    init( fromId : String, timestamp : NSNumber, toId : String, recordedHeartBeat : String, recordedHumidity : String,recordedTemperature : String , quiz : [QuizItem] ) {
        self.fromId = fromId
        self.timestamp = timestamp
        self.toId = toId
        self.quiz = quiz
        self.recordedHumidity = recordedHumidity
        self.recordedHeartBeat = recordedHeartBeat
        self.recordedTemperature = recordedTemperature
    }
    
    func conversationParnerId () -> String? {
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        }else {
            return fromId
        }
    }
}

class QuizItem {
    var question : String?
    var reponse : String?
    
}
