import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedInterstitialExample {
  RewardedInterstitialAd? _rewardedInterstitialAd;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = '/21775744923/example/rewarded_interstitial';

  /// Loads a rewarded ad.
  Future<void> loadAd() async {
    print("-----loadAd");

    return RewardedInterstitialAd.loadWithAdManagerAdRequest(
        adUnitId: adUnitId,
        adManagerRequest: const AdManagerAdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('--------$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedInterstitialAd = ad;
            _showAd();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError loadAdError) {
            // Gets the domain from which the error came.

            debugPrint('RewardedInterstitialAd failed to load: $loadAdError');
          },
        ));
  }

  int showAdTrycount = 0;
  showAdTry() async {
    if (showAdTrycount >= 3) return;
    print("----showAdTry");
    if (_rewardedInterstitialAd != null) {
      print("----_rewardedInterstitialAd != null");

      if ((_rewardedInterstitialAd?.rewardedInterstitialAdLoadCallback.onAdLoaded ?? false) == true) {
        print("----(_rewardedInterstitialAd?.rewardedInterstitialAdLoadCallback.onAdLoaded ?? false) == true");
        _showAd();
        return;
      } else {
        print("----(_rewardedInterstitialAd?.rewardedInterstitialAdLoadCallback.onAdLoaded ?? true) == false");
      }
      if ((_rewardedInterstitialAd?.rewardedInterstitialAdLoadCallback.onAdFailedToLoad ?? false) == true) {
        print("----(_rewardedInterstitialAd?.rewardedInterstitialAdLoadCallback.onAdFailedToLoad ?? false) == true");
        await loadAd();
        print("----await loadAd() bitti");
        showAdTry();
      } else {
        print("----(_rewardedInterstitialAd?.rewardedInterstitialAdLoadCallback.onAdFailedToLoad ?? true) == false");
      }
    }
    showAdTrycount++;
    print(
        "----_rewardedInterstitialAd == null  or (_rewardedInterstitialAd?.rewardedInterstitialAdLoadCallback ?? true) == false");
    await loadAd();
    print("----await loadAd() bitti");
    showAdTry();
  }

  _showAd() {
    print("-----_showAd");
    _rewardedInterstitialAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      // Reward the user for watching an ad.
    });
  }
}
