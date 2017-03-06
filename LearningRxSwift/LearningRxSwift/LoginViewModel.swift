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
    var username = Variable<String?>("")
    var password = Variable<String?>("")
    var isValid : Observable<Bool>?
    
    
    init() {
        setup()
    }
    
    func setup() {
        isValid = Observable.combineLatest( username.asObservable(), self.password.asObservable())
        {
            return ($0?.characters.count)! > 0
                && ($1?.characters.count)! > 0
        }
    }
}
