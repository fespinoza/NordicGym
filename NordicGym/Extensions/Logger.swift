import OSLog

extension Logger {
    static func forCategory(_ category: String) -> os.Logger {
        .init(subsystem: "dev.craftingswift.sample-code.nordic-gym", category: category)
    }
}
