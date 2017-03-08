//
//  CircleViewModel.swift
//  LearningRxSwift
//
//  Created by Marian on 3/6/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation
import ChameleonFramework
import RxSwift
import RxCocoa

class CircleViewModel {
    
    var centerVariable = Variable<CGPoint?>(.zero) // Create one variable that will be changed and observed
    var backgroundColorObservable: Observable<UIColor>! // Create observable that will change backgroundColor based on center
    
    init() {
        setup()
    }
    
    func setup() {
        backgroundColorObservable = centerVariable.asObservable()
            .map { center in
                guard let center = center else { return UIColor.flatten(.black)() }
                
                let red: CGFloat = ((center.x  + center.y).truncatingRemainder(dividingBy: 255.0) / 255.0) // We just manipulate red, but you can do w/e
                let green: CGFloat = 100.0
                let blue: CGFloat = 0.0
                
//                let red: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max) 
//                let green: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
//                let blue: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
                return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
        }
    }
    
}
