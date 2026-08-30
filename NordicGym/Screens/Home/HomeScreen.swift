import SwiftUI

struct HomeScreen: View {
    @State var content: BasicLoadingState<[HomeModuleViewData]> = .idle
    @Environment(\.dataClient.fetchHomeContent) var fetchHomeContent

    var body: some View {
        BasicStateView(state: $content) { viewData in
            HomeView(modules: viewData)
        } fetchData: {
            try await fetchHomeContent()
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreen()
    }
}
