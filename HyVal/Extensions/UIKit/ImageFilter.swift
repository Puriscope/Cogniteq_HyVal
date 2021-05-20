//
//  ImageFilter.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/8/21.
//

import UIKit

public class ImageFilter {

    static func applyFilter(to image: UIImage, diff: (r:Float, g:Float, b:Float)) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        // Redraw image for correct pixel format
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        var bytesPerRow = width * 4
        
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        
        guard let imageContext = CGContext(
            data: imageData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }
        
        imageContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
        
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                let pixel = pixels[index]
                
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
            }
        }
        
        func toByteArray<T>(_ value: T) -> [UInt8] {
                          var value = value
                          return withUnsafePointer(to: &value) {
                              $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<T>.size) {
                                  Array(UnsafeBufferPointer(start: $0, count: MemoryLayout<T>.size))
                              }
                          }
                      }
        
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                var pixel = pixels[index]
                                
                let r = Float(bitPattern: UInt32(bigEndian: pixel.red.data.withUnsafeBytes { $0.pointee } ))
                let g = Float(bitPattern: UInt32(bigEndian: pixel.green.data.withUnsafeBytes { $0.pointee } ))
                let b = Float(bitPattern: UInt32(bigEndian: pixel.blue.data.withUnsafeBytes { $0.pointee } ))
                
                
                let deltaComponentR = UnsafeRawPointer(toByteArray( r * diff.r)).assumingMemoryBound(to: UInt8.self).pointee.littleEndian
                let deltaComponentG = UnsafeRawPointer(toByteArray( g * diff.g)).assumingMemoryBound(to: UInt8.self).pointee.littleEndian
                let deltaComponentB = UnsafeRawPointer(toByteArray( b * diff.b)).assumingMemoryBound(to: UInt8.self).pointee.littleEndian
    
                pixel.red = deltaComponentR
                pixel.blue = deltaComponentB
                pixel.green = deltaComponentG

                pixels[index] = pixel
            }
        }
        
        colorSpace = CGColorSpaceCreateDeviceRGB()
        bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        bytesPerRow = width * 4
        
        guard let context = CGContext(
            data: pixels.baseAddress,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            releaseCallback: nil,
            releaseInfo: nil
        ) else { return nil }
        
        guard let newCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: newCGImage)
    }
}

public struct Pixel {
    public var value: UInt32
    
    public var red: UInt8 {
        get {
            return UInt8(value & 0xFF)
        } set {
            value = UInt32(newValue) | (value & 0xFFFFFF00)
        }
    }
    
    public var green: UInt8 {
        get {
            return UInt8((value >> 8) & 0xFF)
        } set {
            value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF)
        }
    }
    
    public var blue: UInt8 {
        get {
            return UInt8((value >> 16) & 0xFF)
        } set {
            value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF)
        }
    }
    
    public var alpha: UInt8 {
        get {
            return UInt8((value >> 24) & 0xFF)
        } set {
            value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF)
        }
    }
}

extension UInt8 {
        var data: Data {
            var int = self
            return Data(bytes: &int, count: MemoryLayout<UInt8>.size)
        }
    }
