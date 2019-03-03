//
//  QRConverter.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/3.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

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
        let output = CGSize(width: 190, height: 190)
        let matrix = CGAffineTransform(scaleX: output.width / size.width, y: output.height / size.height)
        UIGraphicsBeginImageContextWithOptions(output, false, 0)
        defer { UIGraphicsEndImageContext() }
        UIImage(ciImage: image.transformed(by: matrix))
            .draw(in: CGRect(origin: .zero, size: output))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
