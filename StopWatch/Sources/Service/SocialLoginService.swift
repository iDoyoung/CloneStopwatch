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
    
    
}

final class SocialLoginService {
    
    func googleLogin(source: UIViewController, completion: @escaping () -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: source) { [unowned self] user, error in
            if let error = error {
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
                    print(authResult?.user.uid)
                    completion()
                }
            }
        }
    }
    
}
