
import Foundation
import SwiftUI

final class ImageService: ObservableObject {
    
    private let fileManager = StorageManager()
    private let networkService = NetworkService()
    
    func getImage(id: String, completion: @escaping (UIImage) -> Void) {
        
        if let image = fileManager.getImage(id: id) {
            completion(image)
        } else {
            networkService.getImage(id: id) {[weak self] image in
                if let dataImage = image.pngData() {
                    self?.fileManager.saveImage(id: id, image: dataImage)
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
        }
        
    }
}
