import SwiftUI

struct GroupClassView: View {
    let viewData: GroupClassViewData

    @State private var showsBookingBar = false
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
                        .onGeometryChange(for: Bool.self) { geometry in
                            geometry.frame(in: .named("classDetailScroll")).maxY < 0
                        } action: { showsBookingBar = $0 }
                    guidance
                }
                .padding(.spacingM)
                .padding(.top, .spacingS)

                friends
                    .padding(.top, .spacingXS)

                section("What is it?") {
                    Text(viewData.description)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }

                section("Intensity") {
                    ViewThatFits(in: .horizontal) {
                        HStack(spacing: .spacingS) { intensityLabels }
                        VStack(alignment: .leading, spacing: .spacingXS) { intensityLabels }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Intensity: \(viewData.intensity.rawValue)")
                }

                section("Categories") {
                    categoryCard
                }

                if !viewData.similarClasses.isEmpty {
                    section("Similar classes") {
                        VStack(alignment: .leading, spacing: .spacingXL) {
                            ForEach(viewData.similarClasses) { groupClass in
                                GroupClassRow(viewData: groupClass)
                            }
                        }
                        .padding(.spacingM)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(red: 0.04, green: 0.12, blue: 0.18),
                                    in: RoundedRectangle(cornerRadius: .cornerRadiusM))
                    }
                }
            }
            .padding(.bottom, .spacingL)
        }
        .coordinateSpace(name: "classDetailScroll")
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if showsBookingBar {
                persistentBookingBar
            }
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
                ShareLink(
                    item: """
                        \(viewData.className) — \
                        \(viewData.date) at \
                        \(viewData.location)"
                    """
                ) {
                    Label("Share class", systemImage: "square.and.arrow.up")
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: .spacingXXS) {
            Spacer(minLength: 260)

            Text(viewData.className.uppercased())
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
                AsyncImage(url: viewData.backgroundImageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
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
            informationRow(viewData.date, icon: "calendar.badge.clock", color: highlight)
            informationRow(viewData.duration, icon: "clock")
            informationRow(viewData.location, icon: "mappin.and.ellipse", color: highlight)
            informationRow(viewData.room, icon: "door.left.hand.open")
        }
    }

    private var booking: some View {
        VStack(alignment: .leading, spacing: .spacingM) {
            Button(action: {}) {
                Text(bookingTitle)
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, .spacingM)
                    .foregroundStyle(Color(red: 0.05, green: 0.12, blue: 0.18))
                    .background(.white, in: RoundedRectangle(cornerRadius: .cornerRadiusS))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: .spacingXXS) {
                Text(
                    """
                    \(Text(viewData.bookedCapacityLabel).bold()) \
                    spots booked
                    """
                )

                Text(viewData.availableSpots == 1 ? "1 spot available" : "\(viewData.availableSpots) spots available")
                    .foregroundStyle(Color(red: 0.36, green: 0.74, blue: 0.63))
            }
            .font(.subheadline)
        }
    }

    private var bookingTitle: String {
        switch viewData.bookingState {
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
        VStack(alignment: .leading, spacing: .spacingL) {
            ForEach(viewData.attendingFriends) { friend in
                HStack(spacing: .spacingS) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(informationColor)
                        .accessibilityHidden(true)
                    Text(friend.fullName)
                    Spacer()
                    Text("Going!")
                        .foregroundStyle(.mint)
                }
                .font(.subheadline)
            }

            Button(action: {}) {
                Text("Invite friends")
                    .font(.subheadline.bold())
                    .padding(.spacingS)
                    .overlay(RoundedRectangle(cornerRadius: .cornerRadiusS).stroke(.white, lineWidth: 1))
            }
            .tint(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.spacingM)
        .background(Color(red: 0.04, green: 0.12, blue: 0.18))
    }

    private var persistentBookingBar: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: .spacingS))
            : AnyLayout(HStackLayout(spacing: .spacingM))

        return layout {
            VStack(alignment: .leading, spacing: .spacingXXS) {
                Text("\(viewData.bookedSpots)/\(viewData.capacity) spots booked")
                    .font(.subheadline.bold())
                Text(viewData.availableSpots == 1 ? "1 spot available" : "\(viewData.availableSpots) spots available")
                    .font(.caption)
                    .foregroundStyle(.mint)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            BookButton(bookingState: viewData.bookingState, size: .small)
        }
        .padding(.spacingM)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: .cornerRadiusL))
        .overlay(RoundedRectangle(cornerRadius: .cornerRadiusL).stroke(.white.opacity(0.2)))
        .environment(\.colorScheme, .dark)
        .padding(.horizontal, .spacingM)
        .padding(.vertical, .spacingXS)
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

    private var intensityLabels: some View {
        ForEach(ClassIntensity.allCases, id: \.self) { intensity in
            Text(intensity.rawValue)
                .foregroundStyle(intensity == viewData.intensity ? .white : .gray)
                .fontWeight(intensity == viewData.intensity ? .semibold : .regular)
                .fixedSize()
        }
    }

    private var categoryCard: some View {
        Text(viewData.categoryName.uppercased())
            .font(.title.bold().italic())
            .padding(.spacingM)
            .frame(maxWidth: .infinity, minHeight: 220, alignment: .bottomLeading)
            .background {
                GeometryReader { geometry in
                    AsyncImage(url: viewData.categoryImageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .overlay {
                        LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadiusM))
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: .spacingM) {
            Text(title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            content()
        }
        .padding(.horizontal, .spacingM)
        .padding(.top, .spacingL)
    }
}
