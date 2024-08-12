//
//  MeshGradient.swift
//  MeshGradientCodable
//
//  Created by Quentin Fasquel on 16/06/2024.
//

#if SDK_IOS_18_MACOS_15
import SwiftUI

@available(iOS 18, macOS 15, *)
extension MeshGradient {

    public init(_ data: MeshGradientData) {
        self.init(
            width: data.width,
            height: data.height,
            locations: data._locations,
            colors: .colors(data.colors),
            background: data.background,
            smoothsColors: data.smoothsColors,
            colorSpace: data.colorSpace
        )
    }

    public init(contentOf fileURL: URL) {
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let meshFile = try decoder.decode(MeshGradientData.self, from: jsonData)
            self.init(meshFile)
        } catch {
            // Fallback
            self.init(
                width: 2,
                height: 2,
                points: [.init(x: 0, y: 0), .init(1, 0), .init(x: 0, y: 1), .init(1, 1)],
                colors: [.black, .black, .black, .black]
            )
        }
    }
}
#endif
