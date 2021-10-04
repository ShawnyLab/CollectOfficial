//
//  NoticeViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import RxSwift
import RxCocoa
import Action
import Firebase

class NoticeViewModel: CommonViewModel {
    let noticeSub = BehaviorSubject<[NoticeModel]>(value: [])
    let ref = Database.database().reference()
    
    override init(title: String, sceneCoordinator: SceneCoordinatorType) {
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        
        
        var noticeArr: [NoticeModel] = []
        
        Database.database().reference().child("1").child("Notice").observe(.value) { DataSnapshot in
            noticeArr.removeAll()
            for items in DataSnapshot.children.allObjects as! [DataSnapshot] {
                let value = items.value as! [String: Any]
                let noticeModel = NoticeModel(JSON: value)!
                noticeArr.insert(noticeModel, at: 0)
                self.noticeSub.onNext(noticeArr)
                
                Database.database().reference().child("1").child("Notice").child(noticeModel.key!).child("Item").observeSingleEvent(of: .value) { DataSnapsho in
                    for item in DataSnapsho.children.allObjects as! [DataSnapshot] {
                        noticeModel.colorItems.insert(item.value as? String ?? "", at: 0)
                        self.noticeSub.onNext(noticeArr)
                    }
                }
            }
        }
    }
    
    lazy var brandListAction: Action<Void, Void> = {
        return Action {
            let brandlistVM = BrandListViewModel(title: "brandlist", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.brandList(brandlistVM)
            return self.sceneCoordinator.transition(to: vc, using: .push, animated: true).asObservable().map{ _ in }
        }
    }()
    
    lazy var doneNoticeAction: Action<Void, Void> = {
        return Action {
            let VM = DoneNoticeViewModel(title: "donenotice", sceneCoordinator: self.sceneCoordinator)
            let vc = Scene.noticeDone(VM)
            return self.sceneCoordinator.transition(to: vc, using: .push, animated: true).asObservable().map{ _ in }
        }
    }()
    
    func removeFromNoticeList(_ VC: UIViewController, _ notice: NoticeModel) {
        let alert = UIAlertController(title: "알림", message: "알림보관함으로 보내시겠습니까? (취소를 누르시면 삭제됩니다)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in

            self.ref.child("1").child("Notice").child(notice.key!).removeValue()

            self.ref.child("1").child("DoneNotice").child(notice.key!).setValue(["key": notice.key!, "name": notice.name ?? "NameErr", "phoneNum": notice.phoneNum ?? "010Error", "timestamp": notice.timestamp!, "type": notice.type ?? "NoticeErr"])
            
            for item in notice.colorItems {
                self.ref.child("1").child("DoneNotice").child(notice.key!).child("Item").child(item).setValue(item)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.ref.child("1").child("Notice").child(notice.key!).removeValue()
            
        }))
        VC.present(alert, animated: true, completion: nil)
    }
}
