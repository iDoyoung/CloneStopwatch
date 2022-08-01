//
//  SocialLoginService.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/31.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

protocol SocialLoginProtocol {
    func autoLogin(completion: @escaping () -> Void)
    func googleLogin(source: UIViewController, completion: @escaping () -> Void)
    func signOut(completion: @escaping () -> Void)
}

final class SocialLoginService: SocialLoginProtocol {
        
    func autoLogin(completion: @escaping () -> Void) {
        if Auth.auth().currentUser != nil{
            completion()
        }
    }
    
    func googleLogin(source: UIViewController, completion: @escaping () -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: source) { user, error in
            if let error = error {
                #if DEBUG
                print("Error: \(error.localizedDescription), To do handler error")
                #endif
                return
            }
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    #if DEBUG
                    print("Error: \(error.localizedDescription), To do handler error")
                    #endif
                    return
                } else {
                    guard let result = authResult else { return }
                    UserDefaults.standard.set(result.user.uid, forKey: "userID")
                    completion()
                }
            }
        }
    }
    
    func signOut(completion: @escaping () -> Void) {
        do {
            try Auth.auth().signOut()
            completion()
        } catch {
            fatalError()
        }
    }
    
}
