//
//  NetworkingClient.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 14/09/2026.
//

import Foundation
import Tagged

struct DataClient {
    let fetchHomeContent: () async throws -> [HomeModuleViewData]
    let fetchBookContent: () async throws -> [BookModuleViewData]
    let fetchGroupClass: (GroupClassID) async throws -> GroupClassViewData

    static func fauxLive() -> Self {
        bridgeClient(networkingClient: .fauxLive())
    }

    static func test() -> Self {
        bridgeClient(networkingClient: .test())
    }

    init(
        fetchHomeContent: @escaping () async throws -> [HomeModuleViewData] = { throw NetworkingError.notImplemented },
        fetchBookContent: @escaping () async throws -> [BookModuleViewData] = { throw NetworkingError.notImplemented },
        fetchGroupClass: @escaping (GroupClassID) async throws -> GroupClassViewData = {
            _ in throw NetworkingError.notImplemented
        }
    ) {
        self.fetchHomeContent = fetchHomeContent
        self.fetchBookContent = fetchBookContent
        self.fetchGroupClass = fetchGroupClass
    }

    private static func bridgeClient(networkingClient: NetworkingClient) -> Self {
        return .init {
            let content: [HomeModule] = try await networkingClient.fetchHomeContent()
            return content.map { .init(dto: $0) }
        } fetchBookContent: {
            let content: [BookModule] = try await networkingClient.fetchBookContent()
            var viewData: [BookModuleViewData] = [
                .services([
                    .init(iconName: "person.3.fill", title: "Group Class"),
                    .init(iconName: "figure.strengthtraining.traditional", title: "Personal Trainer"),
                    .init(iconName: "figure.flexibility", title: "Physiotherapy")
                ])
            ]
            content.forEach { dtoModule in
                viewData.append(.init(dto: dtoModule))
            }
            return viewData
        } fetchGroupClass: { id in
            let content: GroupClass = try await networkingClient.fetchGroupClass(id)
            return .init(dto: content)
        }
    }
}

struct NetworkingClient {
    let fetchHomeContent: () async throws -> [HomeModule]
    let fetchBookContent: () async throws -> [BookModule]
    let fetchGroupClass: (GroupClassID) async throws -> GroupClass

    static func fauxLive() -> Self {
        mockClient(sleeps: true)
    }

    static func test() -> Self {
        mockClient(sleeps: false)
    }

    private static func randomlySleeps(isActive: Bool) async throws {
        guard isActive else { return }
        try await Task.sleep(for: .seconds((1...3).randomElement() ?? 1))
    }

    private static func mockClient(sleeps: Bool) -> Self {
        .init {
            try await randomlySleeps(isActive: sleeps)
            let homeContent: HomeContent = try fixtureFile(fileName: "home-sample")
            return homeContent.items
        } fetchBookContent: {
            try await randomlySleeps(isActive: sleeps)
            let bookContent: BookContent = try fixtureFile(fileName: "book-sample")
            return bookContent.items
        } fetchGroupClass: { id in
            try await randomlySleeps(isActive: sleeps)
            return try fixtureFile(fileName: "group-class-\(id.rawValue)")
        }
    }

    init(
        fetchHomeContent: @escaping () async throws -> [HomeModule] = { throw NetworkingError.notImplemented },
        fetchBookContent: @escaping () async throws -> [BookModule] = { throw NetworkingError.notImplemented },
        fetchGroupClass: @escaping (GroupClassID) async throws -> GroupClass = {
            _ in throw NetworkingError.notImplemented
        }
    ) {
        self.fetchHomeContent = fetchHomeContent
        self.fetchBookContent = fetchBookContent
        self.fetchGroupClass = fetchGroupClass
    }

    static func fixtureFile<Model: Decodable>(fileName: String) throws -> Model {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NetworkingError.fixtureFileNotFound("\(fileName).json")
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Model.self, from: data)
    }
}

enum NetworkingError: Error, LocalizedError {
    case notImplemented
    case fixtureFileNotFound(String)

    var errorDescription: String? {
        switch self {
        case .notImplemented: "Endpoint not implemented"
        case let .fixtureFileNotFound(fileName): "Fixture file '\(fileName)' not found"
        }
    }
}

import SwiftUI

extension EnvironmentValues {
    @Entry var networkingClient: NetworkingClient = .fauxLive()
}


extension EnvironmentValues {
    @Entry var dataClient: DataClient = .fauxLive()
}
