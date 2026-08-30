import SnapshotTesting
import SwiftUI
import Testing

protocol SnapshotNamedElement {
    var name: String { get }
    var fileNameComponent: String { get }
}

extension ColorScheme: SnapshotNamedElement {
    var name: String {
        switch self {
        case .light: "Light"
        case .dark: "Dark"
        @unknown default: "Unknown"
        }
    }

    var fileNameComponent: String {
        switch self {
        case .light: "LM"
        case .dark: "DM"
        @unknown default: "UK"
        }
    }
}

/// Encapsulate how to take snapshots for SwiftUI views
public struct SnapshotVariant {
    /// What kind of device we will run the snapshot on
    let device: SnapshotDeviceType

    /// Light mode or dark mode
    let colorScheme: ColorScheme

    /// If this value is present, the tested view will be wrapped
    /// on a `NavigationStack` built with this info
    let navigationBar: NavigationBarWrapper?

    // parameters to configure SnapshotTesting

    let precision: Float
    let perceptualPrecision: Float

    /// From the SnapshotTestingFramework
    /// Utilize the simulator’s key window in order to render UIColorScheme and UIVisualEffects.
    /// This option requires a host application for your tests and will not work for framework test targets.
    let drawHierarchyInKeyWindow: Bool

    // Parameters to control the presentation of a snapshot

    /// We ensure a consistent value for dynamic type size for this snapshot
    let dynamicTypeSize: DynamicTypeSize

    /// We make sure the locale is the same, so locale dependent
    /// content renders the same in different environments
    let locale: Locale

    public static let defaultPrecision: Float = 0.96
    public static let defaultPerceptualPrecision: Float = 0.96
    public static let defaultLocale: Locale = .init(identifier: "en_US")
    public static let defaultDynamicTypeSize: DynamicTypeSize = .large

    public init(
        device: SnapshotDeviceType,
        colorScheme: ColorScheme,
        navigationBar: NavigationBarWrapper? = nil,
        precision: Float = defaultPrecision,
        perceptualPrecision: Float = defaultPerceptualPrecision,
        drawHierarchyInKeyWindow: Bool = false,
        dynamicTypeSize: DynamicTypeSize = defaultDynamicTypeSize,
        locale: Locale = defaultLocale
    ) {
        self.device = device
        self.colorScheme = colorScheme
        self.navigationBar = navigationBar
        self.precision = precision
        self.perceptualPrecision = perceptualPrecision
        self.drawHierarchyInKeyWindow = drawHierarchyInKeyWindow

        self.dynamicTypeSize = dynamicTypeSize
        self.locale = locale
    }

    var fileName: String {
        let baseName = "\(device.fileNameComponent)-\(colorScheme.fileNameComponent)"

        var additions = ""
        if dynamicTypeSize != Self.defaultDynamicTypeSize {
            additions += "-\(dynamicTypeSize)"
        }

        if locale != Self.defaultLocale {
            additions += "-\(locale.identifier)"
        }

        return baseName + additions
    }

    var layout: SwiftUISnapshotLayout {
        if let size = device.size {
            .fixed(width: size.width, height: size.height)
        } else {
            .device(config: device.viewConfig)
        }
    }

    public struct NavigationBarWrapper {
        let title: String
        let titleDisplayMode: NavigationBarItem.TitleDisplayMode

        public init(title: String, titleDisplayMode: NavigationBarItem.TitleDisplayMode = .inline) {
            self.title = title
            self.titleDisplayMode = titleDisplayMode
        }
    }
}

extension SnapshotVariant: CustomTestStringConvertible {
    public var testDescription: String {
        let baseName = "\(device.name) \(colorScheme.name)"

        var additions = ""
        if dynamicTypeSize != Self.defaultDynamicTypeSize {
            additions += " \(dynamicTypeSize)"
        }

        if locale != Self.defaultLocale {
            additions += " \(locale.identifier)"
        }

        return baseName + additions
    }
}

