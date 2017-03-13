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
    @IBOutlet weak var signingInActivityIndicatorView: UIActivityIndicatorView!

    fileprivate var viewModel: LoginViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LoginViewModel(input: (username: usernameTextField.rx.text.orEmpty.asObservable(), password: passwordTextField.rx.text.orEmpty.asObservable(), loginTaps: loginButton.rx.tap.asObservable()))
        
        // bind results to  {
        viewModel.signInEnabled
            .subscribe(onNext: { [weak self] valid  in
                self?.loginButton.isEnabled = valid
                self?.loginButton.alpha = valid ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)
        
        
        viewModel.signingIn
            .bindTo(signingInActivityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.signedIn
            .subscribe(onNext: { signedIn in
                print("User signed in \(signedIn)")
            })
            .disposed(by: disposeBag)
        //}
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
    
   
    

    
}

