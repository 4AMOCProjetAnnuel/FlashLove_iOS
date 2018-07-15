//
//  CustomNotifications.swift
//  FlashLuv
//
//  Created by Isma Dia on 11/07/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

class CustomNotifications {
    let cloudMessagingKey = "AAAAB3Q73EI:APA91bGTGzl844pGXaMT4NdsFbgA0fmQmd_rF6N4G3LCsgQyEvWUGaYD0E12a329aeOO3snFLpUYfVR8Z9r9kLzjgh6KsqMODFPpAOLhJLaiB_MDPFW6dgHhHrIo9IC0f83fasdFFtsK"

    static func sendNotication(fcmToken : String, uid: String, from : String, conversationId : String?){
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else {
            return
        }
        var notificationRequest = URLRequest(url: url)
        notificationRequest.httpMethod = "POST"
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
        "Authorization":"key=AAAAB3Q73EI:APA91bGTGzl844pGXaMT4NdsFbgA0fmQmd_rF6N4G3LCsgQyEvWUGaYD0E12a329aeOO3snFLpUYfVR8Z9r9kLzjgh6KsqMODFPpAOLhJLaiB_MDPFW6dgHhHrIo9IC0f83fasdFFtsK"
        ]
        var parameters : [String : Any] = [:]
        guard let convId = conversationId else {
            return
        }
        if (from.elementsEqual("quizz") && !convId.elementsEqual("")){
            parameters = [
                "to": fcmToken,
                "notification" : [
                    "body" : "You've just been flashed by",
                    "title": "Quiz Alert"
                ],
                "data" : [
                    "conversationId" : "\(conversationId)",
                    "flashedUserId" : "\(uid)",
                    "flashingUserId" : Auth.auth().currentUser?.uid
                ],
                ]
        }else {
            parameters = [
                "to": fcmToken,
                "notification" : [
                    "body" : "You've just been flashed by",
                    "title": "Flash Alert"
                ],
                "data" : [
                    "flashedUserId" : "\(uid)",
                    "flashingUserId" : Auth.auth().currentUser?.uid
                ],
                ]
        }
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)

    }
}
