//
//  NoticeViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import UIKit

class NoticeViewController: UIViewController, ViewModelBindableType {

    var viewModel: NoticeViewModel!
    @IBOutlet weak var noticeTableView: UITableView!
    @IBOutlet weak var editingButton: UIButton!
    @IBOutlet weak var doneThings: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        doneThings.rx.action = viewModel.doneNoticeAction
        backButton.rx.action = viewModel.commonPopAction
        
        noticeTableView.layer.cornerRadius = 24
        noticeTableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        editingButton.rx.action = viewModel.brandListAction
        
        viewModel.noticeSub
            .bind(to: noticeTableView.rx.items(cellIdentifier: "noticetableCell", cellType: NoticeTableCell.self)) { _, notice, cell in
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
                
                cell.sendToBox.rx.tap
                    .subscribe(onNext: {
                        self.viewModel.removeFromNoticeList(self, notice)
                    })
                    .disposed(by: self.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)
    }
}

extension NoticeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(77)
    }
    
}

class NoticeTableCell: UITableViewCell {
    
    @IBOutlet weak var noticeText: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemText: UILabel!
    @IBOutlet weak var sendToBox: UIButton!
    
    func updateUI() {
        containerView.layer.cornerRadius = 24
    }
}
