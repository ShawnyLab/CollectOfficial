//
//  CartSelectViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/17.
//

import Action
import RxSwift
import RxCocoa


class CartSelectViewModel: CommonViewModel {
    let cart = CartModel.shared
    
    lazy var userInfoAction: Action<Void, Void> = {
        return Action { [unowned self] in
            let uiVM = UserinfoViewModel(inCode: 1, title: "userinfo", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.userinfo(uiVM)
            self.sceneCoordinator.close(animated: false)
            return self.sceneCoordinator.transition(to: vc, using: .push, animated: false).asObservable().map{ _ in }
        }
    }()
    
    lazy var cartKakaoAction: Action<Void, Void> = {
        return Action { [unowned self] in
            let VM = CartKakaoViewModel(title: "cartkakao", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.cartKakao(VM)
            return self.sceneCoordinator.transition(to: vc, using: .push, animated: false).asObservable().map{ _ in }
        }
    }()
    
    deinit {
        print("cartSelect VM deinited")
    }
}
