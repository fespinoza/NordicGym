import SwiftUI

struct HomeScreen: View {
    @State private var content: BasicLoadingState<[HomeModuleViewData]> = .idle
    @Environment(\.dataClient.fetchHomeContent) private var fetchHomeContent

    var body: some View {
        BasicStateView(state: $content) { viewData in
            HomeView(modules: viewData)
        } fetchData: {
            try await fetchHomeContent().filter(\.hasContent)
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreen()
    }
}
