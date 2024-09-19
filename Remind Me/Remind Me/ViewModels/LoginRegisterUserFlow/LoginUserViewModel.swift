//
//  LoginUserViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 9/18/24.
//

import Foundation

protocol LoginUserViewModelDelegate: AnyObject {
    
}

final class LoginUserViewModel {
    
    weak var delegate: LoginUserViewModelDelegate?
    
    func signOut() {
        
    }
}
