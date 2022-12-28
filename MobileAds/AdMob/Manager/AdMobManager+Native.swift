//
//  AdMobManager+Native.swift
//  MobileAds
//
//  Created by macbook on 29/08/2021.
//

import Foundation
import GoogleMobileAds
import SkeletonView

public enum OptionAdType {
    case option_1
    case option_2
}

public enum NativeAdType {
    case small
    case medium
    case unified(OptionAdType)
    case freeSize
    
    var nibName: String {
        switch self {
        case .small:
            return "SmallNativeAdView"
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
            return  "FreeSizeNativeAdView"
            
        }
    }
}

// MARK: - GADUnifiedNativeAdView
extension AdMobManager {
   
    private func getNativeAdLoader(unitId: AdUnitID) -> GADAdLoader? {
        return listLoader.object(forKey: unitId.rawValue) as? GADAdLoader
    }

    private func getAdNative(unitId: String) -> [GADNativeAdView] {
        if let adNativeView = listAd.object(forKey: unitId) as? [GADNativeAdView] {
            return adNativeView
        }
        return []
    }
    
    private func createAdNativeView(unitId: AdUnitID, type: NativeAdType = .small, views: [UIView]) -> Bool {
        let adNativeViews = getAdNative(unitId: unitId.rawValue)
        if !adNativeViews.isEmpty {
            adNativeViews.forEach { adNativeView in
                let view = views.first(where: {$0.tag == 0})
                view?.subviews.forEach({ viewAd in
                    viewAd.removeFromSuperview()
                })
                view?.addSubview(adNativeView)
                adNativeView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
           return false
        }
        var nativeViews: [GADNativeAdView] = []
        views.forEach { view in
            guard
                let nibObjects = Bundle.main.loadNibNamed(type.nibName, owner: nil, options: nil),
                let adNativeView = nibObjects.first as? GADNativeAdView else {
                    return
                }
            view.addSubview(adNativeView)
            adNativeView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            adNativeView.layoutIfNeeded()
            adNativeView.isSkeletonable = true
            let gradient = SkeletonGradient(baseColor: self.skeletonGradient)
            adNativeView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration: 0.7))
            nativeViews.append(adNativeView)
        }
        
        listAd.setObject(nativeViews, forKey: unitId.rawValue as NSCopying)
        return true
    }
    
    private func reloadAdNative(unitId: AdUnitID) {
        if let loader = self.getNativeAdLoader(unitId: unitId) {
            loader.load(GADRequest())
        }
    }
    
    public func addAdNative(unitId: AdUnitID, rootVC: UIViewController, views: [UIView], type: NativeAdType = .small) {
        views.forEach{$0.tag = 0}
        removeAd(unitId: unitId.rawValue)
        let isNeedLoadNew = createAdNativeView(unitId: unitId, type: type, views: views)
        if isNeedLoadNew {
            loadAdNative(unitId: unitId, rootVC: rootVC, numberOfAds: views.count)
        }
    }
    
    private func loadAdNative(unitId: AdUnitID, rootVC: UIViewController, numberOfAds: Int) {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 2
        let adLoader = GADAdLoader(adUnitID: unitId.rawValue,
            rootViewController: rootVC,
            adTypes: [ .native ],
            options: [multipleAdsOptions])
        listLoader.setObject(adLoader, forKey: unitId.rawValue as NSCopying)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
}

// MARK: - GADUnifiedNativeAdDelegate
extension AdMobManager: GADNativeAdDelegate {
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("ad==> nativeAdDidRecordClick ")
    }
}

// MARK: - GADAdLoaderDelegate
extension AdMobManager: GADAdLoaderDelegate {
    
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        self.blockNativeFaild?(adLoader.adUnitID)
        self.removeAd(unitId: adLoader.adUnitID)
    }
    
    public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("ad==> adLoaderDidFinishLoading \(adLoader)")
    }
}

// MARK: - GADUnifiedNativeAdLoaderDelegate
extension AdMobManager: GADNativeAdLoaderDelegate {
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        nativeAd.delegate = self
        nativeAd.paidEventHandler = { value in
            self.trackAdRevenue(value: value)
        }
        guard let nativeAdView = self.getAdNative(unitId: adLoader.adUnitID).first(where: {$0.tag == 0}) else {return}
        nativeAdView.tag = 2
        nativeAd.mediaContent.videoController.delegate = self
        if let nativeAdView = nativeAdView as? UnifiedNativeAdView {
            nativeAdView.hideSkeleton()
            nativeAdView.bindingData(nativeAd: nativeAd)
        } else if let nativeAdView = nativeAdView as? SmallNativeAdView {
            nativeAdView.hideSkeleton()
            nativeAdView.bindingData(nativeAd: nativeAd)
        } else if let nativeAdView = nativeAdView as? MediumNativeAdView {
            nativeAdView.hideSkeleton()
            nativeAdView.bindingData(nativeAd: nativeAd)
        } else if let nativeAdView = nativeAdView as? FreeSizeNativeAdView {
            nativeAdView.bindingData(nativeAd: nativeAd)
        }
    }
    
    public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("ad==> nativeAdDidRecordImpression")
    }
    
}

// MARK: - GADVideoControllerDelegate
extension AdMobManager: GADVideoControllerDelegate {
    
}
