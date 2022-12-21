//
//  Unifiedself.swift
//  EasyVPN
//
//  Created by ANH VU on 03/12/2021.
//


import UIKit
import GoogleMobileAds
import SkeletonView

protocol NativeAdProtocol {
    func bindingData(nativeAd: GADNativeAd)
}

class UnifiedNativeAdView_2: GADNativeAdView, NativeAdProtocol {
    
    @IBOutlet weak var lblAds: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var lblRateCount: UILabel!
    
    let (viewBackgroundColor, titleColor, vertiserColor, contenColor, actionColor, backgroundAction) = AdMobManager.shared.adsNativeColor.colors
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = viewBackgroundColor
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
                
        self.callToActionView?.layer.cornerRadius = AdMobManager.shared.nativeButtonCornerRadius
        self.callToActionView?.layer.backgroundColor = backgroundAction.cgColor
        (self.callToActionView as? UIButton)?.setTitleColor(actionColor, for: .normal)
        self.callToActionView?.layer.cornerRadius = AdMobManager.shared.adsNativeCornerRadiusButton
        (self.bodyView as? UILabel)?.textColor = contenColor
        (advertiserView as? UILabel)?.textColor = vertiserColor
        lblRateCount.textColor = contenColor
        (priceView as? UILabel)?.textColor = contenColor
        (self.storeView as? UILabel)?.textColor = contenColor
        (self.headlineView as? UILabel)?.textColor = titleColor
        lblAds.textColor = AdMobManager.shared.adNativeAdsLabelColor
        lblAds.backgroundColor = AdMobManager.shared.adNativeBackgroundAdsLabelColor
        self.backgroundColor = viewBackgroundColor
        layer.borderWidth = AdMobManager.shared.adsNativeBorderWidth
        layer.borderColor = AdMobManager.shared.adsNativeBorderColor.cgColor
        layer.cornerRadius = AdMobManager.shared.adsNativeCornerRadius
        clipsToBounds = true

        self.nativeAd = nativeAd
    }

}
