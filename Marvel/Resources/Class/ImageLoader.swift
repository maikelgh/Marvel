//
//  UIImageViewExtension.swift
//  Marvel
//
//  Created by Michael Green on 12/9/21.
//

import UIKit

class ImageLoader: UIImageView {

    var imageUrlString: String?
    let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: URL, completion: ((Error?)-> Void)? = nil) {
        
        self.imageUrlString = url.absoluteString
        self.image = nil
        
        if url.absoluteString.elementsEqual("http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg") {
            self.image = "not-found-image".image
            completion?(nil)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            completion?(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion?(error)
                return
            }
            
            guard let data = data else {
                completion?(NSError(domain: "", code: 000, userInfo: nil))
                return
            }
            
            
            self.ui {
                
                guard let downloadedImage = UIImage(data: data) else {
                    completion?(NSError(domain: "", code: 000, userInfo: nil))
                    return
                }
                
                if (self.imageUrlString?.elementsEqual(url.absoluteString) ?? false) {
                    self.image = downloadedImage
                }
                
                self.imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                completion?(nil)
            }
            
            }.resume()
    }
    
}
