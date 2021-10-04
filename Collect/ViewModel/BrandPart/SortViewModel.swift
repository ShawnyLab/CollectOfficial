//
//  SortViewModel.swift
//  Collect
//
//  Created by 박진서 on 2021/09/16.
//

import RxSwift
import Action

class SortViewModel: CommonViewModel {
    let service = Service.shared
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    lazy var sortNewAction: Action<Void, Void> = {
        return Action { [unowned self] in
            var newItems: [ItemModel] = []
            let nav = self.appDelegate.window?.rootViewController
            let vc = nav?.children.last as! BrandMainViewController
            vc.viewModel.itemsSubject.subscribe(onNext: { items in
                newItems = items.sorted(by: {$0.date! > $1.date!})
            })
            .disposed(by: self.rx.disposeBag)
            vc.viewModel.itemsSubject.accept(newItems)
            vc.sortButton.setAttributedTitle(NSAttributedString(string: "신상품순"), for: .normal)
            return self.sceneCoordinator.close(animated: false).asObservable().map { _ in }
        }
    }()
    
    lazy var sortHighAction: Action<Void, Void> = {
        return Action { [unowned self] in
            var newItems: [ItemModel] = []
            let nav = self.appDelegate.window?.rootViewController
            let vc = nav?.children.last as! BrandMainViewController
            vc.viewModel.itemsSubject.subscribe(onNext: { items in
                newItems = items.sorted(by: {$0.cost! > $1.cost!})
            })
            .disposed(by: self.rx.disposeBag)
            vc.viewModel.itemsSubject.accept(newItems)
            vc.sortButton.setAttributedTitle(NSAttributedString(string: "높은가격순"), for: .normal)
            return self.sceneCoordinator.close(animated: false).asObservable().map { _ in }
        }
    }()
    
    lazy var sortLowAction: Action<Void, Void> = {
        return Action { [unowned self] in
            var newItems: [ItemModel] = []
            let nav = self.appDelegate.window?.rootViewController
            let vc = nav?.children.last as! BrandMainViewController
            vc.viewModel.itemsSubject.subscribe(onNext: { items in
                newItems = items.sorted(by: {$0.cost! < $1.cost!})
            })
            .disposed(by: self.rx.disposeBag)
            vc.viewModel.itemsSubject.accept(newItems)
            vc.sortButton.setAttributedTitle(NSAttributedString(string: "낮은가격순"), for: .normal)
            return self.sceneCoordinator.close(animated: false).asObservable().map { _ in }
        }
    }()
    
    deinit {
        print("sort VM deinited")
    }
}
