//
//  LoadingImageView.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit

class DiscardableImageCacheItem: NSObject, NSDiscardableContent {
    private(set) public var image: UIImage?
    var accessCount: UInt = 0
    
    public init(image: UIImage) {
        self.image = image
    }
    
    public func beginContentAccess() -> Bool {
        if image == nil {
            return false
        }
        
        accessCount += 1
        return true
    }
    
    public func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }
    
    public func discardContentIfPossible() {
        if accessCount == 0 {
            image = nil
        }
    }
    
    public func isContentDiscarded() -> Bool {
        return image == nil
    }
}

// todo: add dictionary with sizes and resize it here
class LoadingImageView: UIImageView {
    static let imageCache = NSCache<NSString, DiscardableImageCacheItem>()
    
    var imageURL: String?
    var dataTask: URLSessionDataTask?
    
    func loadImage(imageURL: String?, placeholder: UIImage? = nil, completion: (() -> ())? = nil) {
        self.image = placeholder
        guard let strUrl = imageURL, let url = URL(string: strUrl) else { return }
        cancelLoading()
        self.imageURL = imageURL
        
        if let cachedItem = LoadingImageView.imageCache.object(forKey: strUrl as NSString) {
            self.image = cachedItem.image
            completion?()
        } else {
            dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                if let imageToCache = UIImage(data: data) {
                    let cacheItem = DiscardableImageCacheItem(image: imageToCache)
                    LoadingImageView.imageCache.setObject(cacheItem, forKey: strUrl as NSString)
                    if self?.imageURL == imageURL {
                        DispatchQueue.main.async {
                            self?.image = imageToCache
                        }
                        self?.imageURL = nil
                    }
                    self?.dataTask = nil
                    completion?()
                }
            }
            dataTask?.resume()
        }
    }
    
    func cancelLoading() {
        dataTask?.cancel()
    }
}
