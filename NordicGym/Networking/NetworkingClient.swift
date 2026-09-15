//
//  NetworkingClient.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 14/09/2026.
//

import Foundation

struct NetworkingClient {
    let fetchHomeContent: () async throws -> [HomeModule]
    let fetchBookContent: () async throws -> [BookModule]
    let fetchGroupClass: (GroupClassID) async throws -> GroupClass

    static func fauxLive() -> Self {
        .init {
            try await Task.sleep(for: .seconds((1...3).randomElement() ?? 1))
            let homeContent: HomeContent = try fixtureFile(fileName: "home-sample")
            return homeContent.items
        } fetchBookContent: {
            try await Task.sleep(for: .seconds((1...3).randomElement() ?? 1))
            let bookContent: BookContent = try fixtureFile(fileName: "book-sample")
            return bookContent.items
        } fetchGroupClass: { _ in
            throw NetworkingError.notImplemented
        }
    }

    init(
        fetchHomeContent: @escaping () async throws -> [HomeModule],
        fetchBookContent: @escaping () async throws -> [BookModule],
        fetchGroupClass: @escaping (GroupClassID) async throws -> GroupClass
    ) {
        self.fetchHomeContent = fetchHomeContent
        self.fetchBookContent = fetchBookContent
        self.fetchGroupClass = fetchGroupClass
    }

    private static func fixtureFile<Model: Decodable>(fileName: String) throws -> Model {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NetworkingError.fixtureFileNotFound("\(fileName).json")
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Model.self, from: data)
    }
}

enum NetworkingError: Error {
    case notImplemented
    case fixtureFileNotFound(String)
}

import SwiftUI

extension EnvironmentValues {
    @Entry var networkingClient: NetworkingClient = .fauxLive()
}
