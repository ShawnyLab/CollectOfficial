//
//  BrandViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/04.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

class BrandViewModel: CommonViewModel {
    let service = Service.shared
    let bag = DisposeBag()
    
    var brandsSubject = BehaviorSubject<[BrandModel]>(value: [])
    
    override init(title: String, sceneCoordinator: SceneCoordinatorType) {
        
        brandsSubject = service.brandSubject
        super.init(title: title, sceneCoordinator: sceneCoordinator)
    }
    
    lazy var brandMainAction: Action<BrandModel, Void> = {
        return Action { brand in
            let brandmainVM = BrandMainViewModel(brand: brand, title: "brandmain", sceneCoordinator: self.sceneCoordinator)
            let brandmainVC = Scene.brandmain(brandmainVM)
            
            return self.sceneCoordinator.transition(to: brandmainVC, using: .push, animated: true).asObservable().map{ _ in }
        }
    }()
}
