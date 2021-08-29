//
//  ViewController.swift
//  UISheetPresentationControllerDemo
//
//  Created by Molder on 2021/8/29.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {

    @IBOutlet weak var showImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        showImageView.contentMode = .scaleAspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }

    @IBAction func ChangeImage(_ sender: Any) {
        showPhotoPickView()
    }
    
    @IBAction func ShowWebView(_ sender: Any) {
        let web = WebViewController()
        if let sheet = web.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 10
        }
        present(web, animated: true, completion: nil)
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    
    private func showPhotoPickView() {
        var configuration = PHPickerConfiguration()
        // 設定選取種類 images, videos, livePhotos, any()
        configuration.filter = .any(of: [.images, .videos, .livePhotos])
        // 限制選取張數
        configuration.selectionLimit = 1
        let pickView = PHPickerViewController(configuration: configuration)
        pickView.delegate = self
        
        if let sheet = pickView.sheetPresentationController {
            // 設定允許 sheet 可拉動的範圍，只有 medium 跟 large 兩種
            sheet.detents = [.medium(), .large()]
            // 是否顯示移動條
            sheet.prefersGrabberVisible = true
            // 讓 BaseView 不會因為sheetPresentationController在拉動時變暗
            sheet.largestUndimmedDetentIdentifier = .large
            // 當 sheetPresentationController 當下模式是 medium 時(detents有設定支援large)，
            // sheetPresentationController 向上滑動時，會觸發模式的切換 medium -> large
            // 但原本的只是想滑動 sheetPresentationController 裡面的內容而不是切換模式
            // prefersScrollingExpandsWhenScrolledToEdge 屬性可以避免這問題
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            // sheetPresentationController 可客制圓角大小
            sheet.preferredCornerRadius = 100
            // 以下兩項是在 device orientation left or right 才看得出來
//            sheet.prefersEdgeAttachedInCompactHeight = true
//            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(pickView, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let itemProviders = results.map(\.itemProvider)
        if let itemProvider = itemProviders.first, itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = self.showImageView.image
            itemProvider.loadObject(ofClass: UIImage.self) {[weak self] (image, error) in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage, self.showImageView.image == previousImage else { return }
                    self.showImageView.image = image
                }
            }
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return showImageView
    }
}
