import SwiftUI
import SnapshotTesting

public func expectSnapshot(
    of view: some View,
    on variant: SnapshotVariant,
    record: SnapshotTestingConfiguration.Record = .failed,
    appendName: String = "",
    fileID: StaticString = #fileID,
    file filePath: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line,
    column: UInt = #column
) {
    withSnapshotTesting(diffTool: .riffle) {
        assertSnapshot(
            of: TestContainerView(variant: variant, content: { view }),
            as: .image(
                drawHierarchyInKeyWindow: variant.drawHierarchyInKeyWindow,
                precision: variant.precision,
                perceptualPrecision: variant.perceptualPrecision,
                layout: variant.layout,
                traits: variant.device.deviceTraits
            ),
            named: "\(variant.fileName)-\(appendName)",
            record: record,
            fileID: fileID,
            file: filePath,
            testName: testName,
            line: line,
            column: column
        )
    }
}
