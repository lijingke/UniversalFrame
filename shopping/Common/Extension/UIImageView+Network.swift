//
//  UIImageView+Network.swift
//  shopping
//
//  Created by 李京珂 on 2021/7/20.
//

import Kingfisher
import UIKit

extension UIImageView {
    /// 设置网络图片
    func setUrl(_ url: String?) {
        // 去掉前后空格，兼容安卓上传图片后可能存在前后空格的bug
        let urlString = (url ?? "").removeHeadAndTailSpace
        self.kf.setImage(with: URL(string: urlString), placeholder: UIImage(named: "homepage_place"), options: nil, progressBlock: nil, completionHandler: nil)
    }

    /// 设置网络图片
    func setUrl(_ url: String?, _ place: String) {
        if url == nil || url!.count == 0 {
            self.image = UIImage(named: place)
            return
        }
        let tem = url ?? ""
        let urlStr = URL(string: tem)
        self.kf.setImage(with: urlStr, placeholder: UIImage(named: place), options: nil, progressBlock: nil, completionHandler: nil)
    }

    /// 设置动画
    func setGif(data: NSData) {
        // 从data中读取数据: 将data转成CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        let imageCount = CGImageSourceGetCount(imageSource)

        // 便利所有的图片
        var images = [UIImage]()
        var totalDuration: TimeInterval = 0
        for i in 0 ..< imageCount {
            // .取出图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            if i == 0 {
                self.image = image
            }
            images.append(image)

            // 取出持续的时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else { continue }
            guard let gifDict = (properties as NSDictionary)[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        // 设置imageView的属性
        self.animationImages = images
        self.animationDuration = totalDuration
        self.animationRepeatCount = 0
        // 开始播放
        self.startAnimating()
    }
}
