//
//  ItemEditViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import RxSwift
import RxCocoa
import Action
import Firebase

class ItemEditViewModel: CommonViewModel {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var rootVC: UIViewController!
    var topVC: ItemListViewController!
    
    var brandModel: BrandModel!
    
    let ref = Database.database().reference()
    
    var name = ""
    let nameSub = BehaviorSubject<String>(value: "")
    var nameKor = ""
    let nameKorSub = BehaviorSubject<String>(value: "")
    var cost = 0
    let costSub = BehaviorSubject<Int>(value: 0)
    var des = ""
    let desSub = BehaviorSubject<String>(value: "")
    var madeIn = ""
    let madeInSub = BehaviorSubject<String>(value: "")
    var shape = ""
    let shapeSub = BehaviorSubject<String>(value: "")
    var size = ""
    let sizeSub = BehaviorSubject<String>(value: "")
    var material = ""
    let matSub = BehaviorSubject<String>(value: "")
    var isEx: Bool = false
    let isExSub = BehaviorSubject<Bool>(value: false)
    var date: Int64 = 0
    let dateSub = BehaviorSubject<Int64>(value: 0)
    var itemCode: String = ""
    let codeSub = BehaviorSubject<String>(value: "")
    
    init(brand: BrandModel, title: String, sceneCoordinator: SceneCoordinatorType) {
        self.brandModel = brand
        
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        rootVC = appDelegate.window!.rootViewController
        topVC = rootVC?.children.last! as? ItemListViewController
                
        nameSub.subscribe(onNext: { name in
            self.name = name
        })
        .disposed(by: rx.disposeBag)
        
        nameKorSub.subscribe(onNext: { name in
            self.nameKor = name
        })
        .disposed(by: rx.disposeBag)
        
        costSub.subscribe(onNext: { cost in
            self.cost = cost
        })
        .disposed(by: rx.disposeBag)
        
        desSub.subscribe(onNext: { name in
            self.des = name
        })
        .disposed(by: rx.disposeBag)
        
        madeInSub.subscribe(onNext: { name in
            self.madeIn = name
        })
        .disposed(by: rx.disposeBag)
        
        shapeSub.subscribe(onNext: { name in
            self.shape = name
        })
        .disposed(by: rx.disposeBag)
        
        sizeSub.subscribe(onNext: { name in
            self.size = name
        })
        .disposed(by: rx.disposeBag)
        
        matSub.subscribe(onNext: { name in
            self.material = name
        })
        .disposed(by: rx.disposeBag)
        
        isExSub.subscribe(onNext: { name in
            self.isEx = name
        })
        .disposed(by: rx.disposeBag)
        
        dateSub.subscribe(onNext: { name in
            self.date = name
        })
        .disposed(by: rx.disposeBag)
    }
    
    lazy var addAction: Action<Void, Void> = {
        return Action {
            var items: [ItemModel] = []
            self.topVC.viewModel.itemModelSubject
                .subscribe(onNext: { itemArr in
                    items = itemArr
                })
                .disposed(by: self.rx.disposeBag)
            
            let item = ItemModel(name: self.name, nameKor: self.nameKor, des: self.des, material: self.material, shape: self.shape, size: self.size, brand: self.brandModel.name!, cost: self.cost, madeIn: self.madeIn, date: self.date, itemCode: self.itemCode)
            
            items.append(item)
            items.sort(by: {$0.name! < $1.name!})
            
            self.ref.child("1").child("Brand").child(self.brandModel.name!).child("Item")
                .child(item.name!).setValue(["brand": self.brandModel.name!, "cost": self.cost, "date": self.date, "des": self.des, "isExclusive": self.isEx, "madeIn": self.madeIn, "material": self.material, "name": self.name, "nameKor": self.nameKor, "shape": self.shape, "size": self.size])

            self.topVC.viewModel.itemModelSubject
                .onNext(items)

            return self.sceneCoordinator.close(animated: false).asObservable().map { _ in }
        }
    }()
    
    
}

