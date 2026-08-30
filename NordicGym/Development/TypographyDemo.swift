//
//  TypographyDemo.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 17/09/2026.
//

import SwiftUI

struct TypographyDemo: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: .spacingM) {
                Text("Large Title - 34").font(.largeTitle)

                Text("Title - 28").font(.title)

                Text("Title 2 - 22").font(.title2)

                Text("Title 3 - 20").font(.title3)

                Text("Headline - 17").font(.headline)

                Text("Default - 17").font(.default)

                Text("Callout - 16").font(.callout)

                Text("Sub-Headline - 15").font(.subheadline)

                Text("Footnote - 13").font(.footnote)

                Text("Caption - 12").font(.caption)

                Text("Caption 2 - 11").font(.caption2)
            }
        }
    }
}

#Preview {
    TypographyDemo()
}
