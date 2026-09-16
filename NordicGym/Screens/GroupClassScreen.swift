import SwiftUI
import Tagged

struct GroupClassViewData: Equatable {
    let id: GroupClassID
    let className: String
    let backgroundImage: Image
    let description: String
    let intensity: ClassIntensity
    let categoryName: String
    let categoryImage: Image

    let date: String
    let duration: String
    let location: String
    let room: String
    let instructorName: String

    let bookingState: BookingState
    let bookedSpots: Int
    let capacity: Int
    var availableSpots: Int { max(0, capacity - bookedSpots) }

    let attendingFriends: [AttendingFriend]

    let similarClasses: [GroupClassRowViewData]

    struct AttendingFriend: Identifiable, Equatable {
        let id: MemberID
        let profilePicture: Image?
        let fullName: String
        let bookingState: BookingState
    }

    var bookedCapacityLabel: String {
        "\(bookedSpots)/\(capacity)"
    }
}

extension GroupClassViewData.AttendingFriend {
    init(dto: FriendAttending) {
        self.init(
            id: dto.member.id,
            profilePicture: nil,
            fullName: "\(dto.member.firstName) \(dto.member.lastName)",
            bookingState: dto.bookingState
        )
    }

    static func previewValue(
        id: MemberID = .previewValue(),
        profilePicture: Image? = nil,
        fullName: String = "Tony Stark",
        bookingState: BookingState = .booked
    ) -> Self {
        .init(
            id: id,
            profilePicture: profilePicture,
            fullName: fullName,
            bookingState: bookingState
        )
    }
}

extension GroupClassViewData {
    init(dto: GroupClass) {
        let intensity: ClassIntensity
        switch dto.intensity {
        case .low:
            intensity = .light
        case .medium:
            intensity = .moderate
        case .high:
            intensity = .intense
        }

        self.init(
            id: dto.id,
            className: dto.name,
            backgroundImage: Image(.crossfit),
            description: dto.description,
            intensity: intensity,
            categoryName: "Group Class",
            categoryImage: Image(.lift),
            date: dto.startTime.formatted(date: .abbreviated, time: .shortened),
            duration: dto.durationInMinutes.formatted() + " min",
            location: dto.gym.name,
            room: dto.room ?? "",
            instructorName: "\(dto.instructor.firstName) \(dto.instructor.lastName)",
            bookingState: dto.bookingState,
            bookedSpots: max(0, dto.capacity - dto.availableSpots),
            capacity: dto.capacity,
            attendingFriends: dto.friendsAttending.map { .init(dto: $0) },
            similarClasses: dto.similarClasses.map { .init(dto: $0) }
        )
    }

    static func previewValue(
        id: GroupClassID = .previewValue(),
        className: String = "Performance Strength",
        backgroundImage: Image = .init(.crossfit),
        description: String = """
            Challenge your endurance in an energizing indoor cycling session. Alternate focused intervals with recovery periods, guided by your instructor and motivating music. Adjust the resistance to suit your experience and enjoy training together.
        """,
        intensity: ClassIntensity = .moderate,
        categoryName: String = "Strength",
        categoryImage: Image = .init(.lift),
        date: String = "Sept 14, 14:15",
        duration: String = "45 min",
        location: String = "Oslo",
        room: String = "Room 2",
        instructorName: String = "Thea Kristoffersen",
        bookingState: BookingState = .notBooked,
        bookedSpots: Int = 22,
        capacity: Int = 30,
        attendingFriends: [AttendingFriend] = [
            .previewValue(fullName: "Mark"),
            .previewValue(fullName: "Robert"),
        ],
        similarClasses: [GroupClassRowViewData] = [
            .previewValue()
        ]
    ) -> Self {
        .init(
            id: id,
            className: className,
            backgroundImage: backgroundImage,
            description: description,
            intensity: intensity,
            categoryName: categoryName,
            categoryImage: categoryImage,
            date: date,
            duration: duration,
            location: location,
            room: room,
            instructorName: instructorName,
            bookingState: bookingState,
            bookedSpots: bookedSpots,
            capacity: capacity,
            attendingFriends: attendingFriends,
            similarClasses: similarClasses
        )
    }
}

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
                viewData.backgroundImage
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

            Button(action: {}) {
                Text(bookingTitle)
                    .font(.headline)
                    .padding(.horizontal, .spacingM)
                    .padding(.vertical, .spacingS)
                    .foregroundStyle(.black)
                    .background(.white, in: RoundedRectangle(cornerRadius: .cornerRadiusS))
            }
            .buttonStyle(.plain)
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
                    viewData.categoryImage
                        .resizable()
                        .scaledToFill()
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

struct GroupClassScreen: View {
    let id: GroupClassID

    @State var content: BasicLoadingState<GroupClassViewData> = .idle
    @Environment(\.networkingClient.fetchGroupClass) var fetchGroupClass

    var body: some View {
        BasicStateView(state: $content) { viewData in
            GroupClassView(viewData: viewData)
        } fetchData: {
            let content = try await fetchGroupClass(id)
            return .init(dto: content)
        }
        .background(.black)
        .foregroundStyle(.white)
    }
}

#Preview {
    NavigationStack {
        GroupClassScreen(id: .previewValue())
    }
}
