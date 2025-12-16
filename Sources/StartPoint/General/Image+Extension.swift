//
//  File.swift
//
//
//  Created by Gray on 2023/11/6.
//

import Foundation
#if os(iOS)
import UIKit


public extension UIImage {
    func saveToPhotosAlbum(completionHandler: @escaping (Error?) -> Void) {
        let photosSaver = PhotosSaver(completionHandler: completionHandler)
        photosSaver.writeToPhotoAlbum(image: self)
    }
}

class PhotosSaver: NSObject {

    var completionHandler: ((Error?) -> Void)?

    init(completionHandler: @escaping (Error?) -> Void) {
        self.completionHandler = completionHandler
    }

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        completionHandler?(error)
    }
}
#endif
