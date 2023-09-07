//
//  AdMobManager+Native.swift
//  MobileAds
//
//  Created by macbook on 29/08/2021.
//

import Foundation
import GoogleMobileAds
import SkeletonView
import FirebaseAnalytics

public enum OptionAdType {
    case option_1
    case option_2
}

public enum NativeAdType {
    case small
    case medium
    case unified(OptionAdType)
    case freeSize
    case smallMedia
    case fullScreen
    case collectionViewCell
    
    var nibName: String {
        switch self {
        case .small:
            return "SmallNativeAdView"
        case .fullScreen:
            return "FullScreenNativeAdView"
        case .medium:
            return "MediumNativeAdView"
        case .unified(let option):
            switch option {
            case .option_1:
                return "UnifiedNativeAdView"
            case .option_2:
                return "UnifiedNativeAdView_2"
            }
        case .freeSize:
            return "FreeSizeNativeAdView"
        case .smallMedia:
            return "SmallMediaNativeAdView"
        case .collectionViewCell:
            return "CellMediaNativeAdView"
        }
    }
}

// MARK: - GADUnifiedNativeAdView
extension AdMobManager {
   
    private func getNativeAdLoader(unitId: AdUnitID) -> GADAdLoader? {
        return listLoader.object(forKey: unitId.rawValue) as? GADAdLoader
    }

    private func getAdNative(unitId: String) -> [NativeAdProtocol]? {
        if let adNativeView = listAd.object(forKey: unitId) as? [NativeAdProtocol] {
            return adNativeView
        }
        return nil
    }
    
    private func createAdNativeView(unitId: AdUnitID, type: NativeAdType = .small, views: [UIView]) {
        if let _ = getAdNative(unitId: unitId.rawValue) {
            return
        }

        var nativeViews: [NativeAdProtocol] = []
        views.forEach { view in
            guard
                let nibObjects = Bundle.main.loadNibNamed(type.nibName, owner: nil, options: nil),
                let adNativeProtocol = nibObjects.first as? NativeAdProtocol else {
                    return
                }
            let adNativeView = adNativeProtocol.getGADView()
            view.tag = 0
            view.subviews.forEach { subView in
                subView.removeFromSuperview()
            }
            view.addSubview(adNativeView)
            adNativeView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            adNativeView.layoutIfNeeded()
            adNativeView.isSkeletonable = true
            let gradient = SkeletonGradient(baseColor: self.skeletonGradient)
            adNativeView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration: 0.7))
            nativeViews.append(adNativeProtocol)
        }
        
        listAd.setObject(nativeViews, forKey: unitId.rawValue as NSCopying)
    }
    
    private func reloadAdNative(unitId: AdUnitID) {
        if let loader = self.getNativeAdLoader(unitId: unitId) {
            loader.load(GADRequest())
        }
    }
    
    public func addAdNative(unitId: AdUnitID, rootVC: UIViewController, views: [UIView], type: NativeAdType = .small, ratio: GADMediaAspectRatio = .portrait) {
        removeAd(unitId: unitId.rawValue)
        createAdNativeView(unitId: unitId, type: type, views: views)
        loadAdNative(unitId: unitId, rootVC: rootVC, numberOfAds: views.count, ratio: ratio)
    }
    
    private func loadAdNative(unitId: AdUnitID, rootVC: UIViewController, numberOfAds: Int, ratio: GADMediaAspectRatio) {
        if let loader = getNativeAdLoader(unitId: unitId) {
            loader.load(GADRequest())
            return
        }
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = numberOfAds
        let aspectRatioOption = GADNativeAdMediaAdLoaderOptions()
        aspectRatioOption.mediaAspectRatio = ratio
        let adLoader = GADAdLoader(adUnitID: unitId.rawValue,
            rootViewController: rootVC,
            adTypes: [ .native ],
            options: [multipleAdsOptions, aspectRatioOption])
        listLoader.setObject(adLoader, forKey: unitId.rawValue as NSCopying)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
}

// MARK: - GADUnifiedNativeAdDelegate
extension AdMobManager: GADNativeAdDelegate {
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("ad==> nativeAdDidRecordClick ")
        logEventNative(nativeAd: nativeAd)
    }
    
    func logEventNative(nativeAd: GADNativeAd) {
        let adViews = listAd.allValues
        adViews.forEach { ad in
            if let nativeAdViews = ad as? [NativeAdProtocol] {
                if let ad = nativeAdViews.first(where: {$0.getGADView() == nativeAd}) {
                    logEvenClick(id: ad.adUnitID ?? "")
                }
            }
        }
    }
}

// MARK: - GADAdLoaderDelegate
extension AdMobManager: GADAdLoaderDelegate {
    
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        self.blockNativeFaild?(adLoader.adUnitID)
        self.removeAd(unitId: adLoader.adUnitID)
    }
    
    public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        listLoader.removeObject(forKey: adLoader.adUnitID)
        print("ad==> adLoaderDidFinishLoading \(adLoader)")
    }
}

// MARK: - GADUnifiedNativeAdLoaderDelegate
extension AdMobManager: GADNativeAdLoaderDelegate {
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        nativeAd.delegate = self
        nativeAd.paidEventHandler = { value in
            self.trackAdRevenue(value: value, unitId: adLoader.adUnitID)
        }
        guard var nativeAdView = self.getAdNative(unitId: adLoader.adUnitID)?.first(where: {$0.getGADView().tag == 0}) else {return}
        nativeAdView.getGADView().tag = 2
        nativeAd.mediaContent.videoController.delegate = self
        nativeAdView.updateId(value: adLoader.adUnitID)
        nativeAdView.getGADView().hideSkeleton()
        nativeAdView.bindingData(nativeAd: nativeAd)
    }
    
    public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("ad==> nativeAdDidRecordImpression")
    }
    
}

// MARK: - GADVideoControllerDelegate
extension AdMobManager: GADVideoControllerDelegate {
    
}
