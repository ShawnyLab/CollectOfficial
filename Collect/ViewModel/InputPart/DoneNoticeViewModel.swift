//
//  DoneNoticeViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/19.
//

import Firebase
import RxSwift
import RxCocoa
import Action

class DoneNoticeViewModel: CommonViewModel {
    let doneNoticeSub = BehaviorSubject<[NoticeModel]>(value: [])
    let ref = Database.database().reference()
    
    override init(title: String, sceneCoordinator: SceneCoordinatorType) {
        super.init(title: title, sceneCoordinator: sceneCoordinator)
        
        var doneNoticeArr: [NoticeModel] = []
        
        Database.database().reference().child("1").child("DoneNotice").observe(.value) { DataSnapshot in
            doneNoticeArr.removeAll()
            for items in DataSnapshot.children.allObjects as! [DataSnapshot] {
                let value = items.value as! [String: Any]
                let noticeModel = NoticeModel(JSON: value)!
                doneNoticeArr.insert(noticeModel, at: 0)
                self.doneNoticeSub.onNext(doneNoticeArr)
                
                Database.database().reference().child("1").child("DoneNotice").child(noticeModel.key!).child("Item").observeSingleEvent(of: .value) { DataSnapsho in
                    for item in DataSnapsho.children.allObjects as! [DataSnapshot] {
                        noticeModel.colorItems.insert(item.value as? String ?? "ItemCodeErr", at: 0)
                        self.doneNoticeSub.onNext(doneNoticeArr)
                    }
                }
            }
        }

    }
    
    func removeAction(_ VC: UIViewController, _ notice: NoticeModel) {
        let alert = UIAlertController(title: "알림", message: "제품을 제거하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.ref.child("1").child("DoneNotice").child(notice.key!).removeValue()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
        }))
        VC.present(alert, animated: true, completion: nil)
    }
    
    
}
