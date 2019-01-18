//
//  PhotoTableViewCell.swift
//  TEPhotoDisplayView_Example
//
//  Created by drore on 2019/1/10.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import TEPhotoDisplayView

class PhotoTableViewCell: UITableViewCell {
    
    /**
    把displayView 设置成懒加载会导致循环引用
     **/
    
    lazy var displayView: TEPhotoDisplayView = {
        let displayView = TEPhotoDisplayView()
        displayView.backgroundColor = .lightGray
        displayView.delegate = self
        displayView.dataSource = self
        
        return displayView
    }()
    
    var photos = [Any]() {
        didSet {
            displayView.reloadData()
        }
    }
    
    var addPhoto:(()->Void)?
    var deletePhoto:((_ index: Int)->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(displayView)
      
        displayView.translatesAutoresizingMaskIntoConstraints = false
        let displayConstrains = [
            displayView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 40),
            displayView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -40),
            displayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            displayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            //            displayView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(displayConstrains)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension PhotoTableViewCell: TEPhotoDisplayViewDelegate {
    /// 选中某张图片
    func photoDisplayView(_ photoDisplayView: TEPhotoDisplayView, didSelectItemAt index: Int) {
        
    }
    /// 点击删除按钮
    func photoDisplayView(_ photoDisplayView: TEPhotoDisplayView, didDeleteItemAt index: Int) {
        deletePhoto?(index)
    }
    /// 点击添加图片按钮
    func photoDisplayViewAddButtonClicked(_ photoDisplayView: TEPhotoDisplayView) {
        addPhoto?()
    }
    /// 添加的图片超过设置的最大图片数量
    func photoDisplayViewPhotosCountAboveMaxCount(_ photoDisplayView: TEPhotoDisplayView) {
        print(self.photos)
    }
}

extension PhotoTableViewCell: TEPhotoDisplayViewDataSource {
    func images(in photoDisplayView: TEPhotoDisplayView) -> [Any] {
        return self.photos
    }
}
