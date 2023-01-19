
import Foundation
import SwiftUI

extension Image {
    
    init?(data: Data) {
        guard let image = UIImage(data: data) else { return nil }
        self = .init(uiImage: image)
    }
    
}
