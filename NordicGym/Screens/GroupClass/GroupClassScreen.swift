import SwiftUI
import Tagged

struct GroupClassScreen: View {
    let id: GroupClassID

    @State var content: BasicLoadingState<GroupClassViewData> = .idle
    @Environment(\.dataClient.fetchGroupClass) var fetchGroupClass

    var body: some View {
        BasicStateView(state: $content) { viewData in
            GroupClassView(viewData: viewData)
        } fetchData: {
            try await fetchGroupClass(id)
        }
        .background(.black)
        .foregroundStyle(.white)
    }
}

#Preview {
    NavigationStack {
        GroupClassScreen(id: "cycling-20260911-1630")
    }
}
