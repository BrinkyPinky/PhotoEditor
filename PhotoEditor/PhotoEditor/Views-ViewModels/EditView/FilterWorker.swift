//
//  FilterWorker.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 28.06.2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class FilterWorker {
    
    //Добавляет фильтры на изображение
    func applyFilter(to image: UIImage, colorSettings: [ColorSettingModel], pickedEffect: EffectTypes, croppedTo rect: CGRect) -> UIImage? {
        guard let originalImage = CIImage(image: image) else { return nil }
        
        var LastCIFilter = CIFilter()
        
        switch pickedEffect {
        case .def: break
        case .chrome:
            addEffect(filter: CIFilter.photoEffectChrome())
        case .fade:
            addEffect(filter: CIFilter.photoEffectFade())
        case .instant:
            addEffect(filter: CIFilter.photoEffectInstant())
        case .mono:
            addEffect(filter: CIFilter.photoEffectMono())
        case .noir:
            addEffect(filter: CIFilter.photoEffectNoir())
        case .process:
            addEffect(filter: CIFilter.photoEffectProcess())
        case .tonal:
            addEffect(filter: CIFilter.photoEffectTonal())
        case .transfer:
            addEffect(filter: CIFilter.photoEffectTransfer())
        }
        
        
        func addEffect(filter: CIFilter & CIPhotoEffect) {
            LastCIFilter = filter
            LastCIFilter.setValue(originalImage, forKey: kCIInputImageKey)
        }
        
        colorSettings.forEach({
            switch $0.type {
            case .exposure:
                addFilter(ciFilterName: "CIExposureAdjust", intensity: $0.intensity, forKey: kCIInputEVKey)
            case .brightness:
                addFilter(ciFilterName: "CIColorControls", intensity: $0.intensity, forKey: kCIInputBrightnessKey)
            case .saturation:
                addFilter(ciFilterName: "CIColorControls", intensity: $0.intensity, forKey: kCIInputSaturationKey)
            case .contrast:
                addFilter(ciFilterName: "CIColorControls", intensity: $0.intensity, forKey: kCIInputContrastKey)
            case .hue:
                addFilter(ciFilterName: "CIHueAdjust", intensity: $0.intensity, forKey: kCIInputAngleKey)
            case .vignette:
                addFilter(ciFilterName: "CIVignette", intensity: $0.intensity, forKey: kCIInputIntensityKey)
            case .gamma:
                addFilter(ciFilterName: "CIGammaAdjust", intensity: $0.intensity, forKey: "inputPower")
            case .none: return
            }
        })
        
        func addFilter(ciFilterName: String, intensity: CGFloat, forKey: String) {
            let filter = CIFilter(name: ciFilterName)!
            filter.setValue(LastCIFilter.outputImage ?? originalImage, forKey: kCIInputImageKey)
            filter.setValue(intensity, forKey: forKey)
            LastCIFilter = filter
        }
        
        var renderedCIImage: CIImage
        
        if rect != .zero {
            renderedCIImage = LastCIFilter.outputImage!.cropped(to: rect)
        } else {
            renderedCIImage = LastCIFilter.outputImage!
        }
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(renderedCIImage, from: renderedCIImage.extent) else { return nil }
        let uiImage = UIImage(cgImage: cgImage)
        
        return uiImage
    }
}
