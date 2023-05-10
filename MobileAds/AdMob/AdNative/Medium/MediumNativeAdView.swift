//
//  MediumNativeAdView.swift
//  MobileAds
//
//  Created by Quang Ly Hoang on 25/02/2022.
//

import UIKit
import GoogleMobileAds

class MediumNativeAdView: GADNativeAdView, NativeAdProtocol {
    
    @IBOutlet weak var lblAds: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var starNumberLabel: UILabel!
    
    let (viewBackgroundColor, titleColor, vertiserColor, contenColor, actionColor, backgroundAction) = AdMobManager.shared.adsNativeColor.colors
    var adUnitID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = viewBackgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lblAds.roundCorners(corners: [.topLeft, .bottomRight], radius: 6)
    }
    
    func bindingData(nativeAd: GADNativeAd) {
        hideSkeleton()
        stopSkeletonAnimation()
        (headlineView as? UILabel)?.text = nativeAd.headline
        (callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (iconView as? UIImageView)?.image = nativeAd.icon?.image
        iconView?.isHidden = nativeAd.icon == nil
        
        mediaView?.isHidden = true
        
        if let star = nativeAd.starRating, let image = imageOfStars(from: star) {
            (starRatingView as? UIImageView)?.image = image
            starNumberLabel.text = "\(star)"
        } else {
            ratingStackView?.isHidden = true
        }
        
        (bodyView as? UILabel)?.text = nativeAd.body
        bodyView?.isHidden = nativeAd.body == nil
        
        (priceView as? UILabel)?.text = nativeAd.price
        priceView?.isHidden = nativeAd.price == nil
        
        (advertiserView as? UILabel)?.text = nativeAd.advertiser
        advertiserView?.isHidden = nativeAd.advertiser == nil
                
        (self.callToActionView as? UIButton)?.setTitleColor(actionColor, for: .normal)
        if backgroundAction.count > 1 {
            self.callToActionView?.gradient(startColor: UIColor(hex: 0xE2465C), endColor: UIColor(hex: 0xFAC06F))
        } else {
            self.callToActionView?.layer.backgroundColor = backgroundAction.first?.cgColor
        }
        self.callToActionView?.layer.cornerRadius = AdMobManager.shared.adsNativeCornerRadiusButton
        (self.bodyView as? UILabel)?.textColor = contenColor
        (self.advertiserView as? UILabel)?.textColor = vertiserColor
        starNumberLabel.textColor = contenColor
        (self.headlineView as? UILabel)?.textColor = titleColor
        (priceView as? UILabel)?.textColor = contenColor
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
