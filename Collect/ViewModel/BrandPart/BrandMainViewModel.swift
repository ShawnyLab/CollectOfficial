//
//  BrandMainViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/04.
//

import RxCocoa
import RxSwift
import Action
import NSObject_Rx

class BrandMainViewModel: CommonViewModel {
    
    let service = Service.shared
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let rootVC: UIViewController!
    let selectVC: UIViewController!
    
    var brandModel: BrandModel!
    var brandSubject = BehaviorRelay<BrandModel>(value: BrandModel(name: "", wallColor: ""))
    var itemsSubject = BehaviorRelay<[ItemModel]>(value: [])
    var logoDriver: Driver<UIImage>
    var desDriver: Driver<UIImage>
    var wallpaperObservable: Driver<[URL]>
    var blackOrWhiteSubject = BehaviorSubject<String>(value: "Black")
    init(brand: BrandModel, title: String, sceneCoordinator: SceneCoordinatorType) {
        self.brandModel = brand        
        brandSubject.accept(brandModel)
        blackOrWhiteSubject.onNext(brandModel.blackOrWhite!)
        logoDriver = Driver.just(brandModel.logoImage)
        desDriver = Driver.just(brandModel.desImage)
        wallpaperObservable = Driver.just(brandModel.wallPaper)
        rootVC = appDelegate.window!.rootViewController!
        selectVC = rootVC.children.last!
        super.init(title: title, sceneCoordinator: sceneCoordinator)
    }
    
    
    deinit {
        print("BrandMainViewModel deinited")
    }
    
    func updateViewModel() {
        service.fetchItems(brandName: brandModel.name!)
            .map { $0.sorted(by: {$0.name! < $1.name!})}
            .map { $0.sorted(by: {$0.date! > $1.date!})}
            .bind(to: itemsSubject)
            .disposed(by: rx.disposeBag)
    }
    
    lazy var cartPresentAction: Action<Void, Void> = {
        return Action { [unowned self] in
            let cartVM = CartViewModel(title: "cart", sceneCoordinator: self.sceneCoordinator)
            let cartVC = Scene.cart(cartVM)
            return self.sceneCoordinator.transition(to: cartVC, using: .push, animated: false).asObservable().map{ _ in }
        }
    }()
    
    lazy var itemDetailAction: Action<ItemModel, Void> = {
        return Action { [unowned self] item in
            let itemdetailVM = ItemDetailViewModel(item: item, title: "itemdetail", sceneCoordinator: self.sceneCoordinator)
            let itemdetailVC = Scene.itemdetail(itemdetailVM)
            
            return self.sceneCoordinator.transition(to: itemdetailVC, using: .push, animated: true).asObservable().map{ _ in }
        }
    }()
    
    lazy var sortAction: Action<Void, Void> = {
        return Action { [unowned self] in
            let sortVM = SortViewModel(title: "sort", sceneCoordinator: self.sceneCoordinator)
            let sortVC = Scene.sort(sortVM)
            return self.sceneCoordinator.transition(to: sortVC, using: .modal, animated: false)
                .asObservable().map{ _ in }
        }
    }()
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true).asObservable().map{ _ in }
    }
}
