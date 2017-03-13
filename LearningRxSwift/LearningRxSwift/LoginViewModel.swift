//
//  LoginViewModel.swift
//  LearningRxSwift
//
//  Created by Marian on 3/6/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class LoginViewModel {

    
    
    let validatedUsername: Observable<Bool>
    let validatedPassword: Observable<Bool>
    
    // Is signup button enabled
    let signInEnabled: Observable<Bool>
    
    // Has user signed in
    let signedIn: Observable<Bool>
    
    // Is signing process in progress
    //    let signingIn: Observable<Bool>
    var signingIn : Observable<Bool>
    
    init(input: (
        username: Observable<String>,
        password: Observable<String>,
        loginTaps: Observable<Void>
        )
        ) {
        
        
        validatedUsername = input.username
            .map { username in
                return username.characters.count > 5
            }
            .shareReplay(1)
        
        validatedPassword = input.password
            .map { password in
                return  password.characters.count > 5
            }
            .shareReplay(1)
        
        
        
        let signingInActivityIndicator = ActivityIndicator()
        self.signingIn = signingInActivityIndicator.asObservable()
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { ($0, $1) }
        
        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { (username, password) -> Observable<Bool> in
                return SignUpAPI.signup(username, password: password).trackActivity(signingInActivityIndicator)
            }.shareReplay(1)

        
        signInEnabled = Observable.combineLatest(
            validatedUsername,
            validatedPassword,
            signingIn
        )   { (username: Bool, password: Bool, signing: Bool) -> Bool in
            username &&
                password &&
                !signing
            }
            .distinctUntilChanged()
            .shareReplay(1)
    }
}
