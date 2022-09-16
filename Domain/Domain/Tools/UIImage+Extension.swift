//
//  UIImage+Extension.swift
//  Domain
//
//  Created by Rza Ismayilov on 06.09.22.
//

import Foundation
import UIKit

extension UIImage {
    public func resize(size: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = size.width  / size.width
        let heightRatio = size.height / size.height
        let newSize: CGSize
        
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
