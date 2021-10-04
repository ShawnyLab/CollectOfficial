//
//  WideViewController.swift
//  Collect
//
//  Created by 박진서 on 2021/09/23.
//

import UIKit

class WideViewController: UIViewController, ViewModelBindableType {

    var viewModel: WideViewModel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emptyButton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgContainer: UIView!
    @IBOutlet weak var popButton: UIButton!
    @IBOutlet weak var realPopButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    deinit {
        print("wide deinited")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func bindViewModel() {
        imgContainer.layer.cornerRadius = 13
        imgView.layer.cornerRadius = 13
        scrollView.layer.cornerRadius = 13
        emptyButton.rx.action = viewModel.popAction
        realPopButton.rx.action = viewModel.popAction
        imgView.image = viewModel.imgURL
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1.5
        scrollView.delegate = self
    }

}

extension WideViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
}
