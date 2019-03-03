//
//  ImageExtensions.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/4.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
