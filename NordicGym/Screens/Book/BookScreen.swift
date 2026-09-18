import SwiftUI

struct BookScreen: View {
    @State var content: BasicLoadingState<[BookModuleViewData]> = .idle

    @Environment(\.dataClient.fetchBookContent) var fetchBookContent

    var body: some View {
        BasicStateView(state: $content) { viewData in
            BookView(modules: viewData)
        } fetchData: {
            try await fetchBookContent()
        }
    }
}

#Preview {
    NavigationStack {
        BookScreen()
    }
}
