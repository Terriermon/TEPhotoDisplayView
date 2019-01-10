//
//  ViewController.swift
//  TEPhotoDisplayView
//
//  Created by codermoe@gmail.com on 01/09/2019.
//  Copyright (c) 2019 codermoe@gmail.com. All rights reserved.
//

import UIKit
import TEPhotoDisplayView

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.dataSource = self
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var photos = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        cell.photos = self.photos
        cell.addPhoto = {
            self.uploadImages()
        }
        cell.deletePhoto = { (index) in
            self.photos.remove(at: index)
            cell.photos = self.photos
            self.tableView.reloadData()
        }
        return cell
    }
    
    
}

//extension ViewController: TEPhotoDisplayViewDelegate {
//    /// 选中某张图片
//    func photoDisplayView(_ photoDisplayView: TEPhotoDisplayView, didSelectItemAt index: Int) {
//
//    }
//    /// 点击删除按钮
//    func photoDisplayView(_ photoDisplayView: TEPhotoDisplayView, didDeleteItemAt index: Int) {
//        self.photos.remove(at: index)
//        photoDisplayView.photos = self.photos
//    }
//    /// 点击添加图片按钮
//    func photoDisplayViewAddButtonClicked(_ photoDisplayView: TEPhotoDisplayView) {
//        uploadImages()
//    }
//    /// 添加的图片超过设置的最大图片数量
//    func photoDisplayViewPhotosCountAboveMaxCount(_ photoDisplayView: TEPhotoDisplayView) {
//        print(self.photos)
//    }
//}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func uploadImages() {
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(pickerVC, animated: true, completion: nil)
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image  = info[.originalImage] as! UIImage
        self.photos.append(image)
        self.tableView.reloadData()
//        self.displayView?.photos = self.photos
    }
}

