import SwiftUI

struct BookingServicesCard: View {
    let services: [ServiceButtonViewData]

    var body: some View {
        ViewThatFits(in: .horizontal) {
            serviceButtons

            ScrollView(.horizontal) {
                serviceButtons
            }
            .scrollIndicators(.hidden)
        }
        .padding(.vertical, .spacingM)
        .padding(.horizontal, .spacingXS)
        .background(Color.bookingServicesBackground)
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadiusM))
    }

    private var serviceButtons: some View {
        HStack(alignment: .top, spacing: .spacingS) {
            ForEach(services.enumerated(), id: \.offset) { _, service in
                ServiceButton(viewData: service)
                    .font(.footnote)
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BookingServicesCard(services: [
        .init(iconName: "person.3.fill", title: "Group Class"),
        .init(iconName: "figure.strengthtraining.traditional", title: "Personal Trainer"),
        .init(iconName: "figure.flexibility", title: "Physiotherapy")
    ])
    .padding()
}
