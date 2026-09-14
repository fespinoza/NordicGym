import SwiftUI

struct GroupClassDetailViewData {
    let groupClass: GroupClassCardViewData
    let instructorName: String
    let room: String
    let bookedSpots: Int
    let capacity: Int
    let attendingFriends: [String]

    var availableSpots: Int { max(0, capacity - bookedSpots) }

    static func previewValue(
        groupClass: GroupClassCardViewData = .previewValue(
            className: "Performance HYROX",
            date: "14 Sep 2026, 14:45",
            location: "Adamstuen",
            backgroundImage: Image(.crossfit)
        ),
        room: String = "Performance Zone"
    ) -> Self {
        .init(
            groupClass: groupClass,
            instructorName: "Mai Emilie Thi Nguyen",
            room: room,
            bookedSpots: 23,
            capacity: 24,
            attendingFriends: ["Alex Morgan"]
        )
    }
}

struct GroupClassDetailScreen: View {
    let viewData: GroupClassDetailViewData
    var onBook: (() -> Void)? = nil

    @State private var showsBookingNotice = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private let highlight = Color(red: 1, green: 0.32, blue: 0.19)
    private let informationColor = Color(red: 0.48, green: 0.72, blue: 0.86)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header

                VStack(alignment: .leading, spacing: .spacingXL) {
                    classInformation
                    booking
                    guidance
                }
                .padding(.spacingM)
                .padding(.top, .spacingS)

                if !viewData.attendingFriends.isEmpty {
                    friends
                        .padding(.top, .spacingXS)
                }
            }
            .padding(.bottom, .spacingL)
        }
        .background(.black)
        .foregroundStyle(.white)
        .ignoresSafeArea(edges: .top)
        .toolbarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .tint(highlight)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: "\(viewData.groupClass.className) — \(viewData.groupClass.date) at \(viewData.groupClass.location)") {
                    Label("Share class", systemImage: "square.and.arrow.up")
                }
            }
        }
        .alert("Sample booking", isPresented: $showsBookingNotice) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("This is a preview class. No booking has been made.")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: .spacingXXS) {
            Spacer(minLength: 260)

            Text(viewData.groupClass.className.uppercased())
                .font(.system(.largeTitle, design: .default, weight: .heavy))
                .italic()
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            Text("with \(viewData.instructorName)")
                .font(.title3)
                .foregroundStyle(highlight)
        }
        .padding(.horizontal, .spacingM)
        .padding(.top, .spacingXXL)
        .padding(.bottom, .spacingL)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            GeometryReader { geometry in
                viewData.groupClass.backgroundImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .overlay {
                        LinearGradient(
                            stops: [
                                .init(color: .black.opacity(0.3), location: 0),
                                .init(color: .clear, location: 0.4),
                                .init(color: .black, location: 1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
            }
            .accessibilityHidden(true)
        }
    }

    private var classInformation: some View {
        let columns = Array(
            repeating: GridItem(.flexible(), alignment: .leading),
            count: dynamicTypeSize.isAccessibilitySize ? 1 : 2
        )

        return LazyVGrid(columns: columns, alignment: .leading, spacing: .spacingL) {
            informationRow(viewData.groupClass.date, icon: "calendar.badge.clock", color: highlight)
            informationRow(viewData.groupClass.duration, icon: "clock")
            informationRow(viewData.groupClass.location, icon: "mappin.and.ellipse", color: highlight)
            informationRow(viewData.room, icon: "door.left.hand.open")
        }
    }

    private var booking: some View {
        VStack(alignment: .leading, spacing: .spacingM) {
            Button {
                if let onBook {
                    onBook()
                } else {
                    showsBookingNotice = true
                }
            } label: {
                Text(bookingTitle)
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, .spacingM)
                    .foregroundStyle(Color(red: 0.05, green: 0.12, blue: 0.18))
                    .background(.white, in: RoundedRectangle(cornerRadius: .cornerRadiusS))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: .spacingXXS) {
                (Text("\(viewData.bookedSpots)/\(viewData.capacity)").bold()
                 + Text(" spots booked").foregroundColor(.gray))

                Text(viewData.availableSpots == 1 ? "1 spot available" : "\(viewData.availableSpots) spots available")
                    .foregroundStyle(Color(red: 0.36, green: 0.74, blue: 0.63))
            }
            .font(.subheadline)
        }
    }

    private var bookingTitle: String {
        switch viewData.groupClass.bookingState {
        case .booked, .bookedOnWaitingList: "Cancel booking"
        case .notBookedOnWaitingList: "Join waiting list"
        case .notBooked: viewData.availableSpots == 0 ? "Join waiting list" : "Book"
        }
    }

    private var guidance: some View {
        VStack(alignment: .leading, spacing: .spacingL) {
            informationRow("Check in 10 minutes before the class starts to secure your spot.", icon: "info.circle", color: informationColor)
            informationRow("Cancel at least 2 hours before the class starts.", icon: "alarm", color: informationColor)
            informationRow("Your ticket appears under \"Check in\" in the app 3 hours before the class starts. Your waiting list position will also appear there.", icon: "ticket", color: informationColor)
        }
    }

    private var friends: some View {
        VStack(spacing: .spacingM) {
            ForEach(viewData.attendingFriends, id: \.self) { name in
                HStack(spacing: .spacingS) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(informationColor)
                        .accessibilityHidden(true)
                    Text(name)
                    Spacer()
                    Text("Going!")
                        .foregroundStyle(.mint)
                }
                .font(.subheadline)
            }
        }
        .padding(.spacingM)
        .background(Color(red: 0.04, green: 0.12, blue: 0.18))
    }

    private func informationRow(_ text: String, icon: String, color: Color = .white) -> some View {
        HStack(alignment: .top, spacing: .spacingXS) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 24)
                .accessibilityHidden(true)

            Text(text)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundStyle(color)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        GroupClassDetailScreen(viewData: .previewValue())
    }
}

#Preview("Accessibility") {
    NavigationStack {
        GroupClassDetailScreen(viewData: .previewValue())
            .environment(\.dynamicTypeSize, .accessibility3)
    }
}
