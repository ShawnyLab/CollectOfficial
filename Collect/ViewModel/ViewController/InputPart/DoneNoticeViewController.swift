//
//  DoneNoticeViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/19.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class DoneNoticeViewController: UIViewController, ViewModelBindableType {

    var viewModel: DoneNoticeViewModel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func bindViewModel() {
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        backButton.rx.action = viewModel.commonPopAction
        
        tableView.layer.cornerRadius = 24
        
        viewModel.doneNoticeSub
            .bind(to: tableView.rx.items(cellIdentifier: "doneCell", cellType: DoneCell.self)) { _, notice, cell in
                var str = ""
                if notice.type == 1 {
                    str = "제품 열람"
                } else if notice.type == 2 {
                    str = "카카오 알림톡"
                } else if notice.type == 3 {
                    str = "직원 호출"
                }
                
                cell.noticeText.text = "\(notice.timestamp!.todayTime) / \(notice.name!)/ \(notice.phoneNum!) / \(str)"
                
                cell.itemText.text = notice.colorItems.joined(separator: "/")

                cell.removeBtn.rx.tap
                    .subscribe(onNext: {
                        self.viewModel.removeAction(self, notice)
                    })
                    .disposed(by: self.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)
    }

}

extension DoneNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(77)
    }
}

class DoneCell: UITableViewCell {
    
    @IBOutlet weak var noticeText: UILabel!
    @IBOutlet weak var itemText: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
}
