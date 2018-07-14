//
//  Conversation.swift
//  FlashLuv
//
//  Created by Isma Dia on 13/07/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit

class Conversation: NSObject {
    var fromId : String?
    var timestamp : NSNumber?
    var toId : String?
    var text : String?
    var name : String?

    init( fromId : String, timestamp : NSNumber, toId : String, text : String, name : String) {
        self.fromId = fromId
        self.timestamp = timestamp
        self.toId = toId
        self.text = text
        self.name = name
    }
}
