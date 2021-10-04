//
//  BrandEditViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import RxSwift
import RxCocoa
import Action
import Firebase

class BrandEditViewModel: CommonViewModel {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var rootVC: UIViewController!
    var topVC: BrandListViewController!
    
    let nameSub = BehaviorSubject<String>(value: "")
    let colorSub = BehaviorSubject<String>(value: "")
    
    var nameT = ""
    var colorT = ""
    
    let ref = Database.database().reference()
    
    override init(title: String, sceneCoordinator: SceneCoordinatorType) {
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        
        rootVC = appDelegate.window!.rootViewController
        
        topVC = rootVC?.children.last! as? BrandListViewController
        
        colorSub.subscribe(onNext: { str in
            self.colorT = str
        })
        .disposed(by: rx.disposeBag)
        
        nameSub.subscribe(onNext: { str in
            self.nameT = str
        })
        .disposed(by: rx.disposeBag)
    }
    
    
    lazy var addAction: Action<Void, Void> = {
        return Action {
            var brands: [BrandModel] = []

            self.topVC.viewModel.brandListSubject
                .subscribe(onNext: { brandlist in
                    brands = brandlist
                })
                .disposed(by: self.rx.disposeBag)
            
            let brand = BrandModel(name: self.nameT, wallColor: self.colorT)
            
            brands.append(brand)
            brands.sort(by: {$0.name! < $1.name!})
            
            self.ref.child("1").child("Brand")
                .child(self.nameT).setValue(["name": self.nameT, "wallColor": self.colorT])
            
            self.topVC.viewModel.brandListSubject.onNext(brands)
            return self.sceneCoordinator.close(animated: false).asObservable().map { _ in }
        }
    }()
}
