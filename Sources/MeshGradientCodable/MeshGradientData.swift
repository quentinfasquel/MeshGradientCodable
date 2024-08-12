//
//  MeshGradientData.swift
//  MeshGradientCodable
//
//  Created by Quentin Fasquel on 16/06/2024.
//

import Foundation
import SwiftUI

public struct MeshGradientData: Codable, Equatable, Hashable {

    public var width: Int
    public var height: Int
    public var locations: Locations
    public var colors: [Color]
    public var background: Color
    public var smoothsColors: Bool
    public var colorSpace: Gradient.ColorSpace
#if SDK_IOS_18_MACOS_15
    @available(iOS 18.0, macOS 15.0, *)
    public var _locations: MeshGradient.Locations {
        .init(locations: locations)
    }
#endif

#if SDK_IOS_18_MACOS_15
    @available(iOS 18.0, macOS 15.0, *)
    public init(
        width: Int,
        height: Int,
        locations: MeshGradient.Locations,
        colors: [Color],
        background: Color,
        smoothsColors: Bool,
        colorSpace: Gradient.ColorSpace
    ) {
        self.width = width
        self.height = height
        self.locations = .init(locations: locations)
        self.colors = colors
        self.background = background
        self.smoothsColors = smoothsColors
        self.colorSpace = colorSpace
    }
#endif

    @available(iOS, introduced: 17.0, deprecated: 18.0)
    @available(macOS, introduced: 14.0, deprecated: 15.0)
    public init(
        width: Int,
        height: Int,
        locations: Locations,
        colors: [Color],
        background: Color,
        smoothsColors: Bool,
        colorSpace: Gradient.ColorSpace
    ) {
        self.width = width
        self.height = height
        self.locations = locations
        self.colors = colors
        self.background = background
        self.smoothsColors = smoothsColors
        self.colorSpace = colorSpace
    }

    enum CodingKeys: String, CodingKey {
        case width, height, locations, colors, background, smoothsColors, colorSpace
    }

    public enum Locations: Equatable, Hashable, Sendable, Codable {
        case points([SIMD2<Float>])
        case bezierPoints([BezierPoint])
    }

    public struct BezierPoint: Equatable, Hashable, Sendable {
        public var position: SIMD2<Float>
        public var leadingControlPoint: SIMD2<Float>
        public var topControlPoint: SIMD2<Float>
        public var trailingControlPoint: SIMD2<Float>
        public var bottomControlPoint: SIMD2<Float>

        public init(
            position: SIMD2<Float>,
            leadingControlPoint: SIMD2<Float>,
            topControlPoint: SIMD2<Float>,
            trailingControlPoint: SIMD2<Float>,
            bottomControlPoint: SIMD2<Float>
        ) {
            self.position = position
            self.leadingControlPoint = leadingControlPoint
            self.topControlPoint = topControlPoint
            self.trailingControlPoint = trailingControlPoint
            self.bottomControlPoint = bottomControlPoint
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.colors = try container.decode([Color].self, forKey: .colors)
        self.background = try container.decode(Color.self, forKey: .background)
        self.smoothsColors = try container.decode(Bool.self, forKey: .smoothsColors)
        self.colorSpace = try container.decode(Gradient.ColorSpace.self, forKey: .colorSpace)
        self.locations = try container.decode(Locations.self, forKey: .locations)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(colors, forKey: .colors)
        try container.encode(background, forKey: .background)
        try container.encode(smoothsColors, forKey: .smoothsColors)
        try container.encode(colorSpace, forKey: .colorSpace)
        try container.encode(locations, forKey: .locations)
    }

}

extension Gradient.ColorSpace: Codable {
    enum Storage: Codable {
        case device, perceptual
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Storage.self)
        switch value {
            case .device:
                self = .device
            case .perceptual:
                self = .perceptual
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .device:
                try container.encode(Storage.device)
            case .perceptual:
                try container.encode(Storage.perceptual)
            default:
                fatalError()
        }
    }
}

#if SDK_IOS_18_MACOS_15
@available(iOS 18.0, macOS 15.0, *)
extension MeshGradient.Locations: Codable {

    enum Storage: Codable {
        case points([SIMD2<Float>])
        case bezierPoints([MeshGradient.BezierPoint])
    }

    public init(locations: MeshGradientData.Locations) {
        switch locations {
        case .bezierPoints(let bezierPoints):
            self = .bezierPoints(bezierPoints.map { .init(bezierPoint: $0) })
        case .points(let points):
            self = .points(points)
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Storage.self)
        switch values {
            case .bezierPoints(let bezierPoints):
                self = .bezierPoints(bezierPoints)
            case .points(let points):
                self = .points(points)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .bezierPoints(let bezierPoints):
                try container.encode(Storage.bezierPoints(bezierPoints))
            case .points(let points):
                try container.encode(Storage.points(points))
            @unknown default:
                fatalError()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
extension MeshGradient.BezierPoint: Codable {

    public init(bezierPoint: MeshGradientData.BezierPoint) {
        self.init(
            position: bezierPoint.bottomControlPoint,
            leadingControlPoint: bezierPoint.leadingControlPoint,
            topControlPoint: bezierPoint.topControlPoint,
            trailingControlPoint: bezierPoint.trailingControlPoint,
            bottomControlPoint: bezierPoint.bottomControlPoint
        )
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([SIMD2<Float>].self)
        self.init(
            position: values[0],
            leadingControlPoint: values[1],
            topControlPoint: values[2],
            trailingControlPoint: values[3],
            bottomControlPoint: values[4]
        )
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([
            position,
            leadingControlPoint,
            topControlPoint,
            trailingControlPoint,
            bottomControlPoint
        ])
    }
}

@available(iOS 18.0, macOS 15.0, *)
extension MeshGradientData.BezierPoint {

    public init(bezierPoint: MeshGradient.BezierPoint) {
        self.init(
            position: bezierPoint.position,
            leadingControlPoint: bezierPoint.leadingControlPoint,
            topControlPoint: bezierPoint.topControlPoint,
            trailingControlPoint: bezierPoint.trailingControlPoint,
            bottomControlPoint: bezierPoint.bottomControlPoint
        )
    }
}
@available(iOS 18.0, macOS 15.0, *)
extension MeshGradientData.Locations {

    public init(locations: MeshGradient.Locations) {
        switch locations {
        case .bezierPoints(let bezierPoints):
            self = .bezierPoints(bezierPoints.map { .init(bezierPoint: $0) })
        case .points(let points):
            self = .points(points)
        @unknown default:
            fatalError()
        }
    }
}

#endif

extension MeshGradientData.BezierPoint: Codable {

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([SIMD2<Float>].self)
        self.init(
            position: values[0],
            leadingControlPoint: values[1],
            topControlPoint: values[2],
            trailingControlPoint: values[3],
            bottomControlPoint: values[4]
        )
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([
            position,
            leadingControlPoint,
            topControlPoint,
            trailingControlPoint,
            bottomControlPoint
        ])
    }
}

extension MeshGradientData {
    public var usesBezierPoints: Bool {
        if case .bezierPoints = locations {
            return true
        } else {
            return false
        }
    }
}

// MARK - Transferable

extension MeshGradientData: Transferable {

    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: MeshGradientData.self, contentType: .json)
    }
}
