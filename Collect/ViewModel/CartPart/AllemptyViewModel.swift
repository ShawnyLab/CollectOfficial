//
//  AllemptyViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/28.
//

import Action

class AllemptyViewModel: CommonViewModel {
    
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
        print("AllemptyVM deinited")
    }
}
