import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialExampleState {
  InterstitialExampleState._();
  static AdManagerInterstitialAd? _interstitialAd;

  // TODO: replace this test ad unit with your own ad unit.
  static String adUnitId = '/6499/example/interstitial';

  /// Loads an interstitial ad.
  static Future<void> loadAd() async {
    print("------loadAd");
    return AdManagerInterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdManagerAdRequest(),
        adLoadCallback: AdManagerInterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint("--------onAdLoaded");

            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Reklamlar tam ekran içeriği gösterip kapattığında çağrılacak geri aramalar.

              onAdShowedFullScreenContent: (ad) {
                // Bir reklam tam ekran içerik gösterdiğinde çağrılır.
                // Called when the ad showed the full screen content.
                debugPrint("----------onAdShowedFullScreenContent");
                // debugPrint("-----------ad.responseInfo ${ad.responseInfo}");
              },
              onAdImpression: (ad) {
                // Reklamda bir gösterim oluştuğunda çağrılır.
                // Called when an impression occurs on the ad.
                debugPrint("------onAdImpression");
              },
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Reklam tam ekran içeriği gösteremediğinde çağrılır.
                // Called when the ad failed to show full screen content.
                // Dispose the ad here to free resources.
                debugPrint("----------onAdFailedToShowFullScreenContent");
                ad.dispose();
              },
              onAdDismissedFullScreenContent: (ad) {
                // Bir reklam tam ekran içeriği kapattığında çağrılır.
                // Called when the ad dismissed full screen content.
                // Dispose the ad here to free resources.
                debugPrint("--------onAdDismissedFullScreenContent");
                ad.dispose();
              },
              onAdClicked: (ad) {
                // Bir reklam için tıklama kaydedildiğinde çağrılır.
                // Called when a click is recorded for an ad.
                debugPrint("---------onAdClicked");
              },
            );

            debugPrint('-----$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('-----AdManagerInterstitialAd failed to load: $error');
          },
        ));
  }

  static showAdTry() async {
    print("----- showAdTry");
    if ((_interstitialAd?.adLoadCallback ?? false) == true) {
      print("(--------_interstitialAd?.adLoadCallback ?? false) == true");
      _showAd();
    } else {
      print("(--------_interstitialAd?.adLoadCallback ?? true) == false");

      await loadAd();
      _showAd();
    }
  }

  static Future<void> _showAd() async {
    print("-----  _showAd");
    return _interstitialAd?.show();
  }
}
