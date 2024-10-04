//
//  ContentBlockerRequestHandler.swift
//  SafariExtension
//
//  Created by Alex Catchpole on 23/09/2024.
//

import UIKit
import MobileCoreServices
import Shared

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let provider = ContentBlockerProvider()
        do {
            let item = try provider.getJSONAttachmentForType(type: .core)
            context.completeRequest(returningItems: [item], completionHandler: nil)
        } catch {
            context.cancelRequest(withError: error)
        }
    }
    
}
