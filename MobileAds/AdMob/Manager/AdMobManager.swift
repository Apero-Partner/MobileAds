//
//  AdMobManager.swift
//  MobileAds
//
//  Created by macbook on 28/08/2021.
//

import Foundation
import UIKit
import GoogleMobileAds
import SkeletonView
import Adjust
import FirebaseAnalytics

//    MARK: - Google-provided demo ad units
public struct SampleAdUnitID {
    public static let adFormatAppOpen              = "ca-app-pub-3940256099942544/3419835294"
    public static let adFormatBanner               = "ca-app-pub-3940256099942544/6300978111"
    public static let adFormatBanner_2             = "ca-app-pub-3940256099942544/2934735716"
    public static let adFormatInterstitial         = "ca-app-pub-3940256099942544/1033173712"
    public static let adFormatInterstitialVideo    = "ca-app-pub-3940256099942544/8691691433"
    public static let adFormatRewarded             = "ca-app-pub-3940256099942544/5224354917"
    public static let adFormatRewardedInterstitial = "ca-app-pub-3940256099942544/5354046379"
    public static let adFormatNativeAdvanced       = "ca-app-pub-3940256099942544/2247696110"
    public static let adFormatNativeAdvancedVideo  = "ca-app-pub-3940256099942544/1044960115"
}

//    MARK: - Enum AdUnitID
public struct AdUnitID {
    public var rawValue: String = ""
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

//    MARK: - Enum Theme Style Ads
public enum ThemeStyleAds {
    case origin
    case custom(backgroundColor: UIColor, titleColor: UIColor, vertiserColor: UIColor, contenColor: UIColor, actionColor: UIColor, backgroundAction: [UIColor])
    case setBackground(backgroundColor: UIColor)
    
    var colors: (backgroundColor: UIColor, titleColor: UIColor, vertiserColor: UIColor, contenColor: UIColor, actionColor: UIColor, backgroundAction: [UIColor]) {
        switch self {
        case .origin:
            return (UIColor(hex: 0xFFFFFF), UIColor(hex: 0x0303B3), UIColor(hex: 0x001868), UIColor(hex: 0x666666), UIColor(hex: 0xFFFFFF), [UIColor(hex: 0x007AFF)])
        case .custom(let backgroundColor, let titleColor, let vertiserColor, let contenColor, let actionColor, let backgroundAction):
            return (backgroundColor, titleColor, vertiserColor, contenColor, actionColor, backgroundAction)
        case .setBackground(let backgroundColor):
            return (backgroundColor, UIColor(hex: 0x0303B3), UIColor(hex: 0x001868), UIColor(hex: 0x666666), UIColor(hex: 0xFFFFFF), [UIColor(hex: 0x007AFF)])
        }
    }
}

open class AdMobManager: NSObject {
    
    //    MARK: - Property
    public static let shared = AdMobManager()
    public var timeOut: Int = 30
    public var didEarnReward = false
    public var showAdRewardCount = 0
    public var listAd: NSMutableDictionary = NSMutableDictionary()
    public var listLoader: NSMutableDictionary = NSMutableDictionary()
    
    //    MARK: - Type Theme color
    public var adsNativeColor: ThemeStyleAds = .origin
    
    //    MARK: - UI Native
    public var adsNativeCornerRadiusButton:      CGFloat = 8
    public var adsNativeCornerRadius:            CGFloat = 4
    public var adsNativeBorderWidth:             CGFloat = 1
    public var adsNativeSmallWidthButton:        CGFloat = 80
    public var adsNativeMediumHeightButton:      CGFloat = 48
   
    public var adsNativeBorderColor:             UIColor = .clear
    public var adNativeAdsLabelColor:            UIColor = .white
    public var adNativeBackgroundAdsLabelColor: UIColor = UIColor(hex: 0xFDB812)
    
    public var nativeButtonCornerRadius: CGFloat = 16
    public var rewardErrorString: String         = "An error occurred"
    public var adFullScreenLoadingString: String = "Ad is loading"
    public var skeletonGradient = UIColor.clouds
    
    var isSplash = false
    var loadingRewardIds: [String] = []
    
    //    MARK: - Block Ads
    public var blockLoadFullScreenAdSuccess: StringBlockAds?
    public var blockFullScreenAdWillDismiss: VoidBlockAds?
    public var blockFullScreenAdDidDismiss : VoidBlockAds?
    public var blockFullScreenAdWillPresent: StringBlockAds?
    public var blockFullScreenAdDidPresent : StringBlockAds?
    public var blockFullScreenAdFaild      : StringBlockAds?
    public var blockFullScreenAdClick      : VoidBlockAds?
    public var blockCompletionHandeler     : BoolBlockAds?
    public var blockNativeFaild            : StringBlockAds?
    public var blockLoadNativeSuccess      : BoolBlockAds?
    public var blockBannerFaild      : ((String) -> Void)?
    public var blockLoadBannerSuccess: ((Bool) -> Void)?
    public var blockBannerClick      : StringBlockAds?
    
    //    MARK: - Remove ID ads
    public func removeAd(unitId: String) {
        listAd.removeObject(forKey: unitId)
    }
    
    //    MARK: - Track Ad Revenue
    func trackAdRevenue(value: GADAdValue, unitId: String) {
        Analytics.logEvent("ad_impression_value", parameters: ["adunitid" : unitId, "value" : "\(value.value.doubleValue)"])
        if let adRevenue = ADJAdRevenue(source: ADJAdRevenueSourceAdMob) {
            adRevenue.setRevenue(value.value.doubleValue, currency: value.currencyCode)
            Adjust.trackAdRevenue(adRevenue)
        }
    }
    
    func logEvenClick(id: String) {
        Analytics.logEvent("user_click_ads", parameters: ["adunitid" : id])
    }
    
}
