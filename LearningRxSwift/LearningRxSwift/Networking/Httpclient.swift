//
//  Httpclient.swift
//  LearningRxSwift
//
//  Created by Marian on 3/13/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpAPI {
    static func  signup(_ username: String, password: String) -> Observable<Bool>{
    
        let signupResult = arc4random() % 5 == 0 ? false : true
        
        return Observable.just(signupResult)
            .delay(1.0, scheduler: MainScheduler.instance)
    
    }

}
