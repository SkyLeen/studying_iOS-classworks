//
//  GetHashImageOperation.swift
//  myWeather 
//
//  Created by Natalya on 03/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class GetHashImage: Operation {
    
    private let cashLifeTime: TimeInterval = 2_592_000
    private let url: String
    var outputImage: UIImage?
    
    
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cashDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cashDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private lazy var filePath: String? = {
        
        guard let cashDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let name = String(describing: url.hashValue)
        let filePath = cashDirectory.appendingPathComponent("\(GetHashImage.pathName)/\(name)").path
        
        return filePath
    }()
    
    init(url: String) {
        self.url = url
    }
    
    override func main() {
        guard filePath != nil && !isCancelled else { return }
        if getImageFromCash() { return }
        
        guard !isCancelled else { return }
        if !downloadImage() { return }
        
        guard !isCancelled else { return }
        saveImageToCash()
        
    }
    
    private func getImageFromCash() -> Bool {
        guard let fileName = filePath,
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
            else { return false }
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cashLifeTime, let image = UIImage(contentsOfFile: fileName) else { return false }
        self.outputImage = image
        
        return true
    }
    
    private func downloadImage() -> Bool {
        guard let url = URL(string: url),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
            else { return false }
        self.outputImage = image
        
        return true
    }
    
    private func saveImageToCash() {
        guard let path = filePath, let image = outputImage else { return }
        let data = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }
}
