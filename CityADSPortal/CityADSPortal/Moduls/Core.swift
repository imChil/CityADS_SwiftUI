
import Foundation
import SwiftUI

final class Core {
    
    let fileManager = StorageManager()
    let networkService = NetworkService.shared
    
    func getImage(id: String, completion: @escaping (UIImage) -> Void) {
        
        if let image = fileManager.getImage(id: id) {
            completion(image)
        } else {
            networkService.getImage(id: id) {[weak self] image in
                if let dataImage = image.pngData() {
                    self?.fileManager.saveImage(id: id, image: dataImage)
                }
                completion(image)
            }
            
        }
        
    }
}
