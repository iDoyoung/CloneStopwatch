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
    func getStopwatchData(completion: @escaping (StopwatchTimer) -> Void)
    func saveStopwatchData(timer: StopwatchTimer)
}

final class StopwatchFirestore: StopwatchFirestoreProtocol {
    
    let db = Firestore.firestore()
   
    func getStopwatchData(completion: @escaping (StopwatchTimer) -> Void) {
        guard let user = UserDefaults.standard.string(forKey: "userID") else { return }
        let documentReference = db.collection("stopwatch").document(user)
        documentReference.getDocument(as: StopwatchTimer.self) { result in
            switch result {
            case .success(let timer):
                completion(timer)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
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
