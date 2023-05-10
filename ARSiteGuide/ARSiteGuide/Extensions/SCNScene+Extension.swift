//
//  SCNScene+Extension.swift
//  ARSiteGuide
//
//  Created by Zahari Georgiev on 09/05/2023.
//

import Foundation
import ARKit

extension SCNScene {
    convenience init?(asset: Asset3D) {
        guard let filePath = Bundle.main.url(forResource: asset.rawValue, withExtension: "usdz") else {
            fatalError("no file found with name \(asset.rawValue) and extension usdz")
        }
        try? self.init(url: filePath, options: [.checkConsistency: true])
    }
}
