//
//  GifPlayerViewComponent.swift
//  react-native-gif-player
//
//  Created by Yusuf Zeren on 8.02.2024.
//

import UIKit
import React

@objc(GifPlayerViewComponentDelegate)
public protocol GifPlayerViewComponentDelegate {
    func handleOnLoad(duration: Double, frameCount: Int)
    func handleOnStart()
    func handleOnStop()
    func handleOnEnd()
    func handleOnFrame(frameNumber: Int)
    func handleOnError(error: NSString)
}

@objc(GifPlayerViewComponent)
public class GifPlayerViewComponent: UIImageView {
    @objc public weak var delegate: GifPlayerViewComponentDelegate? = nil
    @objc public var onLoad: RCTDirectEventBlock?
    @objc public var onStart: RCTDirectEventBlock?
    @objc public var onStop: RCTDirectEventBlock?
    @objc public var onEnd: RCTDirectEventBlock?
    @objc public var onFrame: RCTDirectEventBlock?
    @objc public var onError: RCTDirectEventBlock?
    
    private var displayLink: CADisplayLink?
    private var gifURL: URL?
    private var currentIndex = 0
    private var gifImages = [UIImage]()
    private var isPlaying: Bool = false
    private var globalPausedState: Bool = false
    private var globalLoopCount: Int = 0
    private var currentLoopCount: Int = 0
    private var preferredFramesPerSecond: Int = 10
    private var retryCount: Int = 0
    private let maxRetryCount: Int = 3
    
    
    public override func didMoveToSuperview() {
        
        super.didMoveToSuperview()
        if superview == nil {
            clearMemory()
        }
    }

    
    public func clearMemory() {
        self.gifImages.removeAll()
        self.image = nil
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc public var source: NSDictionary! {
        didSet {
            let assetSource = AssetSource(source)
            let uri = assetSource.uri ?? ""
            self.gifURL = URL(string: uri)
            if gifURL != nil {
                currentIndex = 0
                self.contentMode = .scaleAspectFit
                self.loadGIF(url: gifURL!)
            }
        }
    }
    
    @objc public var paused: Bool = false {
        didSet {
            if paused {
                stopAnimatingGIF()
            } else {
                startAnimatingGIF()
            }
        }
    }
    
    @objc public var loopCount: NSInteger = 0 {
            didSet {
                globalLoopCount = loopCount
            }
        }
    
    @objc private func handleLoad(duration: Double, frameCount: Int){
        DispatchQueue.main.async {
            self.currentLoopCount = 0
            if self.onLoad != nil {
                   //old bridge
                self.onLoad!(["duration": duration, "frameCount": frameCount])
            } else {
                   //new bridge
                self.delegate?.handleOnLoad(duration: duration, frameCount: frameCount)
            }
        }
    }

    


    @objc private func handleStart(){
        DispatchQueue.main.async {
            if self.onStart != nil {
                   //old bridge
                self.onStart!(["payload": "start"])
            } else {
                   //new bridge
                self.delegate?.handleOnStart()
            }
        }   
    }

    @objc private func handleStop(){
        DispatchQueue.main.async {
            if self.onStop != nil {
                   //old bridge
                self.onStop!(["payload": "stop"])
            } else {
                   //new bridge
                self.delegate?.handleOnStop()
            }
        }   
    }

    @objc private func handleEnd(){
        DispatchQueue.main.async {
            if self.onEnd != nil {
                   //old bridge
                self.onEnd!(["payload": "end"])
            } else {
                   //new bridge
                self.delegate?.handleOnEnd()
            }
        }   
    }
    
    @objc private func handleFrame(frameNumber: Int){
        if(self.gifImages.count == frameNumber){
            self.handleEnd()
        }
        
        if self.onFrame != nil {
               //old bridge
            self.onFrame!(["frameNumber": frameNumber])
        } else {
               //new bridge
            self.delegate?.handleOnFrame(frameNumber: frameNumber )
        }
    }
    
    @objc private func handleError(error: NSString){
        if self.onError != nil {
               //old bridge
            self.onError!(["error": error])
        } else {
               //new bridge
            self.delegate?.handleOnError(error: error)
        }
        clearMemory()
    }
    

    @objc private func loadGIF(url: URL) {
        //retryCount = 0
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    private func startAnimatingGIF() {
        
        isPlaying = true;
        globalPausedState = false
        displayLink = CADisplayLink(target: self, selector: #selector(updateFrame))
        displayLink?.preferredFramesPerSecond = preferredFramesPerSecond
        displayLink?.add(to: .main, forMode: .common)
        handleStart()
    }

    private func stopAnimatingGIF() {
        isPlaying = false;
        globalPausedState = true
        displayLink?.isPaused = true
        handleStop()
    }
    
    @objc public func jumpToFrame(frameNumber: Int){
        currentIndex = 0;
        updateFrame()
    }

    @objc public func memoryClear(){
        clearMemory()
    }
    

    private func calculatePreferredFramesPerSecond(forDuration duration: Double, frameCount: Int) -> Int {
        let averageDelay = duration / Double(frameCount)
        
        let framesPerSecond = 1.0 / averageDelay
        
        return Int(framesPerSecond.rounded())
    }
    
    
    @objc private func updateFrame() {
        guard !gifImages.isEmpty else {
            return // GIF images array is empty, exit method
        }
        
        if currentIndex >= gifImages.count {
            currentIndex = 0
            currentLoopCount += 1
            if(globalLoopCount != 0){
                if(currentLoopCount >= globalLoopCount){
                    stopAnimatingGIF()
                    currentLoopCount = 0
                    return
                }
            }
        }
        
        
        image = gifImages[currentIndex]
        let imageWithDuration = gifImages[currentIndex] as! AnimatedImage
        let framesPerSecond = 1.0 / imageWithDuration.frameDuration
        displayLink?.preferredFramesPerSecond = Int(framesPerSecond)
        
        currentIndex += 1
        handleFrame(frameNumber: currentIndex)
    }
}

extension AnimatedImage {
   class func animatedImage(withAnimatedGIFData data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        let count = CGImageSourceGetCount(source)
        
        var images = [UIImage]()
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let frameDuration = CGImageSourceGIFFrameDuration(source: source, index: i)
                let newImage = AnimatedImage(cgImage: cgImage)
                newImage.frameDuration = frameDuration
                images.append(newImage)
            }
        }
        
        let duration = images.reduce(0) {
            $0 + CGImageSourceGIFFrameDuration(source: source, index: $1.images?.firstIndex(of: $1) ?? 0)
        }
        
        
        return UIImage.animatedImage(with: images, duration: duration)
    }
    
    class func CGImageSourceGIFFrameDuration(source: CGImageSource, index: Int) -> TimeInterval {
       var delay = 0.1
       
       guard let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) else {
           return delay
       }
        let gifProperties = (cfProperties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary
       
        if let delayObject = gifProperties?[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber {
           delay = delayObject.doubleValue
       } else {
           if let delayObject = gifProperties?[kCGImagePropertyGIFDelayTime as String] as? NSNumber {
               delay = delayObject.doubleValue
           }
       }
        
        let webPProperties = (cfProperties as NSDictionary)["{WebP}" as String] as? NSDictionary
        
        if let delayObject = webPProperties?[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber {
           delay = delayObject.doubleValue
       } else {
           if let delayObject = webPProperties?[kCGImagePropertyGIFDelayTime as String] as? NSNumber {
               delay = delayObject.doubleValue
           }
       }
       
       
       if delay < 0.1 {
           delay = 0.1 // Set a minimum
       }
        
       return delay
   }
}


extension GifPlayerViewComponent: URLSessionDownloadDelegate {
    
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        _ = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    }
    
        
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
           do {
               let data = try Data(contentsOf: location)
               DispatchQueue.main.async {
                   if let image = AnimatedImage.animatedImage(withAnimatedGIFData: data) {
                       self.gifImages = image.images ?? []
                       self.preferredFramesPerSecond = self.calculatePreferredFramesPerSecond(forDuration: image.duration, frameCount: self.gifImages.count)
                       if !self.isPlaying {
                           self.updateFrame()
                       }
                       if !self.globalPausedState && !self.isPlaying {
                           self.startAnimatingGIF()
                       }
                       self.handleLoad(duration: image.duration * 1000, frameCount: self.gifImages.count)
                   } else if let image = UIImage(data: data) {
                       self.image = image
                       self.handleLoad(duration: 0, frameCount: 1)
                   } else {
                       // Retry mechanism
                       if self.retryCount < self.maxRetryCount {
                           self.retryCount += 1
                           self.loadGIF(url: downloadTask.originalRequest!.url!) // Retry downloading
                       } else {
                           self.handleError(error: "Invalid image format")
                       }
                   }
               }
           } catch {
               // Retry mechanism
               if self.retryCount < self.maxRetryCount {
                   self.retryCount += 1
                   self.loadGIF(url: downloadTask.originalRequest!.url!) // Retry downloading
               } else {
                   self.handleError(error: error.localizedDescription as NSString)
               }
           }
       }
}
