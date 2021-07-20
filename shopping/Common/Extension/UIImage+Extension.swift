//
//  UIImage+Extension.swift
//  shopping
//
//  Created by 李京珂 on 2021/7/20.
//

import Accelerate
import QuartzCore
import UIKit

extension UIImage {
    /// 调整方向
    func fixDirection() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(.pi/2.0))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-.pi/2.0))
        default:
            break
        }
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: self.cgImage!.bytesPerRow, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
        
        let cgImg = ctx?.makeImage()
        let img = UIImage(cgImage: cgImg!)
        return img
    }
    
    /// 对指定图片进行拉伸
    func resizableImage(name: String) -> UIImage {
        var normal = UIImage(named: name)!
        let imageWidth = normal.size.width * 0.5
        let imageHeight = normal.size.height * 0.5
        normal = self.resizableImage(withCapInsets: UIEdgeInsets(top: imageHeight, left: imageWidth, bottom: imageHeight, right: imageWidth))
        
        return normal
    }

    /**
     *  重设图片大小
     */
    func reSizeImage(_ reSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        let rec = CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height)
        self.draw(in: rec)
        let reSizeImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext() ?? nil
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(_ scaleSize: CGFloat) -> UIImage? {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return self.reSizeImage(reSize)
    }
}

extension UIImage {
    public static func getImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func getGradientImage(leftColor: UIColor, rightColor: UIColor, gradientType: HXSGRadientType = .leftToRight) -> UIImage {
        let image = UIImage(size: CGSize(width: UIScreen.main.bounds.size.width, height: 210), gradientColors: [leftColor, rightColor], percentage: [0, 1], gradientType: gradientType)
        return image
    }
    
    static func creatImageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        guard let theImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return theImage
    }
}
