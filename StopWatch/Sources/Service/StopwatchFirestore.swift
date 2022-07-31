//
//  StopwatchFirestore.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/31.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class StopwatchFirestore {
    
    let db = Firestore.firestore()
   
    func saveStopwatchData(timer: Timer) {
        do {
            guard let user = UserDefaults.standard.string(forKey: "userID") else { return }
            try db.collection("stopwatch").document(user).setData(from: timer)
            #if DEBUG
            print("Success save")
            #endif
        } catch let error {
            //TODO: - Handel error
            #if DEBUG
            print("Error: To do handel \(error.localizedDescription)")
            #endif
        }
    }
    
}
