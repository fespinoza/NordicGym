//
//  Tagged-Extensions.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 08/09/2026.
//

import Foundation
import Tagged

extension Tagged where RawValue == String {
    static func previewValue() -> Self {
        .init(UUID().uuidString)
    }
}
