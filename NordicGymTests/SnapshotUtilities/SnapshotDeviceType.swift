import SnapshotTesting
import UIKit

public struct SnapshotDeviceType: SnapshotNamedElement {
    let name: String
    let fileNameComponent: String
    let viewConfig: ViewImageConfig
    let size: CGSize?
    let deviceTraits: UITraitCollection

    init(
        name: String,
        fileNameComponent: String? = nil,
        viewConfig: ViewImageConfig,
        size: CGSize?,
        deviceTraits: UITraitCollection
    ) {
        self.name = name
        self.fileNameComponent = fileNameComponent ?? name
        self.viewConfig = viewConfig
        self.size = size
        self.deviceTraits = deviceTraits
    }

    static let iPhone: Self = .init(
        name: "iPhone",
        viewConfig: .iPhone18Pro,
        size: nil,
        deviceTraits: .iPhone18Pro(.portrait)
    )

    static func iPhone(_ orientation: ViewImageConfig.Orientation) -> Self {
        .init(
            name: "iPhone \(orientation.name)",
            fileNameComponent: "iPhone \(orientation.fileNameComponent)",
            viewConfig: .iPhone18Pro(orientation),
            size: nil,
            deviceTraits: .iPhone18Pro(orientation)
        )
    }

    static let iPad: Self = .init(
        name: "iPad",
        viewConfig: .iPadPro11,
        size: nil,
        deviceTraits: .iPadPro11
    )

    static func iPad(_ orientation: ViewImageConfig.Orientation) -> Self {
        .init(
            name: "iPad \(orientation.name)",
            fileNameComponent: "iPad \(orientation.fileNameComponent)",
            viewConfig: .iPadPro11(orientation),
            size: nil,
            deviceTraits: .iPadPro11
        )
    }

    static func iPad(_ orientation: ViewImageConfig.TabletOrientation) -> Self {
        .init(
            name: "iPad \(orientation.name)",
            fileNameComponent: "iPad \(orientation.fileNameComponent)",
            viewConfig: .iPadPro11(orientation),
            size: nil,
            deviceTraits: .iPadPro11
        )
    }

    static func fixedSize(width: CGFloat = 402, height: CGFloat) -> Self {
        .init(
            name: "FixedSize",
            viewConfig: .iPhone18Pro,
            size: .init(width: width, height: height),
            deviceTraits: .iPhone18Pro(.portrait)
        )
    }
}

extension ViewImageConfig.Orientation: SnapshotNamedElement {
    var name: String {
        switch self {
        case .landscape: "Landscape"
        case .portrait: "Portrait"
        }
    }

    var fileNameComponent: String {
        switch self {
        case .landscape: "OL"
        case .portrait: "OP"
        }
    }
}

extension ViewImageConfig.TabletOrientation: SnapshotNamedElement {
    var name: String {
        switch self {
        case let .landscape(split): "Landscape \(split.name)"
        case let .portrait(split): "Portrait \(split.name)"
        }
    }

    var fileNameComponent: String {
        switch self {
        case let .landscape(split): "OL-\(split.fileNameComponent)"
        case let .portrait(split): "OP-\(split.fileNameComponent)"
        }
    }
}

extension ViewImageConfig.TabletOrientation.LandscapeSplits {
    var name: String {
        switch self {
        case .oneThird: "One Third"
        case .oneHalf: "Half"
        case .twoThirds: "Two Thirds"
        case .full: "Full"
        }
    }

    var fileNameComponent: String {
        switch self {
        case .oneThird: "S13"
        case .oneHalf: "S1H"
        case .twoThirds: "S23"
        case .full: "SF"
        }
    }
}

extension ViewImageConfig.TabletOrientation.PortraitSplits {
    var name: String {
        switch self {
        case .oneThird: "One Third"
        case .twoThirds: "Two Thirds"
        case .full: "Full"
        }
    }

    var fileNameComponent: String {
        switch self {
        case .oneThird: "S13"
        case .twoThirds: "S23"
        case .full: "SF"
        }
    }
}
