//
//  CartKakaoViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/17.
//

import Action
import RxCocoa
import RxSwift

class CartKakaoViewModel: CommonViewModel {
    let cart = CartModel.shared
    
    lazy var userInfoAction: Action<Void, Void> = {
        return Action { [unowned self] in
            let uiVM = UserinfoViewModel(inCode: 2, title: "userinfo", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.userinfo(uiVM)
            return self.sceneCoordinator.transition(to: vc, using: .push, animated: false).asObservable().map{ _ in }
        }
    }()
    
    lazy var staffAction: Action<Void, Void> = {
        return Action { [unowned self] in
            let uiVM = UserinfoViewModel(inCode: 3, title: "userinfo", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.userinfo(uiVM)
            return self.sceneCoordinator.transition(to: vc, using: .push, animated: false).asObservable().map{ _ in }
        }
    }()
    
    deinit {
        print("CartKakaoVM deinited")
    }
}
