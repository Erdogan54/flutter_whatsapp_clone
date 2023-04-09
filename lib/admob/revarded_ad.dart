import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedExampleState {
  RewardedAd? _rewardedAd;

  // TODO: replace this test ad unit with your own ad unit.
  final _adUnitId = '/6499/example/rewarded';

  /// Loads a rewarded ad.
  Future<void> loadAd() async {
    print("-------loadAd");
    return RewardedAd.loadWithAdManagerAdRequest(
      adUnitId: _adUnitId,
      adManagerRequest: const AdManagerAdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
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

          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
          _showAd();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  int showAdTryCount = 0;
  showAdTry() async {
    print("-------showAdTry");
    if (showAdTryCount >= 1) return;

    if (_rewardedAd != null) {
      print("_rewardedAd != null");
      if ((_rewardedAd?.rewardedAdLoadCallback.onAdLoaded ?? false) == true) {
        print("((_rewardedAd?.rewardedAdLoadCallback ?? false) == true)");
        _showAd();
      } else {
        print("((_rewardedAd?.rewardedAdLoadCallback ?? true) == false)");
        showAdTryCount++;
        await loadAd();
        showAdTry();
      }
    } else {
      showAdTryCount++;
      print("_rewardedAd == null");
      await loadAd();
      showAdTry();
    }
  }

  _showAd() {
    showAdTryCount = 0;
    print("-------_showAd");

    _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      print("-------rewardItem.amount ${rewardItem.amount}");
      print("-------rewardItem.type ${rewardItem.type}");
      print("------ad.onPaidEvent  ${ad.onPaidEvent}");
      print("------ad.adUnitId  ${ad.adUnitId}");
      print("------ad.responseInfo  ${ad.responseInfo}");

      // Reward the user for watching an ad.
    });
  }
}
