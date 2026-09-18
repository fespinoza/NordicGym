import SnapshotTesting
import UIKit

public extension CGSize {
    /// Creates a size instance with the width of an iPhone 16 Pro
    /// and the height at least of that iPhone
    ///
    /// - Parameter height: height value for a taller iPhone 16 Pro
    static func iPhone18Pro(height: CGFloat) -> Self {
        .init(width: 402, height: max(height, 874))
    }
}

public extension ViewImageConfig {
    static let iPhone18Pro = ViewImageConfig.iPhone18Pro(.portrait)

    /// Custom definition of the parameters of iPhone 18 Pro
    ///
    ///
    /// - Parameter orientation: device orientation
    /// - Returns: config for snapshot test for the iPhone 15 Pro
    static func iPhone18Pro(_ orientation: Orientation) -> ViewImageConfig {
        let safeArea: UIEdgeInsets
        let size: CGSize

        switch orientation {
        case .landscape:
            safeArea = .init(top: 0, left: 62, bottom: 21, right: 62)
            size = .init(width: 874, height: 402)
        case .portrait:
            safeArea = .init(top: 62, left: 0, bottom: 34, right: 0)
            size = .init(width: 402, height: 874)
        }

        return .init(safeArea: safeArea, size: size, traits: .iPhone13(orientation))
    }
}

public extension UITraitCollection {
    static func iPhone18Pro(_ orientation: ViewImageConfig.Orientation) -> UITraitCollection {
        .iPhone13(orientation)
    }
}
