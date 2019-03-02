//
//  Fonts.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/2/28.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

extension UIFont {
    class func MainFontMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Neogrey-Medium", size: size)!
    }
    class func MainFontRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Neogrey", size: size)!
    }
    class func MontserratLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Light", size: size)!
    }
    class func MontserratMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Medium", size: size)!
    }
    class func MontserratRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
    class func MontserratSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size)!
    }
    class func MontserratBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: size)!
    }
}

extension String {
    var qrCode: UIImage? {
        guard
            let data = data(using: .isoLatin1),
            let filter = CIFilter(name: "CIQRCodeGenerator")
            else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        guard let image = filter.outputImage
            else { return nil }
        let size = image.extent.integral
        let output = CGSize(width: 250, height: 250)
        let matrix = CGAffineTransform(scaleX: output.width / size.width, y: output.height / size.height)
        UIGraphicsBeginImageContextWithOptions(output, false, 0)
        defer { UIGraphicsEndImageContext() }
        UIImage(ciImage: image.transformed(by: matrix))
            .draw(in: CGRect(origin: .zero, size: output))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
