//
//  GifPlayerViewManager.swift
//  react-native-gif-player
//
//  Created by Yusuf Zeren on 9.02.2024.
//

import React
import UIKit

@objc(GifPlayerViewManager)
public class GifPlayerViewManager: RCTViewManager {
    var myView: GifPlayerViewComponent?


    public override func view() -> (GifPlayerViewComponent) {
        myView = GifPlayerViewComponent()
        return myView!
    }

    func methodQueue() -> DispatchQueue {
        return bridge.uiManager.methodQueue
    }
    @objc public override static func requiresMainQueueSetup() -> Bool {
        return false
    }
    
    @objc(jumpToFrame:frameNumber:)
    func jumpToFrame(_ reactTag: NSNumber, frameNumber:NSInteger){
        bridge.uiManager.prependUIBlock({_, viewRegistry_DEPRECATED in
            let view = viewRegistry_DEPRECATED?[reactTag]
            if !(view is GifPlayerViewComponent){
                print("Cannot find GifPlayerViewComponent with tag #%@", reactTag);
            }else if let view = view as? GifPlayerViewComponent {
                view.jumpToFrame(frameNumber: frameNumber)
            }
     })
    }

    @objc(memoryClear:)
    func memoryClear(_ reactTag: NSNumber){
        bridge.uiManager.prependUIBlock({_, viewRegistry_DEPRECATED in
            let view = viewRegistry_DEPRECATED?[reactTag]
            if !(view is GifPlayerViewComponent){
                print("Cannot find GifPlayerViewComponent with tag #%@", reactTag);
            }else if let view = view as? GifPlayerViewComponent {
                view.memoryClear()
            }
     })
    }

}
