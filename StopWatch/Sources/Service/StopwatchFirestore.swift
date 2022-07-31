//
//  StopwatchFirestore.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/31.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol StopwatchFirestoreProtocol {
    func saveStopwatchData(timer: StopwatchTimer)
}

final class StopwatchFirestore: StopwatchFirestoreProtocol {
    
    let db = Firestore.firestore()
   
    func saveStopwatchData(timer: StopwatchTimer) {
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
