//
//  SelectViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/04.
//

import RxSwift
import RxCocoa
import Action

class SelectViewModel: CommonViewModel {
    let service = Service.shared
    let bag = DisposeBag()
    
    var brandsSubject = BehaviorRelay<[BrandModel]>(value: [])
    var bannerUrlSubject = BehaviorRelay<[URL]>(value: [])
    var bannerSubject = BehaviorRelay<[URL: String]>(value: [:])
    
    override init(title: String, sceneCoordinator: SceneCoordinatorType) {
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        service.brandSubject
            .map { $0.sorted(by: {$0.name! < $1.name!})}
            .bind(to: brandsSubject)
            .disposed(by: rx.disposeBag)
    
        service.bannerUrlSubject
            .bind(to: bannerUrlSubject)
            .disposed(by: rx.disposeBag)
        
        service.bannerSubject
            .bind(to: bannerSubject)
            .disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("SelectVM deinited")
    }
    
    lazy var brandMainAction: Action<BrandModel, Void> = {
        return Action { [unowned self] brand in
            let brandmainVM = BrandMainViewModel(brand: brand, title: "brandmain", sceneCoordinator: self.sceneCoordinator)
            let brandmainVC = Scene.brandmain(brandmainVM)
            
            return self.sceneCoordinator.transition(to: brandmainVC, using: .push, animated: true).asObservable().map{ _ in }
        }
    }()
    
    lazy var bannerAction: Action<URL, Void> = {
        return Action { [unowned self] url in
            let bannerVM = BannerViewModel(url: url, title: "banner", sceneCoordinator: self.sceneCoordinator)
            let bannerVC = Scene.banner(bannerVM)
            
            return self.sceneCoordinator.transition(to: bannerVC, using: .modal, animated: false)
                .asObservable().map{ _ in }
        }
    }()
    
    func changeToUrl(ref: String) -> BehaviorSubject<URL?> {
        let urlOb = BehaviorSubject<URL?>(value: nil)
        let newRef = service.storageRef.child("1").child("BannerLink").child(ref)
        newRef.downloadURL { url, err in
            if let error = err {
                print(error)
            } else {
                urlOb.onNext(url)
            }
        }
        return urlOb
    }
}
