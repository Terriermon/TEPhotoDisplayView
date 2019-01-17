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
    
    
    var photos = [Any]()
    let urls = ["http://wx4.sinaimg.cn/large/a1b61d0aly1fn2h3xwat6j20dw0dwtbp.jpg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548322855&di=05abbfdd65f954c1b17affa7f19ae92d&imgtype=jpg&er=1&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Ff%2F57eb341f56281.jpg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547728138419&di=97c3b6d58e7bcf9ab1f05824baecd6ed&imgtype=0&src=http%3A%2F%2Fwww.qqoi.cn%2Fimg_bizhi%2F245213311.jpeg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547728138419&di=dc9aed99c79ba60e43a7945e2d590f95&imgtype=0&src=http%3A%2F%2Fimg2.3lian.com%2F2014%2Ff4%2F182%2Fd%2F90.jpg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547728281316&di=6c6b2b97f825d6ce6bb4f1a3d09f6711&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2018-11-28%2F5bfe00a9ddded.jpg",
                "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2165885968,1978601423&fm=26&gp=0.jpg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547728281315&di=a35fae631f3912fa0bf6cb7aaf3a1847&imgtype=0&src=http%3A%2F%2Fuploads.5068.com%2Fallimg%2F171117%2F1-1G11G05139.jpg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547728343036&di=17d2ab898bf3976c17c74fe3fe791e03&imgtype=0&src=http%3A%2F%2Fwww.33lc.com%2Farticle%2FUploadPic%2F2012-8%2F2012816100159067.jpg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        self.photos.append(contentsOf: self.urls.map {
            URL(string: $0)!
        })
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
        cell.displayView?.viewDidLayout = {(view) in
            self.tableView.reloadData()
        }
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

