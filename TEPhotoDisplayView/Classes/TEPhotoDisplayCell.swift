//
//  TEPhotoDisplayCell.swift
//  MoyaTest
//
//  Created by drore on 2019/1/9.
//  Copyright © 2019 Drore. All rights reserved.
//

import UIKit

class TEPhotoDisplayCell: UICollectionViewCell {
    
    typealias ImageClosure = (UIImage?) -> Void
    
    private var image: ImageClosure?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(closeImage, for: .normal)
        button.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        let imageConstraints = [
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let deleteButtonConstraints = [
        deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
        deleteButton.trailingAnchor.constraint(equalTo:contentView.trailingAnchor, constant: -0)
        ]
        
        NSLayoutConstraint.activate(imageConstraints + deleteButtonConstraints)
        
        super.updateConstraints()
    }
}

extension TEPhotoDisplayCell {
    @objc func deleteAction(_ sender: UIButton) {
        
        guard let image = self.image else {
            return
        }
        
        image(self.imageView.image)
    }
    
    func delete(_ image: @escaping ImageClosure) {
        self.image = image
    }
}

extension TEPhotoDisplayCell {
    var closeImage: UIImage? {
        let bundle = Bundle(for: TEPhotoDisplayView.self)
        let bundelURL = bundle.url(forResource: "TEPhotoDisplayView", withExtension: "bundle")
        let resourceBundle = Bundle(url: bundelURL!)
        return UIImage(named: "close_icon", in: resourceBundle, compatibleWith: nil)
    }
}

