import SwiftUI

struct GroupClassViewData {
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

    let attendingFriends: [String]

    let similarClasses: [SimilarClassViewData]
}

struct GroupClassDetailViewData {
    let groupClass: GroupClassCardViewData
    let instructorName: String
    let room: String
    let bookedSpots: Int
    let capacity: Int
    let attendingFriends: [String]
    let description: String
    let intensity: ClassIntensity
    let categoryName: String
    let categoryImage: Image
    let similarClasses: [SimilarClassViewData]

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
        let isCycling = groupClass.className.localizedCaseInsensitiveContains("cycling")
        return .init(
            groupClass: groupClass,
            instructorName: "Mai Emilie Thi Nguyen",
            room: room,
            bookedSpots: 23,
            capacity: 24,
            attendingFriends: ["Alex Morgan"],
            description: isCycling
                ? "Challenge your endurance in an energising indoor cycling session. Alternate focused intervals with recovery periods, guided by your instructor and motivating music. Adjust the resistance to suit your experience and enjoy training together."
                : "Performance HYROX combines running with eight workout disciplines inspired by a HYROX race. Expect a challenging mix of endurance and strength, including rowing, SkiErg and burpees. This class is suited to people with some training experience and is available at selected clubs.",
            intensity: .intense,
            categoryName: isCycling ? "Cycling" : "Performance",
            categoryImage: isCycling ? Image(.cycling) : Image(.crossfit),
            similarClasses: [
                .init(id: "similar-1", day: "Tomorrow", time: "19:00", duration: "45 min",
                      title: isCycling ? "Cycling Interval" : "Performance HIIT – I Go, You Go",
                      instructor: "Stig Unhammer", location: groupClass.location, availableSpots: 1),
                .init(id: "similar-2", day: "Saturday, 19 September", time: "12:15", duration: "45 min",
                      title: isCycling ? "Cycling Endurance" : "Performance HIIT – I Go, You Go",
                      instructor: "Cathrine Liu", location: groupClass.location, availableSpots: 21)
            ]
        )
    }
}

struct GroupClassDetailScreen: View {
    let viewData: GroupClassDetailViewData
    var onBook: (() -> Void)? = nil
    var onBookSimilarClass: ((SimilarClassViewData) -> Void)? = nil
    var onViewSchedule: (() -> Void)? = nil

    @State private var showsBookingNotice = false
    @State private var showsScheduleNotice = false
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

                GroupClassAdditionalInformation(
                    viewData: viewData,
                    onBook: { groupClass in
                        if let onBookSimilarClass {
                            onBookSimilarClass(groupClass)
                        } else {
                            showsBookingNotice = true
                        }
                    },
                    onViewSchedule: {
                        if let onViewSchedule {
                            onViewSchedule()
                        } else {
                            showsScheduleNotice = true
                        }
                    }
                )
                .padding(.spacingM)
                .padding(.top, .spacingL)
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
                ShareLink(item: "\(viewData.groupClass.className) — \(viewData.groupClass.date) at \(viewData.groupClass.location)") {
                    Label("Share class", systemImage: "square.and.arrow.up")
                }
            }
        }
        .alert("Sample schedule", isPresented: $showsScheduleNotice) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The full timetable is not connected yet. The classes shown here are sample sessions.")
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
            Button(action: bookClass) {
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
        VStack(alignment: .leading, spacing: .spacingL) {
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

            ShareLink(item: "Join me for \(viewData.groupClass.className) — \(viewData.groupClass.date) at \(viewData.groupClass.location).") {
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

    private func bookClass() {
        if let onBook {
            onBook()
        } else {
            showsBookingNotice = true
        }
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

            Button(action: bookClass) {
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
