//
//  Unifiedself.swift
//  EasyVPN
//
//  Created by ANH VU on 03/12/2021.
//


import UIKit
import GoogleMobileAds
import SkeletonView

class CellMediaNativeAdView: GADNativeAdView {
    @IBOutlet weak var lblAds: UILabel!
    @IBOutlet weak var lblRateCount: UILabel!
    var adConerRadius: CGFloat = 30
    
    @IBOutlet weak var adBgView: UIView!
    let (viewBackgroundColor, titleColor, vertiserColor, contenColor, actionColor, backgroundAction) = AdMobManager.shared.adsNativeColor.colors
    var adUnitID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(hex: 0xEEECFF)
        self.layer.cornerRadius = adConerRadius
     
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lblAds.layer.cornerRadius = 2
        mediaView?.roundCorners(corners: [.topLeft, .topRight], radius: adConerRadius-6)
    }
    
    func bindingData(nativeAd: GADNativeAd) {
        self.hideSkeleton()
        (self.headlineView as? UILabel)?.text = nativeAd.headline
        self.mediaView?.mediaContent = nativeAd.mediaContent

        let mediaContent = nativeAd.mediaContent
        if mediaContent.hasVideoContent {
            //videoStatusLabel.text = "Ad contains a video asset."
        } else {
            //videoStatusLabel.text = "Ad does not contain a video."
        }
        
        (self.bodyView as? UILabel)?.text = nativeAd.body
        self.bodyView?.isHidden = nativeAd.body == nil
//        bannerImageView.image = nativeAd.images?.first?.image
        (self.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        self.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        
        (self.iconView as? UIImageView)?.image = nativeAd.icon?.image
        self.iconView?.isHidden = nativeAd.icon == nil
        self.iconView?.layer.cornerRadius = 4

        (self.starRatingView as? UIImageView)?.image = self.imageOfStars(from: nativeAd.starRating)
        self.starRatingView?.isHidden = nativeAd.starRating == nil || nativeAd.starRating == 0
        self.lblRateCount.isHidden = nativeAd.starRating == nil || nativeAd.starRating == 0
        self.lblRateCount.text = "\(nativeAd.starRating ?? 0)"
        (self.storeView as? UILabel)?.text = nativeAd.store
        self.storeView?.isHidden = nativeAd.store == nil

        (self.priceView as? UILabel)?.text = nativeAd.price
        self.priceView?.isHidden = nativeAd.price == nil

        (self.advertiserView as? UILabel)?.text = nativeAd.advertiser
        self.advertiserView?.isHidden = nativeAd.advertiser == nil
//        if backgroundAction.count > 1 {
//            self.callToActionView?.gradient(startColor: .white.withAlphaComponent(0.35), endColor: backgroundAction.last!, cornerRadius: 0)
//        } else {
        self.callToActionView?.layer.backgroundColor = UIColor.white.withAlphaComponent(0.35).cgColor
            //self.callToActionView?.layer.cornerRadius = AdMobManager.shared.adsNativeCornerRadiusButton
       // }
        (self.callToActionView as? UIButton)?.setTitleColor(UIColor.black, for: .normal)
        (self.bodyView as? UILabel)?.textColor = contenColor
        (advertiserView as? UILabel)?.textColor = vertiserColor
        lblRateCount.textColor = contenColor
        (priceView as? UILabel)?.textColor = contenColor
        (self.storeView as? UILabel)?.textColor = contenColor
        (self.headlineView as? UILabel)?.textColor = UIColor.black
        lblAds.textColor = AdMobManager.shared.adNativeAdsLabelColor
        adBgView.backgroundColor = UIColor.init(hex: 0x645D5D)
        self.backgroundColor = UIColor.init(hex: 0xEEECFF)
        layer.borderWidth = AdMobManager.shared.adsNativeBorderWidth
        layer.borderColor = AdMobManager.shared.adsNativeBorderColor.cgColor
        layer.cornerRadius = AdMobManager.shared.adsNativeCornerRadius
        clipsToBounds = true

        self.nativeAd = nativeAd
    }
}

extension CellMediaNativeAdView: NativeAdProtocol {
    func getGADView() -> GADNativeAdView {
        return self
    }
}
