//
//  BannerViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/14.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import SDWebImage

class BannerViewController: UIViewController, ViewModelBindableType {

    @IBOutlet weak var realPopButton: UIButton!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    var viewModel: BannerViewModel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var popButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var emptyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    func bindViewModel() {
        mainImageView.sd_setImage(with: viewModel.imgURL, completed: nil)
        containerView.layer.cornerRadius = 13
        mainScrollView.layer.cornerRadius = 13
        topView.layer.cornerRadius = 13
        emptyButton.rx.action = viewModel.popAction
        realPopButton.rx.action = viewModel.popAction
    }
}
