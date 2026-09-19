@testable import NordicGym
import Foundation
import Testing

@Suite struct HomeModuleViewDataTests {
    @Test func `mock module identities are stable and unique`() {
        let firstIDs = HomeModuleViewData.mockData().map(\.id)
        let secondIDs = HomeModuleViewData.mockData().map(\.id)

        #expect(firstIDs == secondIDs)
        #expect(Set(firstIDs).count == firstIDs.count)
    }

    @Test func `featured content maps its message`() {
        let dto = FeaturedContent(
            id: UUID(),
            title: "Find your next class",
            message: "Explore a workout that fits your goals.",
            imageURL: nil
        )

        let viewData = ContentCardViewData(dto: dto)

        #expect(viewData.id == dto.id.uuidString)
        #expect(viewData.title == dto.title)
        #expect(viewData.text == dto.message)
    }
}
