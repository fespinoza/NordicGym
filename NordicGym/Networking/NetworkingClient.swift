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
            throw NetworkingError.notImplemented
        } fetchBookContent: {
            throw NetworkingError.notImplemented
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
}

enum NetworkingError: Error {
    case notImplemented
}

import SwiftUI

extension EnvironmentValues {
    @Entry var networkingClient: NetworkingClient = .fauxLive()
}
