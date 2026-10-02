import SnapshotTesting

public extension SnapshotTestingConfiguration.DiffTool {
    static let riffle = Self { existing, failed in
        #"riffle "\#(existing)" "\#(failed)""#
    }
}

