//
//  ContentBlockerRequestHandler.swift
//  AnnoyancesSafariExtension
//
//  Created by Alex Catchpole on 03/10/2024.
//

import UIKit
import MobileCoreServices
import Shared

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let provider = ContentBlockerProvider()
        do {
            let item = try provider.getJSONAttachmentForType(type: .annoyance)
            context.completeRequest(returningItems: [item], completionHandler: nil)
        } catch {
            print("[ANNOYANCES] - error: \(error.localizedDescription)")
            context.cancelRequest(withError: error)
        }
    }
    
}
