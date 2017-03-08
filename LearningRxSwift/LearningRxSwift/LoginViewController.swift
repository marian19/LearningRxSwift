//
//  LoginViewController.swift
//  LearningRxSwift
//
//  Created by Marian on 3/6/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    fileprivate var loginViewModel: LoginViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewModel()
        // Do any additional setup after loading the view.
        usernameTextField.rx.text.bindTo(loginViewModel.username).addDisposableTo(disposeBag)
        passwordTextField.rx.text.bindTo(loginViewModel.password).addDisposableTo(disposeBag)
        usernameTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
            print("return pressed")
        }).addDisposableTo(disposeBag)
        
        passwordTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
            print("return pressed")
        }).addDisposableTo(disposeBag)
        //enable login button
        loginViewModel.isValid?.subscribe(onNext:{ [weak self] valid in
            
            self?.loginButton.isEnabled = valid
            
        }).addDisposableTo(disposeBag)
        
        // OR
        //        loginViewModel.isValid.map{ $0 }?
        //            .bindTo(loginButton.rx.isEnabled).addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

