//
//  InsideButtonNativeAdView.swift
//  MobileAds
//
//  Created by macbook on 30/08/2021.
//

import UIKit
import GoogleMobileAds
import SkeletonView

public class InsideButtonNativeAdView: GADNativeAdView, NativeAdProtocol {

    @IBOutlet weak var lblAds: UILabel!
    
    let (viewBackgroundColor, titleColor, _, contenColor, actionColor, backgroundAction, nativeButtonStartColor, nativeButtonEndColor) = AdMobManager.shared.adsNativeColor.colors
    var adUnitID: String?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = viewBackgroundColor
        lblAds.roundCorners(corners: [.topLeft, .bottomRight], radius: 8)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        lblAds.roundCorners(corners: [.topLeft, .bottomRight], radius: 8)
    }
    
    func bindingData(nativeAd: GADNativeAd) {
        self.hideSkeleton()
        (self.headlineView as? UILabel)?.text = nativeAd.headline
        
        (self.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        self.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (self.iconView as? UIImageView)?.image = nativeAd.icon?.image
        self.iconView?.isHidden = nativeAd.icon == nil
        self.iconView?.layer.cornerRadius = 12
        self.iconView?.clipsToBounds = true
        (self.starRatingView as? UIImageView)?.image = self.imageOfStars(from: nativeAd.starRating)
        self.starRatingView?.isHidden = nativeAd.starRating == nil
        
        if nativeAd.body == nil {
            (self.bodyView as? UILabel)?.text = nativeAd.advertiser
        } else {
            (self.bodyView as? UILabel)?.text = nativeAd.body
        }
        
        (self.callToActionView as? UIButton)?.backgroundColor = backgroundAction
        (self.callToActionView as? UIButton)?.setTitleColor(actionColor, for: .normal)
        self.callToActionView?.layer.cornerRadius = 0
        (self.bodyView as? UILabel)?.textColor = contenColor
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
