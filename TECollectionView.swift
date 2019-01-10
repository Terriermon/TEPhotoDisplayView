//
//  TECollectionView.swift
//  CollectionViewTest
//
//  Created by drore on 2019/1/10.
//  Copyright © 2019 Drore. All rights reserved.
//

import UIKit

class TECollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()
        if contentSize != self.intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }

}