// MARK: - Factory methods

public extension SnapshotVariant {
    static func iPhone(_ colorScheme: ColorScheme = .light) -> SnapshotVariant {
        .init(device: .iPhone, colorScheme: colorScheme)
    }

    static func iPad(_ colorScheme: ColorScheme = .light) -> SnapshotVariant {
        .init(device: .iPad(.portrait), colorScheme: colorScheme)
    }

    /// Basic snapshot variants to test a screen on.
    ///
    /// by default it will do:
    /// - iPhone Light
    /// - iPhone Dark
    /// - iPad Portrait Light
    /// - iPad Landscape Dark
    /// - iPhone Portrait Light Accessibility 3
    /// - iPad Portrait Dark Accessibility 3
    ///
    /// - Parameters:
    ///   - navigationTitle: (default `nil`) If included, the view will be wrapped in a NavigationStack
    ///   - checkAccessibility: (default `false`), adds a variant that checks dynamic type with an `.accessibility` size
    /// - Returns: An array of snapshot variants to test with
    static func defaultVariants(navigationTitle: String? = nil, checkAccessibility: Bool = false) -> [SnapshotVariant] {
        let navigationBar: SnapshotVariant.NavigationBarWrapper? = if let navigationTitle {
            SnapshotVariant.NavigationBarWrapper(title: navigationTitle)
        } else {
            nil
        }

        var variants: [SnapshotVariant] = [
            .init(device: .iPhone, colorScheme: .light, navigationBar: navigationBar),
            .init(device: .iPhone, colorScheme: .dark, navigationBar: navigationBar),
            .init(device: .iPad(.portrait), colorScheme: .light, navigationBar: navigationBar),
            .init(device: .iPad(.landscape), colorScheme: .dark, navigationBar: navigationBar),
        ]

        if checkAccessibility {
            variants.append(
                .init(
                    device: .iPhone,
                    colorScheme: .light,
                    navigationBar: navigationBar,
                    dynamicTypeSize: .accessibility3
                )
            )

            variants.append(
                .init(
                    device: .iPad(.portrait),
                    colorScheme: .dark,
                    navigationBar: navigationBar,
                    dynamicTypeSize: .accessibility3
                )
            )
        }

        return variants
    }

    /// Minimal variants to test a screen in
    /// - Parameter navigationTitle: (default `nil`) If provided, it will wrap the view in a
    ///                              `NavigationStack` and set the title
    /// - Returns: An array of snapshot variants to test with
    static func minimalVariants(navigationTitle: String? = nil) -> [SnapshotVariant] {
        let navigationBar: SnapshotVariant.NavigationBarWrapper? = if let navigationTitle {
            .init(title: navigationTitle)
        } else {
            nil
        }

        return [
            .init(device: .iPhone, colorScheme: .dark, navigationBar: navigationBar),
            .init(device: .iPad(.landscape), colorScheme: .light, navigationBar: navigationBar),
        ]
    }

    /// Returns a dark/light versions of an iPhone with a large height, the dream of designers
    /// So we can check the full scrollable content of a view
    ///
    /// - Parameters:
    ///   - height: desired device height (default 1400)
    ///   - navigationTitle: (default `nil`) If provided, it will wrap the view in a `NavigationStack` and set the title
    /// - Returns: An array of snapshot variants to test with
    static func fixedHeightVariants(height: CGFloat = 1400, navigationTitle: String? = nil) -> [SnapshotVariant] {
        let navigationBar: SnapshotVariant.NavigationBarWrapper? = if let navigationTitle {
            .init(title: navigationTitle)
        } else {
            nil
        }

        let fixedSize: SnapshotDeviceType = .fixedSize(
            width: SnapshotDeviceType.iPhone.size?.width ?? 402,
            height: height
        )

        return [
            .init(device: fixedSize, colorScheme: .light, navigationBar: navigationBar),
            .init(device: fixedSize, colorScheme: .dark, navigationBar: navigationBar),
        ]
    }
}
