//
//  BrandListViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import RxSwift
import RxCocoa
import Action
import Firebase

class BrandListViewModel: CommonViewModel {
    
    let service = Service.shared
    
    let brandListSubject = BehaviorSubject<[BrandModel]>(value: [])
    let ref = Database.database().reference()
    
    override init(title: String, sceneCoordinator: SceneCoordinatorType) {
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        
        service.brandSubject
            .bind(to: self.brandListSubject)
            .disposed(by: rx.disposeBag)
    }
    
    lazy var brandAddAction: Action<Void, Void> = {
        return Action {
            let brandeditVM = BrandEditViewModel(title: "brandedit", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.brandEdit(brandeditVM)
            return self.sceneCoordinator.transition(to: vc, using: .push, animated: true).asObservable().map{ _ in }
        }
    }()
    
    lazy var itemListAction: Action<BrandModel, Void> = {
        return Action { brand in 
            let itemlistVM = ItemListViewModel(brand: brand, title: "itemlist", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.itemList(itemlistVM)
            return self.sceneCoordinator.transition(to: vc, using: .push, animated: true).asObservable().map{ _ in }
        }
    }()
    
    func removeFromBrandList(_ VC: UIViewController, _ brand: BrandModel) {
        let alert = UIAlertController(title: "알림", message: "브랜드를 제거하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.ref.child("1").child("Brand").child(brand.name!).removeValue()
            var brands: [BrandModel] = []
            
            self.service.brandSubject.subscribe(onNext: { brandArr in
                brands = brandArr
            })
            .disposed(by: self.rx.disposeBag)
            
            for i in 0..<brands.count {
                if brands[i].name == brand.name {
                    brands.remove(at: i)
                }
            }
            
            self.service.brandSubject.onNext(brands)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
        }))
        VC.present(alert, animated: true, completion: nil)
    }
    
}
