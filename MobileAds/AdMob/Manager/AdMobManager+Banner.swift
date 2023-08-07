//
//  AdMobManager+Banner.swift
//  MobileAds
//
//  Created by Quang Ly Hoang on 22/02/2022.
//

import Foundation
import GoogleMobileAds
import SkeletonView
import FirebaseAnalytics

// MARK: - GADBannerView
extension AdMobManager: GADBannerViewDelegate {
    
   fileprivate func getAdBannerView(unitId: AdUnitID) -> GADBannerView? {
       if let interstitial = listAd.object(forKey: unitId.rawValue) as? GADBannerView  {
            return interstitial
        }
        return nil
    }
    
   public func createAdBannerIfNeed(unitId: AdUnitID) -> GADBannerView {
       if let adBannerView = self.getAdBannerView(unitId: unitId) {
            return adBannerView
        }
        let adBannerView = GADBannerView()
        adBannerView.adUnitID = unitId.rawValue
        adBannerView.paidEventHandler = { value in
            self.trackAdRevenue(value: value, unitId: adBannerView.adUnitID ?? "")
        }
       listAd.setObject(adBannerView, forKey: unitId.rawValue as NSCopying)
        return adBannerView
    }
    
    // quảng cáo xác định kích thước
    public func addAdBanner(unitId: AdUnitID, rootVC: UIViewController, view: UIView) {
        let adBannerView = self.createAdBannerIfNeed(unitId: unitId)
        adBannerView.rootViewController = rootVC
        view.addSubview(adBannerView)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.gray.cgColor
        adBannerView.delegate = self
        adBannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if view.isSkeletonable == false {
            adBannerView.isSkeletonable = true
            let gradient = SkeletonGradient(baseColor: self.skeletonGradient)
            adBannerView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration: 0.7))
        }
        let request = GADRequest()
        adBannerView.load(request)
    }
    
    // Quảng cáo Collapsible đặt ở bottom, lần đầu sẽ mở rộng
    public func addAdCollapsibleBannerAdaptive(unitId: AdUnitID, rootVC: UIViewController, view: UIView, isCollapsibleBanner: Bool = false) {
        let adBannerView = self.createAdBannerIfNeed(unitId: unitId)
        adBannerView.rootViewController = rootVC
        view.addSubview(adBannerView)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.gray.cgColor
        adBannerView.delegate = self
        
        adBannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if view.isSkeletonable == false {
            adBannerView.isSkeletonable = true
            let gradient = SkeletonGradient(baseColor: self.skeletonGradient)
            adBannerView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration: 0.7))
        }
        
        adBannerView.adSize =  GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(screenWidthAds)
        let request = GADRequest()
        let gadExtras = GADExtras()
        gadExtras.additionalParameters = ["collapsible": "bottom"]
        request.register(gadExtras)
        adBannerView.load(request)
    }
    
    
    // quảng có thích ứng với chiều cao không cố định
    public func addAdBannerAdaptive(unitId: AdUnitID, rootVC: UIViewController, view: UIView) {
        let adBannerView = self.createAdBannerIfNeed(unitId: unitId)
        adBannerView.rootViewController = rootVC
        view.addSubview(adBannerView)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.gray.cgColor
        adBannerView.delegate = self
        
        adBannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if view.isSkeletonable == false {
            adBannerView.isSkeletonable = true
            let gradient = SkeletonGradient(baseColor: self.skeletonGradient)
            adBannerView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration: 0.7))
        }
        
        adBannerView.adSize =  GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(screenWidthAds)
        let request = GADRequest()
        adBannerView.load(request)
    }
    
    // MARK: - GADBanner delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("ad==> bannerView did load \(bannerView.adUnitID ?? "")")
        bannerView.hideSkeleton()
        bannerView.superview?.hideSkeleton()
    }
    
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("ad==> bannerView faild \(error.localizedDescription)")
        bannerView.delegate = nil
        if let unitId = bannerView.adUnitID {
            self.removeAd(unitId: unitId)
            self.blockBannerFaild?(unitId)
        }
    }
    
    
    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        if let adUnitID = bannerView.adUnitID {
            self.removeAd(unitId: adUnitID)
        }
    }
    
    public func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("ad==> adViewDidRecordImpression bannerView\(bannerView.adUnitID ?? "")")
        bannerView.delegate = nil
        bannerView.hideSkeleton()
        bannerView.superview?.hideSkeleton()
        blockLoadBannerSuccess?(true)
    }
    
    public func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        blockBannerClick?(bannerView.adUnitID ?? "")
        AdMobManager.shared.logEvenClick(id: bannerView.adUnitID ?? "")
    }
    
}
