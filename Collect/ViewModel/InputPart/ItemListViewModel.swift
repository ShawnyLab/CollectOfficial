//
//  ItemListViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//
import RxSwift
import RxCocoa
import Action
import Firebase

class ItemListViewModel: CommonViewModel {
    let service = Service.shared
    var brandModel: BrandModel!
    var itemModelSubject = BehaviorSubject<[ItemModel]>(value: [])
    let ref = Database.database().reference()
    
    init(brand: BrandModel, title: String, sceneCoordinator: SceneCoordinatorType) {
        self.brandModel = brand
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        
        service.fetchItems(brandName: brandModel.name!)
            .map { $0.sorted(by: { $0.name! < $1.name!})}
            .bind(to: itemModelSubject)
            .disposed(by: rx.disposeBag)
    }
    
    lazy var itemAddAction: Action<Void, Void> = {
        return Action {
            let itemeditVM = ItemEditViewModel(brand: self.brandModel, title: "brandedit", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.itemEdit(itemeditVM)
            return self.sceneCoordinator.transition(to: vc, using: .push, animated: true).asObservable().map{ _ in }
        }
    }()
    
    func removeFromItemList(_ VC: UIViewController, _ item: ItemModel) {
        let alert = UIAlertController(title: "알림", message: "제품을 제거하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.ref.child("1").child("Brand").child(item.brand!).child("Item").child(item.name!).removeValue()
            var items: [ItemModel] = []
            
            self.itemModelSubject.subscribe(onNext: { itemArr in
                items = itemArr
            })
            .disposed(by: self.rx.disposeBag)
            
            for i in 0..<items.count {
                if items[i].name == item.name {
                    items.remove(at: i)
                }
            }
            
            self.itemModelSubject.onNext(items)
            
        }))
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
        }))
        VC.present(alert, animated: true, completion: nil)
    }
    
    lazy var colorListAction: Action<ItemModel, Void> = {
        return Action { itemModel in
            let colorVM = ColoritemListViewModel(itemModel: itemModel, title: "colorlist", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.coloritemList(colorVM)
            return self.sceneCoordinator.transition(to: vc, using: .push, animated: true).asObservable().map{ _ in }
        }
    }()
}
