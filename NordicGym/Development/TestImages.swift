import SwiftUI

/// Local images for the URLs in Resources/SampleData.
enum TestImages {
    /// Returns the bundled image for a sample URL, or nil for a missing or unknown URL.
    static func image(for url: URL?) -> Image? {
        switch url?.absoluteString {
        case "https://images.pexels.com/photos/3757943/pexels-photo-3757943.jpeg?auto=compress&cs=tinysrgb&w=900":
            Image(.sampleStrength)
        case "https://images.pexels.com/photos/4162486/pexels-photo-4162486.jpeg?auto=compress&cs=tinysrgb&w=900":
            Image(.sampleRowing)
        case "https://images.pexels.com/photos/4162595/pexels-photo-4162595.jpeg?auto=compress&cs=tinysrgb&w=900":
            Image(.sampleCycling)
        case "https://images.pexels.com/photos/4587342/pexels-photo-4587342.jpeg?auto=compress&cs=tinysrgb&w=900":
            Image(.sampleYoga)
        case "https://images.pexels.com/photos/4587371/pexels-photo-4587371.jpeg?auto=compress&cs=tinysrgb&w=900":
            Image(.sampleFeaturedContent)
        case "https://images.pexels.com/photos/5936039/pexels-photo-5936039.jpeg?auto=compress&cs=tinysrgb&w=900":
            Image(.sampleDance)
        case "https://randomuser.me/api/portraits/men/32.jpg":
            Image(.sampleErikPortrait)
        case "https://randomuser.me/api/portraits/men/46.jpg":
            Image(.sampleSandrePortrait)
        case "https://randomuser.me/api/portraits/men/75.jpg":
            Image(.sampleMikkelPortrait)
        case "https://randomuser.me/api/portraits/women/44.jpg":
            Image(.sampleNoraPortrait)
        case "https://randomuser.me/api/portraits/women/68.jpg":
            Image(.sampleAminaPortrait)
        default:
            nil
        }
    }
}
