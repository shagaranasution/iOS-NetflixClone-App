//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 13/07/23.
//

import UIKit

extension String {
    
    public func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
}

extension UIImage {
    
    public func image(withWidth width: CGFloat) -> UIImage? {
        let scaleFactor = width / size.width
        let newHeight = size.height * scaleFactor
        let newSize = CGSize(width: width, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

extension UIImageView {
    
    func setImage(with url: URL?) {
        guard let url = url else {
            return
        }
        
        Task {
            guard let data = try? await NCImageLoader.shared.download(from: url) else {
                return
            }
            let image = UIImage(data: data)
            self.image = image
        }
    }
    
}

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
    
}
