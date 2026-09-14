import SwiftUI

enum ClassIntensity: String, CaseIterable {
    case light = "Light"
    case moderate = "Moderate"
    case intense = "Intense"
}

struct SimilarClassViewData: Identifiable {
    let id: String
    let day: String
    let time: String
    let duration: String
    let title: String
    let instructor: String
    let location: String
    let availableSpots: Int
}

struct GroupClassAdditionalInformation: View {
    let viewData: GroupClassDetailViewData
    let onBook: (SimilarClassViewData) -> Void
    let onViewSchedule: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingXL) {
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
                            similarClass(groupClass)
                        }
                    }
                    .padding(.spacingM)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.04, green: 0.12, blue: 0.18),
                                in: RoundedRectangle(cornerRadius: .cornerRadiusM))
                }
            }

            Button(action: onViewSchedule) {
                Text("View full timetable")
                    .font(.subheadline.bold())
                    .padding(.spacingS)
                    .overlay(RoundedRectangle(cornerRadius: .cornerRadiusS).stroke(.white, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .foregroundStyle(.white)
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

    private func similarClass(_ groupClass: SimilarClassViewData) -> some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: .spacingS))
            : AnyLayout(HStackLayout(alignment: .top, spacing: .spacingS))

        return VStack(alignment: .leading, spacing: .spacingM) {
            Text(groupClass.day)
                .font(.subheadline)
                .foregroundStyle(.gray)

            layout {
                VStack(alignment: .leading, spacing: .spacingXXS) {
                    Text(groupClass.time)
                    Text(groupClass.duration)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .fixedSize(horizontal: true, vertical: false)

                VStack(alignment: .leading, spacing: .spacingXXS) {
                    Text(groupClass.title)
                    Text(groupClass.instructor)
                        .foregroundStyle(.white.opacity(0.7))
                    Text(groupClass.location)
                        .foregroundStyle(.white.opacity(0.7))
                    Text(groupClass.availableSpots == 1 ? "1 spot available" : "\(groupClass.availableSpots) spots available")
                        .foregroundStyle(.mint)
                }
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

                Button { onBook(groupClass) } label: {
                    Text(groupClass.availableSpots == 0 ? "Join waiting list" : "Book")
                        .font(.subheadline.bold())
                        .padding(.spacingS)
                        .foregroundStyle(.black)
                        .background(.white, in: RoundedRectangle(cornerRadius: .cornerRadiusS))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Book \(groupClass.title), \(groupClass.day) at \(groupClass.time)")
            }
        }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: .spacingM) {
            Text(title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            content()
        }
    }
}

#Preview {
    ScrollView {
        GroupClassAdditionalInformation(viewData: .previewValue(), onBook: { _ in }, onViewSchedule: {})
            .padding()
    }
    .background(.black)
}
