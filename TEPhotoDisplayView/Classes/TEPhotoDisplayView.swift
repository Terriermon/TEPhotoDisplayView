//
//  TEPhotoDisplayView.swift
//  MoyaTest
//
//  Created by drore on 2019/1/9.
//  Copyright © 2019 Drore. All rights reserved.
//

import UIKit
import Kingfisher

public protocol TEPhotoDisplayViewDelegate: class {
    /// 选中某张图片
    func photoDisplayView(_ photoDisplayView: TEPhotoDisplayView, didSelectItemAt index: Int)
    /// 点击删除按钮
    func photoDisplayView(_ photoDisplayView: TEPhotoDisplayView, didDeleteItemAt index: Int)
    /// 点击添加图片按钮
    func photoDisplayViewAddButtonClicked(_ photoDisplayView: TEPhotoDisplayView)
    /// 添加的图片超过设置的最大图片数量
    func photoDisplayViewPhotosCountAboveMaxCount(_ photoDisplayView: TEPhotoDisplayView)
}

extension TEPhotoDisplayViewDelegate {
    func photoDisplayView(_ photoDisplayView: TEPhotoDisplayView, didSelectItemAt index: Int) {}
    func photoDisplayViewAddButtonClicked(_ photoDisplayView: TEPhotoDisplayView) {}
    func photoDisplayView(_ photoDisplayView: TEPhotoDisplayView, didDeleteItemAt index: Int) {}
    func photoDisplayViewPhotosCountAboveMaxCount(_ photoDisplayView: TEPhotoDisplayView) {}
}

public protocol TEPhotoDisplayViewDataSource: class {
    /// 支持 UIImage、URL、String 三种形式
    func images(in photoDisplayView: TEPhotoDisplayView) -> [Any]
}

@IBDesignable open class TEPhotoDisplayView: UIView {
    
    private var photos = [Any]() {
        didSet {
            if photos.count > maxCount {
                photos = photos.prefix(maxCount).map { $0 }
                if let delegate = self.delegate {
                    delegate.photoDisplayViewPhotosCountAboveMaxCount(self)
                }
            }
            
//            self.invalidateIntrinsicContentSize()
            collectionView.reloadData()
        }
    }
    
    @IBInspectable open var onlyShow = false
    
    @IBInspectable open var placeholderImage: UIImage?
    
    @IBInspectable open override var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }
    
    public weak var delegate: TEPhotoDisplayViewDelegate?
    public weak var dataSource: TEPhotoDisplayViewDataSource?
    /**
     该View只是图片展示的UI，设置最大数量只能控制显示的数量，并不能控制数据数组中的数量，
     若添加图片的组件，可以一次添加多张，需要在图片组件内设置
     */
    @IBInspectable public var maxCount: Int = Int.max
    
    public var viewDidLayout:((_ view: TEPhotoDisplayView) -> Void)?
    
    private var observer: NSKeyValueObservation?
    
    private lazy var  collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectikonViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(TEPhotoDisplayCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubView()
    }
    
    private func setupSubView() {
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.setNeedsUpdateConstraints()
        self.observer = collectionView.observe(\UICollectionView.contentSize, changeHandler: { (cv, changed) in
            if self.frame.size != cv.contentSize {
                self.setNeedsLayout()
            }
        })
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if self.bounds.size != self.collectionView.contentSize {
            self.invalidateIntrinsicContentSize()
            viewDidLayout?(self)
        }
    }
    
    override open func updateConstraints() {

        let collectionConstrains = [
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(collectionConstrains)
        super.updateConstraints()
    }
    
    open override var intrinsicContentSize: CGSize {
        /*
//        let length = (self.bounds.width - CGFloat(Default.col + 1) * Default.margin) / CGFloat(Default.col)
//        let length = (UIScreen.main.bounds.width - CGFloat(Default.col + 1) * Default.margin) / CGFloat(Default.col)
        //FIXME: - 这里有bug，宽度默认是屏幕宽度，需要找一个方法，实现这里的宽度为视图布局完成后的宽度
        let length = (self.bounds.width > 0 ? self.bounds.width : UIScreen.main.bounds.width - CGFloat(Default.col + 1) * Default.margin) / CGFloat(Default.col)
        var height: CGFloat = 0

        /// 如果行数不能被整除，就说明还有下一行，行数需要+1
        var addOneRow: Bool = false

        if onlyShow {
            addOneRow = (photos.count % Default.col) != 0
            height = length * CGFloat((photos.count / Default.col) + (addOneRow ? 1:0))
        } else {
            addOneRow = ((photos.count + 1) % Default.col) != 0
//            height = (length + Default.margin) * CGFloat(((photos.count + 1) / Default.col) + (addOneRow ? 1:0)) +  Default.margin
            height = (length) * CGFloat(((photos.count + 1) / Default.col) + (addOneRow ? 1:0)) +  Default.margin
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
 */
        return self.collectionView.contentSize
    }
    
    open func reloadData() {
        guard let dataSource = self.dataSource else { return }
        self.photos = dataSource.images(in: self)
    }
}

extension TEPhotoDisplayView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if maxCount <= photos.count {
            return maxCount
        }
        
        if onlyShow {
            return photos.count
        }
        
        return photos.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TEPhotoDisplayCell
        
        if indexPath.row == self.photos.count, indexPath.row < maxCount, !onlyShow {
            cell.deleteButton.isHidden = true
            cell.imageView.image = self.cameraImage
        } else {
            cell.deleteButton.isHidden = onlyShow

            let photo = photos[indexPath.row]
            
            if photo is UIImage {
                cell.imageView.image = photo as? UIImage
            } else if photo is URL {
                cell.imageView.kf.setImage(with: photo as!URL, placeholder: self.placeholderImage)
            } else if photo is String, let url = URL(string: photo as!String) {
                cell.imageView.kf.setImage(with: url, placeholder: self.placeholderImage)
            }
            
            cell.delete { [unowned self] image in
//                self.photos.remove(at: indexPath.row)
                if let delegate = self.delegate {
                    delegate.photoDisplayView(self, didDeleteItemAt: indexPath.row)
                }
            }
        }
        return cell
    }
}

extension TEPhotoDisplayView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let delegate = self.delegate else { return }
        
        if indexPath.row == self.photos.count, !onlyShow {
            delegate.photoDisplayViewAddButtonClicked(self)
        } else {
            delegate.photoDisplayView(self, didSelectItemAt: indexPath.row)
        }
    }
}

extension TEPhotoDisplayView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (self.bounds.width - CGFloat(Default.col + 1) * Default.margin) / CGFloat(Default.col)
        return CGSize(width: length, height: length)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Default.margin
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Default.margin
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Default.margin, left: Default.margin, bottom: Default.margin, right: Default.margin)
    }
}

extension TEPhotoDisplayView {
    private struct Default {
        static let margin: CGFloat = 10
        static let col: Int = 3
    }
    
    private var cameraImage: UIImage? {
        let bundle = Bundle(for: TEPhotoDisplayView.self)
        let bundelURL = bundle.url(forResource: "TEPhotoDisplayView", withExtension: "bundle")
        let resourceBundle = Bundle(url: bundelURL!)
        return UIImage(named:"camera_icon", in: resourceBundle, compatibleWith: nil)
    }
}

