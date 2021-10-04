//
//  CartViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/08.
//

import RxSwift
import RxCocoa
import Action

class CartViewModel: CommonViewModel {
    let cartModel = CartModel.shared
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let enableSub = BehaviorSubject<Bool>(value: true)
    let rootVC: UIViewController!
    let selectVC: UIViewController!
    
    var somethingEmpty = false
    var allEmpty = true
    
    override init(title: String, sceneCoordinator: SceneCoordinatorType) {
        rootVC = appDelegate.window!.rootViewController
        selectVC = rootVC.children[1]
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        
        cartModel.somethingEmpty
            .subscribe(onNext: { [unowned self] bool in
                self.somethingEmpty = bool
            })
            .disposed(by: rx.disposeBag)
        
        cartModel.colorItemSubject
            .subscribe(onNext: { [unowned self] items in
                for item in items {
                    if item.itemName! != "default" && item.isEmpty == false {
                        self.allEmpty = false
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        cartModel.colorItemSubject
            .map { items -> Bool in
                var cnt = 0
                for item in items {
                    if item.itemName! == "default" {
                        cnt += 1
                    }
                }
                if cnt == 3 { return false }
                else { return true }
            }
            .bind(to: enableSub)
            .disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("cart VM deinited")
    }
    
    lazy var userInfoAction: Action<Void, Void> = {
        return Action { [unowned self] in
            if self.allEmpty == true {
                let VM = AllemptyViewModel(title: "allempty", sceneCoordinator: self.sceneCoordinator)
                let vc = Scene.allEmpty(VM)
                return self.sceneCoordinator.transition(to: vc, using: .push, animated: false).asObservable().map{ _ in }
            } else if self.somethingEmpty == false {
                let uiVM = UserinfoViewModel(inCode: 1, title: "userinfo", sceneCoordinator: self.sceneCoordinator)
                let vc = Scene.userinfo(uiVM)
                return self.sceneCoordinator.transition(to: vc, using: .push, animated: false).asObservable().map{ _ in }
            } else {
                let csVM = CartSelectViewModel(title: "cartSelect", sceneCoordinator: self.sceneCoordinator)
                let vc = Scene.cartSelect(csVM)
                return self.sceneCoordinator.transition(to: vc, using: .push, animated: false).asObservable().map{ _ in }
            }
        }
    }()
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: false).asObservable().map { _ in }
    }
}
