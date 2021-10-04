//
//  ColoritemListViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import RxSwift
import RxCocoa
import Action
import Firebase

class ColoritemListViewModel: CommonViewModel {
    let service = Service.self
    var itemModel: ItemModel!
    let ref = Database.database().reference()
    
    let colorItemSubject = BehaviorSubject<[ColorItemModel]>(value: [])
    
    init(itemModel: ItemModel, title: String, sceneCoordinator: SceneCoordinatorType) {
        self.itemModel = itemModel
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        
        colorItemSubject.onNext(self.itemModel.colorItems)
        
    }
    
    lazy var itemAddAction: Action<Void, Void> = {
        return Action {
            let ciVM = ColoritemEditViewModel(itemModel: self.itemModel, title: "coloredit", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.coloritemEdit(ciVM)
            return self.sceneCoordinator.transition(to: vc, using: .push, animated: true).asObservable().map{ _ in }
        }
    }()
    
    func removeFromColorList(_ VC: UIViewController, _ colorIt: ColorItemModel) {
        let alert = UIAlertController(title: "알림", message: "색상을 제거하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            
            self.ref.child("1").child("Brand").child(colorIt.brand!).child("Item").child(colorIt.itemName!).child("colorItems").child(colorIt.fileName!).removeValue()
            var colorItems: [ColorItemModel] = []
            
            self.colorItemSubject.subscribe(onNext: { colorArr in
                colorItems = colorArr
            })
            .disposed(by: self.rx.disposeBag)
            
            for i in 0..<colorItems.count {
                if colorItems[i].fileName! == colorIt.fileName! {
                    colorItems.remove(at: i)
                }
            }
            
            self.colorItemSubject.onNext(colorItems)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
        }))
        VC.present(alert, animated: true, completion: nil)
    }
    

}
