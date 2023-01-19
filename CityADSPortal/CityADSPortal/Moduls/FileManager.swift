import Foundation
import SwiftUI

final class StorageManager {
    
    let manager = FileManager.default
    let appSupp = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    func saveImage(id: String, image: Data) {
        
        if let imageFileUrl = getImageFileUrl(id: id) {
            try? image.write(to: imageFileUrl)
        }
        
    }
    
    func getImage(id: String) -> UIImage? {
        
        if let imageFileUrl = getImageFileUrl(id: id) {
            if let fileData = try? Data(contentsOf: imageFileUrl) {
                let image = UIImage(data: fileData)
            
                return image
            }
        }
        
        return nil
    }
    
    private func getImageFileUrl(id: String) -> URL? {
        
        if let imageFileUrl = appSupp?.appendingPathComponent("\(id).jpg") {
            return imageFileUrl
        }
        
        return nil
    }
    
}

