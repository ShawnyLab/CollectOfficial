//
//  UserinfoViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import RxSwift
import RxCocoa
import Action

class UserinfoViewModel: CommonViewModel {
    var topCode: Int!
    let phoneSub = BehaviorSubject<String>(value: "")
    let nameSub = BehaviorSubject<String>(value: "")
    var phone = ""
    var name = ""
    
    init(inCode: Int, title: String, sceneCoordinator: SceneCoordinatorType) {
        topCode = inCode
        
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        
        phoneSub.subscribe(onNext: { [unowned self] str in
            self.phone = str
        })
        .disposed(by: rx.disposeBag)
        
        nameSub.subscribe(onNext: { [unowned self] str in
            self.name = str
        })
        .disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("userinfo VM deinited")
    }
    
    lazy var finalAction: Action<Void, Void> = {
        return Action { [unowned self] in
            if self.topCode == 1 {
                let VM = FinalViewModel(phoneNum: self.phone, name: self.name, title: "final", sceneCoordinator: self.sceneCoordinator)
                let vc = Scene.final(VM)
                return self.sceneCoordinator.transition(to: vc, using: .push, animated: true).asObservable().map{ _ in }
            } else if self.topCode == 2 {
                let VM = FinalTwoViewModel(phoneNum: self.phone, name: self.name, title: "finalTwo", sceneCoordinator: self.sceneCoordinator)
                let vc = Scene.finalTwo(VM)
                return self.sceneCoordinator.transition(to: vc, using: .push, animated: false).asObservable().map{ _ in }
            } else {
                let VM = FinalThreeViewModel(phoneNum: self.phone, name: self.name, title: "finalThree", sceneCoordinator: self.sceneCoordinator)
                let vc = Scene.finalThree(VM)
                return self.sceneCoordinator.transition(to: vc, using: .push, animated: false).asObservable().map{ _ in }
            }
        }
    }()
    
    lazy var accessAction: Action<Void, Void> = {
        return Action { [unowned self] in
            let VM = AccessViewModel(title: "access", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.access(VM)
            return self.sceneCoordinator.transition(to: vc, using: .modal, animated: false).asObservable().map{ _ in }
        }
    }()
    
}
