## Summary

This is the Cordova SDK of Adjust™. You can read more about Adjust™ at [adjust.com](https://adjust.com).

N.B. At the moment, Cordova SDK supports Android platform version `4.0.0 and higher` and iOS platform version `3.0.0 and higher`.

## Table of contents

* [Example app](#example-app)
* [Basic integration](#basic-integration)
   * [Get the SDK](#sdk-get)
   * [Add the SDK to your project](#sdk-add)
   * [Integrate the SDK into your app](#sdk-integrate)
   * [Adjust logging](#adjust-logging)
   * [Adjust project settings](#adjust-project-settings)
      * [Android permissions](#android-permissions)
      * [Google Play Services](#android-gps)
      * [Proguard settings](#android-proguard)
      * [Install referrer](#android-referrer)
         * [Google Play Referrer API](#android-referrer-gpr-api)
         * [Google Play Store intent](#android-referrer-gps-intent)
         * [Huawei Referrer API](#android-huawei-referrer-api)
      * [iOS frameworks](#ios-frameworks)
* [Additional features](#additional-features)
   * [AppTrackingTransparency framework](#att-framework)
      * [App-tracking authorisation wrapper](#ata-wrapper)
      * [Get current authorisation status](#ata-getter)
      * [Check for ATT status change](#att-status-change)
   * [SKAdNetwork framework](#skadn-framework)
      * [Update SKAdNetwork conversion value](#skadn-update-conversion-value)
      * [Conversion value updated callback](#skadn-cv-updated-callback)
   * [Event tracking](#event-tracking)
      * [Revenue tracking](#revenue-tracking)
      * [Revenue deduplication](#revenue-deduplication)
      * [Callback parameters](#callback-parameters)
      * [Partner parameters](#partner-parameters)
      * [Callback identifier](#callback-id)
   * [Subscription tracking](#subscription-tracking) 
   * [Session parameters](#session-parameters)
      * [Session callback parameters](#session-callback-parameters)
      * [Session partner parameters](#session-partner-parameters)
      * [Delay start](#delay-start)
   * [Attribution callback](#attribution-callback)
   * [Session and event callbacks](#session-event-callbacks)
   * [Disable tracking](#disable-tracking)
   * [Offline mode](#offline-mode)
   * [Event buffering](#event-buffering)
   * [GDPR right to be forgotten](#gdpr-forget-me)
   * [Third-party sharing](#third-party-sharing)
      * [Disable third-party sharing](#disable-third-party-sharing)
      * [Enable third-party sharing](#enable-third-party-sharing)
   * [Measurement consent](#measurement-consent)
   * [SDK signature](#sdk-signature)
   * [Background tracking](#background-tracking)
   * [Device IDs](#device-ids)
      * [iOS advertising identifier](#di-idfa)
      * [Google Play Services advertising identifier](#di-gps-adid)
      * [Amazon advertising identifier](#di-fire-adid)
      * [Adjust device identifier](#di-adid)
   * [Set external device ID](#set-external-device-id)
   * [User attribution](#user-attribution)
   * [Push token](#push-token)
   * [Pre-installed trackers](#pre-installed-trackers)
   * [Deep linking](#deeplinking)
      * [Standard deep linking scenario](#deeplinking-standard)
      * [Deep linking on Android & iOS 8 and earlier](#deeplinking-android-ios-old)
      * [Deep linking on iOS 9 and later](#deeplinking-ios-new)
      * [Deferred deep linking scenario](#deeplinking-deferred)
      * [Reattribution via deep links](#deeplinking-reattribution)
   * [Data residency](#data-residency)
   * [OAID plugin](#oaid-plugin)
   * [COPPA compliance](#coppa-compliance)
   * [Play Store Kids Apps](#play-store-kids-apps)
* [License](#license)


## <a id="example-app"></a>Example app

There is Cordova example app inside the [`example-cordova` directory](./example-cordova) and Ionic example app inside the [`example-ionic-capacitor` directory](./example-ionic-capacitor). In there you can check how to integrate the Adjust SDK into your app.

## <a id="basic-integration"></a>Basic integration

These are the minimal steps required to integrate the Adjust SDK into your Cordova project.

### <a id="sdk-get"></a>Get the SDK

You can get the latest version of the Adjust SDK from the `npm` [repository](https://www.npmjs.com/package/com.adjust.sdk) or download the it from our [releases page](https://github.com/adjust/cordova_sdk/releases).

### <a id="sdk-add"></a>Add the SDK to your project

You can download our SDK directly as the plugin from `npm` repository. In order to do that, just execute this command in your project folder:

```
> cordova plugin add com.adjust.sdk
Fetching plugin "com.adjust.sdk" via npm
Installing "com.adjust.sdk" for android
Installing "com.adjust.sdk" for ios
```

In case you are using Ionic to build your app, you can add our SDK from [`awesome-cordova-plugins`](https://github.com/danielsogl/awesome-cordova-plugins) repo:

```
> npm install @awesome-cordova-plugins/adjust --save
> ionic cordova plugin add com.adjust.sdk
```

### <a id="sdk-integrate"></a>Integrate the SDK into your app

The Adjust SDK automatically registers with the Cordova events `deviceready`, `resume` and `pause`.

In your `index.js` file after you have received the `deviceready` event, add the following code to initialize the Adjust SDK:

```js
var adjustConfig = new AdjustConfig("{YourAppToken}", AdjustConfig.EnvironmentSandbox);
Adjust.create(adjustConfig);
```

Replace `{YourAppToken}` with your app token. You can find this in your [dashboard](http://dash.adjust.com).

Depending on whether you build your app for testing or for production, you must set `environment` with one of these values:

```javascript
AdjustConfig.EnvironmentSandbox
AdjustConfig.EnvironmentProduction
```

**Important:** This value should be set to `AdjustConfig.EnvironmentSandbox` if and only if you or someone else is testing your app. Make sure to set the environment to `AdjustConfig.EnvironmentProduction` just before you publish the app. Set it back to `AdjustConfig.EnvironmentSandbox` when you start developing and testing it again.

We use this environment to distinguish between real traffic and test traffic from test devices. It is very important that you keep this value meaningful at all times! This is especially important if you are tracking revenue.

### <a id="sdk-logging"></a>Adjust logging

You can increase or decrease the amount of logs you see in tests by calling `setLogLevel` on your `AdjustConfig` instance with one of the following parameters:

```js
adjustConfig.setLogLevel(AdjustConfig.LogLevelVerbose);   // enable all logging
adjustConfig.setLogLevel(AdjustConfig.LogLevelDebug);     // enable more logging
adjustConfig.setLogLevel(AdjustConfig.LogLevelInfo);      // the default
adjustConfig.setLogLevel(AdjustConfig.LogLevelWarn);      // disable info logging
adjustConfig.setLogLevel(AdjustConfig.LogLevelError);     // disable warnings as well
adjustConfig.setLogLevel(AdjustConfig.LogLevelAssert);    // disable errors as well
adjustConfig.setLogLevel(AdjustConfig.LogLevelSuppress);  // disable all logging
```

### <a id="adjust-project-settings"></a>Adjust project settings

Once the Adjust SDK has been added to your app, certain tweeks are being performed so that the Adjust SDK can work properly. Everything that is being done in this process is written in the `plugin.xml` file of the Adjust SDK plugin. Below you can find a description of every additional thing that the Adjust SDK performs after you've added it to your app.

### <a id="android-permissions"></a>Android permissions

The Adjust SDK adds three permissions to your Android manifest file: `INTERNET` and `ACCESS_NETWORK_STATE`. You can find this setting in the `plugin.xml` file of the Adjust SDK plugin:

```xml
<config-file target="AndroidManifest.xml" parent="/manifest">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
</config-file>
```

- `INTERNET` permission is the permission that our SDK might need at any point in time.
- `ACCESS_NETWORK_STATE` is needed for reading MMC and MNC parameters.

#### <a id="gps-adid-permission"></a>Add permission to gather Google advertising ID

If you are targeting Android 12 and above (API level 31), you need to add the `com.google.android.gms.AD_ID` permission to read the device's advertising ID. Add the following line to your `plugin.xml` to enable the permission:

```xml
<config-file target="AndroidManifest.xml" parent="/manifest">
  <uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
</config>
```

> **Important**: The Adjust SDK includes the `com.google.android.gms.AD_ID` permission by default in version 4.32.0 and above.

You can remove the `com.google.android.gms.AD_ID` permission by adding a `remove` directive. Do this if need to make your app COPPA-compliant or if you do not target the Google Play Store.

```xml
<uses-permission android:name="com.google.android.gms.permission.AD_ID" tools:node="remove"/>
```

For more information, see [Google's `AdvertisingIdClient.Info` documentation](https://developers.google.com/android/reference/com/google/android/gms/ads/identifier/AdvertisingIdClient.Info#public-string-getid).

### <a id="android-gps"></a>Google Play Services

Since the August 1, 2014, apps in the Google Play Store must use the [Google Advertising ID](https://developer.android.com/google/play-services/id.html) to uniquely identify each device. To allow the Adjust SDK to use the Google Advertising ID, you must add the Google Play Services dependency which allows reading of this parameter.

The Adjust SDK adds this dependency by default to your app. This is done with this line in the `plugin.xml` file:

```xml
<framework src="com.google.android.gms:play-services-ads-identifier:18.0.1" />
```

To check whether the analytics part of the Google Play Services library has been successfully added to your app so that the Adjust SDK can read it properly, you should start your app by configuring the SDK to run in `sandbox` mode and set the log level to `verbose`. After that, track a session or some events in your app and observe the list of parameters in the verbose logs which are being read once the session or event has been tracked. If you see a parameter called `gps_adid` in there, you have successfully added the analytics part of the Google Play Services library to your app and our SDK is reading the necessary information from it.

### <a id="android-proguard"></a>Proguard settings

If you are using Proguard, add these lines to your Proguard file:

```
-keep class com.adjust.sdk.** { *; }
-keep class com.google.android.gms.common.ConnectionResult {
    int SUCCESS;
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient {
    com.google.android.gms.ads.identifier.AdvertisingIdClient$Info getAdvertisingIdInfo(android.content.Context);
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info {
    java.lang.String getId();
    boolean isLimitAdTrackingEnabled();
}
-keep public class com.android.installreferrer.** { *; }
```

If you are **not publishing your app in the Google Play Store**, use the following `com.adjust.sdk` package rules:

```
-keep public class com.adjust.sdk.** { *; }
```

### <a id="android-referrer"></a>Install referrer

In order to correctly attribute an install of your Android app to its source, Adjust needs information about the **install referrer**. This can be obtained by using the **Google Play Referrer API** or by catching the **Google Play Store intent** with a broadcast receiver.

**Important**: The Google Play Referrer API is newly introduced by Google with the express purpose of providing a more reliable and secure way of obtaining install referrer information and to aid attribution providers in the fight against click injection. It is **strongly advised** that you support this in your application. The Google Play Store intent is a less secure way of obtaining install referrer information. It will continue to exist in parallel with the new Google Play Referrer API temporarily, but it is set to be deprecated in future.

#### <a id="android-referrer-gpr-api"></a>Google Play Referrer API

In order to support this in your app, the Adjust SDK adds support for it by default to your app. This is done with this line in the `plugin.xml` file:

```xml
<framework src="com.android.installreferrer:installreferrer:2.2" />
```

`installreferrer` library is part of Google Maven repository, so in order to be able to build your app, you need to add Google Maven repository to your app's `build.gradle` file if you haven't added it already:

```gradle
allprojects {
    repositories {
        jcenter()
        maven {
            url "https://maven.google.com"
        }
    }
}
```

Also, make sure that you have paid attention to the [Proguard settings](#android-proguard) chapter and that you have added all the rules mentioned in it, especially the one needed for this feature:

```
-keep public class com.android.installreferrer.** { *; }
```

This feature is supported if you are using the **Adjust SDK v4.12.0 or above**.

#### <a id="android-referrer-gps-intent"></a>Google Play Store intent

The Google Play Store `INSTALL_REFERRER` intent should be captured with a broadcast receiver. The Adjust install referrer broadcast receiver is added to your app by default. For more information, you can check our native [Android SDK README](https://github.com/adjust/android_sdk#gps-intent). You can find this setting in the `plugin.xml` file of the the Adjust SDK plugin:

```xml
<config-file target="AndroidManifest.xml" parent="/manifest/application">
    <receiver
        android:name="com.adjust.sdk.AdjustReferrerReceiver"
        android:exported="true">
        <intent-filter>
            <action android:name="com.android.vending.INSTALL_REFERRER" />
        </intent-filter>
    </receiver>
</config-file>
```

Please bear in mind that, if you are using your own broadcast receiver which handles the INSTALL_REFERRER intent, you don't need the Adjust broadcast receiver to be added to your manifest file. You can remove it, but inside your own receiver add the call to the Adjust broadcast receiver as described in our [Android guide](https://github.com/adjust/android_sdk/blob/master/doc/english/referrer.md).

#### <a id="android-huawei-referrer-api"></a>Huawei Referrer API

As of **v4.21.1**, the Adjust SDK supports install tracking on Huawei devices with Huawei App Gallery version 10.4 and higher. No additional integration steps are needed to start using the Huawei Referrer API.

### <a id="ios-frameworks"></a>iOS frameworks

Adjust SDK plugin adds these iOS frameworks to your generated Xcode project:

- `AdSupport.framework` - This framework is needed so that SDK can access to IDFA value and (prior to iOS 14) LAT information.
- `iAd.framework` - This framework is needed so that SDK can automatically handle attribution for ASA campaigns you might be running.
- `AdServices.framework` - For devices running iOS 14.3 or higher, this framework allows the SDK to automatically handle attribution for ASA campaigns. It is required when leveraging the Apple Ads Attribution API.
- `StoreKit.framework` - This framework is needed for access to `SKAdNetwork` framework and for Adjust SDK to handle communication with it automatically in iOS 14 or later.
- `AppTrackingTransparency.framework` - This framework is needed in iOS 14 and later for SDK to be able to wrap user's tracking consent dialog and access to value of the user's consent to be tracked or not.

Settings for this can also be found in `plugin.xml` file of the Adjust SDK plugin:

```xml
<framework src="AdSupport.framework" weak="true" />
<framework src="iAd.framework" weak="true" />
<framework src="StoreKit.framework" weak="true" />
<framework src="AdServices.framework" weak="true" />
<framework src="AppTrackingTransparency.framework" weak="true" />
```

## <a id="additional-features"></a>Additional features

You can take advantage of the following features once the Adjust SDK is integrated into your project.

### <a id="att-framework"></a>AppTrackingTransparency framework

**Note**: This feature exists only in iOS platform.

For each package sent, the Adjust backend receives one of the following four (4) states of consent for access to app-related data that can be used for tracking the user or the device:

- Authorized
- Denied
- Not Determined
- Restricted

After a device receives an authorization request to approve access to app-related data, which is used for user device tracking, the returned status will either be Authorized or Denied.

Before a device receives an authorization request for access to app-related data, which is used for tracking the user or device, the returned status will be Not Determined.

If authorization to use app tracking data is restricted, the returned status will be Restricted.

The SDK has a built-in mechanism to receive an updated status after a user responds to the pop-up dialog, in case you don't want to customize your displayed dialog pop-up. To conveniently and efficiently communicate the new state of consent to the backend, Adjust SDK offers a wrapper around the app tracking authorization method described in the following chapter, App-tracking authorization wrapper.

### <a id="ata-wrapper"></a>App-tracking authorisation wrapper

**Note**: This feature exists only in iOS platform.

Adjust SDK offers the possibility to use it for requesting user authorization in accessing their app-related data. Adjust SDK has a wrapper built on top of the [requestTrackingAuthorizationWithCompletionHandler:](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/3547037-requesttrackingauthorizationwith?language=objc) method, where you can as well define the callback method to get information about a user's choice. Also, with the use of this wrapper, as soon as a user responds to the pop-up dialog, it's then communicated back using your callback method. The SDK will also inform the backend of the user's choice. Integer value will be delivered via your callback method with the following meaning:

- 0: `ATTrackingManagerAuthorizationStatusNotDetermined`
- 1: `ATTrackingManagerAuthorizationStatusRestricted`
- 2: `ATTrackingManagerAuthorizationStatusDenied`
- 3: `ATTrackingManagerAuthorizationStatusAuthorized`

To use this wrapper, you can call it as such:

```js
Adjust.requestTrackingAuthorizationWithCompletionHandler(function(status) {
    switch (status) {
        case 0:
            // ATTrackingManagerAuthorizationStatusNotDetermined case
            break;
        case 1:
            // ATTrackingManagerAuthorizationStatusRestricted case
            break;
        case 2:
            // ATTrackingManagerAuthorizationStatusDenied case
            break;
        case 3:
            // ATTrackingManagerAuthorizationStatusAuthorized case
            break;
    }
});
```

### <a id="ata-getter"></a>Get current authorisation status

**Note**: This feature exists only in iOS platform.

To get the current app tracking authorization status you can call `getAppTrackingAuthorizationStatus` method of `Adjust` class that will return one of the following possibilities:

* `0`: The user hasn't been asked yet
* `1`: The user device is restricted
* `2`: The user denied access to IDFA
* `3`: The user authorized access to IDFA
* `-1`: The status is not available

### <a id="att-status-change"></a>Check for ATT status change

In cases where you are not using [Adjust app-tracking authorization wrapper](#ata-wrapper), Adjust SDK will not be able to know immediately upon answering the dialog what is the new value of app-tracking status. In situations like this, if you would want Adjust SDK to read the new app-tracking status value and communicate it to our backend, make sure to make a call to this method:

```js
Adjust.checkForNewAttStatus();
```

### <a id="skadn-framework"></a>SKAdNetwork framework

**Note**: This feature exists only in iOS platform.

If you have implemented the Adjust iOS SDK **v4.23.0 or above** and your app is running on iOS 14 and above, the communication with SKAdNetwork will be set on by default, although you can choose to turn it off. When set on, Adjust automatically registers for SKAdNetwork attribution when the SDK is initialized. If events are set up in the Adjust dashboard to receive conversion values, the Adjust backend sends the conversion value data to the SDK. The SDK then sets the conversion value. After Adjust receives the SKAdNetwork callback data, it is then displayed in the dashboard.

In case you don't want the Adjust SDK to automatically communicate with SKAdNetwork, you can disable that by calling the following method on configuration object:

```js
adjustConfig.deactivateSKAdNetworkHandling();
```

### <a id="skadn-update-conversion-value"></a>Update SKAdNetwork conversion value

**Note**: This feature exists only in iOS platform.

You can use Adjust SDK wrapper method `updateConversionValue` to update SKAdNetwork conversion value for your user:

```js
Adjust.updateConversionValue(6);
```

### <a id="skadn-cv-updated-callback"></a>Conversion value updated callback

**Note**: This feature exists only in iOS platform.

You can register callback to get notified each time when Adjust SDK updates conversion value for the user.

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setConversionValueUpdatedCallbackListener(function(conversionValue) {
    console.log("Conversion value updated callback recveived");
    console.log("Conversion value: " + conversionValue);
  });

Adjust.create(adjustConfig);
```

### <a id="event-tracking"></a>Event tracking

You can use Adjust to track all kinds of events. Let's say you want to track every tap on a button. Simply create a new event token in your [dashboard](http://dash.adjust.com). Let's say that event token is `abc123`. You can add the following line in your button’s click handler method to track the click:

```js
var adjustEvent = new AdjustEvent("abc123");
Adjust.trackEvent(adjustEvent);
```

### <a id="revenue-tracking"></a>Revenue tracking

If your users can generate revenue by tapping on advertisements or making In-App Purchases, then you can track those revenues with events. Let's say a tap is worth €0.01. You could track the revenue event like this:

```js
var adjustEvent = new AdjustEvent("abc123");
adjustEvent.setRevenue(0.01, "EUR");
Adjust.trackEvent(adjustEvent);
```

When you set a currency token, Adjust will automatically convert the incoming revenues into a reporting revenue of your choice. Read more about [currency conversion here](https://docs.adjust.com/en/event-tracking/#tracking-purchases-in-different-currencies).


### <a id="revenue-deduplication"></a>Revenue deduplication

You can also add an optional transaction ID to avoid tracking duplicate revenues. The last ten transaction IDs are remembered, and revenue events with duplicate transaction IDs are skipped. This is especially useful for In-App Purchase tracking. You can see an example below.

If you want to track in-app purchases, please make sure to call the `trackEvent` only if the transaction is finished and an item is purchased. That way you can avoid tracking revenue that is not actually being generated.

```js
var adjustEvent = new AdjustEvent("abc123");
adjustEvent.setRevenue(0.01, "EUR");
adjustEvent.setTransactionId("{YourTransactionId}");
Adjust.trackEvent(adjustEvent);
```

**Note**: Transaction ID is the iOS term, unique identifier for successfully finished Android In-App-Purchases is named **Order ID**.

### <a id="callback-parameters"></a>Callback parameters

You can also register a callback URL for that event in your [dashboard](http://dash.adjust.com) and we will send a GET request to that URL whenever the event gets tracked. In that case you can also put some key-value pairs in an object and pass it to the `trackEvent` method. We will then append these named parameters to your callback URL.

For example, suppose you have registered the URL `http://www.adjust.com/callback` for your event with event token `abc123` and execute the following lines:

```js
var adjustEvent = new AdjustEvent("abc123");
adjustEvent.addCallbackParameter("key", "value");
adjustEvent.addCallbackParameter("foo", "bar");
Adjust.trackEvent(adjustEvent);
```

In that case we would track the event and send a request to:

```
http://www.adjust.com/callback?key=value&foo=bar
```

It should be mentioned that we support a variety of placeholders like `{idfa}` for iOS or `{gps_adid}` for Android that can be used as parameter values.  In the resulting callback the `{idfa}` placeholder would be replaced with the ID for Advertisers of the current device for iOS and the `{gps_adid}` would be replaced with the Google Advertising ID of the current device for Android. Also note that we don't store any of your custom parameters, but only append them to your callbacks. If you haven't registered a callback for an event, these parameters won't even be read.

You can read more about using URL callbacks, including a full list of available values, in our [callbacks guide](https://docs.adjust.com/en/callbacks).

### <a id="partner-parameters"></a>Partner parameters

Similarly to the callback parameters mentioned above, you can also add parameters that Adjust will transmit to the network partners of your choice. You can activate these networks in your Adjust dashboard.

This works similarly to the callback parameters mentioned above, but can be added by calling the `addPartnerParameter` method on your `AdjustEvent` instance.

```js
var adjustEvent = new AdjustEvent("abc123");
adjustEvent.addPartnerParameter("key", "value");
adjustEvent.addPartnerParameter("foo", "bar");
Adjust.trackEvent(adjustEvent);
```

You can read more about special partners and networks in our [guide to special partners](https://docs.adjust.com/en/special-partners).

### <a id="callback-id"></a>Callback identifier

You can also add custom string identifier to each event you want to track. This identifier will later be reported in event success and/or event failure callbacks to enable you to keep track on which event was successfully tracked or not. You can set this identifier by calling the `setCallbackId` method on your `AdjustEvent` instance:

```js
var adjustEvent = new AdjustEvent("abc123");
adjustEvent.setCallbackId("Your-Custom-Id");
Adjust.trackEvent(adjustEvent);
```

### <a id="subscription-tracking"></a>Subscription tracking

**Note**: This feature is only available in the SDK **v4.22.0 and above**.

You can track App Store and Play Store subscriptions and verify their validity with the Adjust SDK. After a subscription has been successfully purchased, make the following call to the Adjust SDK:

**For App Store subscription:**

```js
var subscription = new AdjustAppStoreSubscription(price, currency, transactionId, receipt);
subscription.setTransactionDate(transactionDate);
subscription.setSalesRegion(salesRegion);

Adjust.trackAppStoreSubscription(subscription);
```

**For Play Store subscription:**

```js
var subscription = new AdjustPlayStoreSubscription(price, currency, sku, orderId, signature, purchaseToken);
subscription.setPurchaseTime(purchaseTime);

Adjust.trackPlayStoreSubscription(subscription);
```

Subscription tracking parameters for App Store subscription:

- [price](https://developer.apple.com/documentation/storekit/skproduct/1506094-price?language=objc)
- currency (you need to pass [currencyCode](https://developer.apple.com/documentation/foundation/nslocale/1642836-currencycode?language=objc) of the [priceLocale](https://developer.apple.com/documentation/storekit/skproduct/1506145-pricelocale?language=objc) object)
- [transactionId](https://developer.apple.com/documentation/storekit/skpaymenttransaction/1411288-transactionidentifier?language=objc)
- [receipt](https://developer.apple.com/documentation/foundation/nsbundle/1407276-appstorereceipturl)
- [transactionDate](https://developer.apple.com/documentation/storekit/skpaymenttransaction/1411273-transactiondate?language=objc)
- salesRegion (you need to pass [countryCode](https://developer.apple.com/documentation/foundation/nslocale/1643060-countrycode?language=objc) of the [priceLocale](https://developer.apple.com/documentation/storekit/skproduct/1506145-pricelocale?language=objc) object)

Subscription tracking parameters for Play Store subscription:

- [price](https://developer.android.com/reference/com/android/billingclient/api/SkuDetails#getpriceamountmicros)
- [currency](https://developer.android.com/reference/com/android/billingclient/api/SkuDetails#getpricecurrencycode)
- [sku](https://developer.android.com/reference/com/android/billingclient/api/Purchase#getsku)
- [orderId](https://developer.android.com/reference/com/android/billingclient/api/Purchase#getorderid)
- [signature](https://developer.android.com/reference/com/android/billingclient/api/Purchase#getsignature)
- [purchaseToken](https://developer.android.com/reference/com/android/billingclient/api/Purchase#getpurchasetoken)
- [purchaseTime](https://developer.android.com/reference/com/android/billingclient/api/Purchase#getpurchasetime)

**Note:** Subscription tracking API offered by Adjust SDK expects all parameters to be passed as `string` values. Parameters described above are the ones which API exects you to pass to subscription object prior to tracking subscription. There are various libraries which are handling in app purchases in Cordova and each one of them should return information described above in some form upon successfully completed subscription purchase. You should locate where these parameters are placed in response you are getting from library you are using for in app purchases, extract those values and pass them to Adjust API as string values.

Just like with event tracking, you can attach callback and partner parameters to the subscription object as well:

**For App Store subscription:**

```js
var subscription = new AdjustAppStoreSubscription(price, currency, transactionId, receipt);
subscription.setTransactionDate(transactionDate);
subscription.setSalesRegion(salesRegion);

// add callback parameters
subscription.addCallbackParameter("key", "value");
subscription.addCallbackParameter("foo", "bar");

// add partner parameters
subscription.addPartnerParameter("key", "value");
subscription.addPartnerParameter("foo", "bar");

Adjust.trackAppStoreSubscription(subscription);
```

**For Play Store subscription:**

```js
var subscription = new AdjustPlayStoreSubscription(price, currency, sku, orderId, signature, purchaseToken);
subscription.setPurchaseTime(purchaseTime);

// add callback parameters
subscription.addCallbackParameter("key", "value");
subscription.addCallbackParameter("foo", "bar");

// add partner parameters
subscription.addPartnerParameter("key", "value");
subscription.addPartnerParameter("foo", "bar");

Adjust.trackPlayStoreSubscription(subscription);
```

### <a id="session-parameters"></a>Session parameters

Some parameters are saved to be sent in every event and session of the Adjust SDK. Once you have added any of these parameters, you don't need to add them every time, since they will be saved locally. If you add the same parameter twice, there will be no effect.

These session parameters can be called before the Adjust SDK is launched to make sure they are sent even on install. If you need to send them with an install, but can only obtain the needed values after launch, it's possible to [delay](#delay-start) the first launch of the Adjust SDK to allow this behaviour.

### <a id="session-callback-parameters"></a>Session callback parameters

The same callback parameters that are registered for [events](#callback-parameters) can be also saved to be sent in every event or session of the Adjust SDK.

The session callback parameters have a similar interface of the event callback parameters. Instead of adding the key and its value to an event, it's added through a call to method `addSessionCallbackParameter` of the `Adjust` instance:

```js
Adjust.addSessionCallbackParameter("foo", "bar");
```

The session callback parameters will be merged with the callback parameters added to an event. The callback parameters added to an event have precedence over the session callback parameters. Meaning that, when adding a callback parameter to an event with the same key to one added from the session, the value that prevails is the callback parameter added to the event.

It's possible to remove a specific session callback parameter by passing the desiring key to the method `removeSessionCallbackParameter` of the `Adjust` instance:

```js
Adjust.removeSessionCallbackParameter("foo");
```

If you wish to remove all key and values from the session callback parameters, you can reset it with the method `resetSessionCallbackParameters` of the `Adjust` instance:

```js
Adjust.resetSessionCallbackParameters();
```

### <a id="session-partner-parameters"></a>Session partner parameters

In the same way that there are [session callback parameters](#session-callback-parameters) that are sent for every event or session of the Adjust SDK, there are also session partner parameters.

These will be transmitted to network partners, for the integrations that have been activated in your Adjust [dashboard](http://dash.adjust.com).

The session partner parameters have a similar interface to the event partner parameters. Instead of adding the key and its value to an event, it's added through a call to method `addSessionPartnerParameter` of the `Adjust` instance:

```js
Adjust.addSessionPartnerParameter("foo", "bar");
```

The session partner parameters will be merged with the partner parameters added to an event. The partner parameters added to an event have precedence over the session partner parameters. Meaning that, when adding a partner parameter to an event with the same key to one added from the session, the value that prevails is the partner parameter added to the event.

It's possible to remove a specific session partner parameter by passing the desiring key to the method `removeSessionPartnerParameter` of the `Adjust` instance:

```js
Adjust.removeSessionPartnerParameter("foo");
```

If you wish to remove all keys and values from the session partner parameters, you can reset it with the method `resetSessionPartnerParameters` of the `Adjust` instance:

```js
Adjust.resetSessionPartnerParameters();
```

### <a id="delay-start"></a>Delay start

Delaying the start of the Adjust SDK allows your app some time to obtain session parameters, such as unique identifiers, to be sent on install.

Set the initial delay time in seconds with the `setDelayStart` field of the `AdjustConfig` instance:

```js
adjustConfig.setDelayStart(5.5);
```

In this case this will make the Adjust SDK not send the initial install session and any event created for 5.5 seconds. After this time is expired or if you call `sendFirstPackages()` of the `Adjust` instance in the meanwhile, every session parameter will be added to the delayed install session and events and the Adjust SDK will resume as usual.

**The maximum delay start time of the Adjust SDK is 10 seconds**.

### <a id="attribution-callback"></a>Attribution callback

You can register a listener to be notified of tracker attribution changes. Due to the different sources considered for attribution, this information cannot by provided synchronously. The simplest way is to create a single anonymous listener which is going to be called **each time your user's attribution value changes**:

With the `AdjustConfig` instance, before starting the SDK, add the anonymous listener:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setAttributionCallbackListener(function(attribution) {
    // Printing all attribution properties.
    console.log("Attribution changed!");
    console.log(attribution.trackerToken);
    console.log(attribution.trackerName);
    console.log(attribution.network);
    console.log(attribution.campaign);
    console.log(attribution.adgroup);
    console.log(attribution.creative);
    console.log(attribution.clickLabel);
    console.log(attribution.adid);
    console.log(attribution.costType);
    console.log(attribution.costAmount);
    console.log(attribution.costCurrency);
});

Adjust.create(adjustConfig);
```

Within the listener function you have access to the `attribution` parameters. Here is a quick summary of its properties:

- `trackerToken`    the tracker token of the current attribution.
- `trackerName`     the tracker name of the current attribution.
- `network`         the network grouping level of the current attribution.
- `campaign`        the campaign grouping level of the current attribution.
- `adgroup`         the ad group grouping level of the current attribution.
- `creative`        the creative grouping level of the current attribution.
- `clickLabel`      the click label of the current attribution.
- `adid`            the Adjust device identifier.
- `costType`        the cost type.
- `costAmount`      the cost amount.
- `costCurrency`    the cost currency.

Please make sure to consider our [applicable attribution data policies](https://github.com/adjust/sdks/blob/master/doc/attribution-data.md).

**Note**: The cost data - `costType`, `costAmount` & `costCurrency` are only available when configured in `AdjustConfig` by calling `setNeedsCost` method. If not configured or configured, but not being part of the attribution, these fields will have value `null`. This feature is available in SDK v4.26.0 and above.

### <a id="session-event-callbacks">Session and event callbacks

You can register a callback to be notified of successful and failed tracked events and/or sessions.

Follow the same steps as for attribution callback to implement the following callback function for successfully tracked events:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setEventTrackingSucceededCallbackListener(function(eventSuccess) {
    // Printing all event success properties.
    console.log("Event tracking succeeded!");
    console.log(eventSuccess.message);
    console.log(eventSuccess.timestamp);
    console.log(eventSuccess.eventToken);
    console.log(eventSuccess.callbackId);
    console.log(eventSuccess.adid);
    console.log(eventSuccess.jsonResponse);
});

Adjust.create(adjustConfig);
```

The following callback function for failed tracked events:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setEventTrackingFailedCallbackListener(function(eventFailure) {
    // Printing all event failure properties.
    console.log("Event tracking failed!");
    console.log(eventFailure.message);
    console.log(eventFailure.timestamp);
    console.log(eventFailure.eventToken);
    console.log(eventFailure.callbackId);
    console.log(eventFailure.adid);
    console.log(eventFailure.willRetry);
    console.log(eventFailure.jsonResponse);
});

Adjust.create(adjustConfig);
```

For successfully tracked sessions:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setSessionTrackingSucceededCallbackListener(function(sessionSuccess) {
    // Printing all session success properties.
    console.log("Session tracking succeeded!");
    console.log(sessionSuccess.message);
    console.log(sessionSuccess.timestamp);
    console.log(sessionSuccess.adid);
    console.log(sessionSuccess.jsonResponse);
});

Adjust.create(adjustConfig);
```

And for failed tracked sessions:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setSessionTrackingFailedCallbackListener(function(sessionFailure) {
    // Printing all session failure properties.
    console.log("Session tracking failed!");
    console.log(sessionFailure.message);
    console.log(sessionFailure.timestamp);
    console.log(sessionFailure.adid);
    console.log(sessionFailure.willRetry);
    console.log(sessionFailure.jsonResponse);
});

Adjust.create(adjustConfig);
```

The callback functions will be called after the SDK tries to send a package to the server. Within the callback you have access to a response data object specifically for the callback. Here is a quick summary of the session response data properties:

- `var message` the message from the server or the error logged by the SDK.
- `var timestamp` timestamp from the server.
- `var adid` a unique device identifier provided by Adjust.
- `var jsonResponse` the JSON object with the response from the server.

Both event response data objects contain:

- `var eventToken` the event token, if the package tracked was an event.
- `var callbackId` the custom defined callback ID set on event object.

And both event and session failed objects also contain:

- `var willRetry` indicates there will be an attempt to resend the package at a later time.

### <a id="disable-tracking"></a>Disable tracking

You can disable the Adjust SDK from tracking by invoking the method `setEnabled` of the `Adjust` instance with the enabled parameter as `false`. This setting is **remembered between sessions**, but it can only be activated after the first session.

```js
Adjust.setEnabled(false);
```

You can verify if the Adjust SDK is currently active with the method `isEnabled` of the `Adjust` instance. It is always possible to activate the Adjust SDK by invoking `setEnabled` with the parameter set to `true`.

### <a id="offline-mode"></a>Offline mode

You can put the Adjust SDK in offline mode to suspend transmission to our servers while retaining tracked data to be sent later. When in offline mode, all information is saved in a file, so be careful not to trigger too many events while in offline mode.

You can activate offline mode by calling the method `setOfflineMode` of the `Adjust` instance with the parameter `true`.

```js
Adjust.setOfflineMode(true);
```

Conversely, you can deactivate offline mode by calling `setOfflineMode` with `false`. When the Adjust SDK is put back in online mode, all saved information is send to our servers with the correct time information.

Unlike disabling tracking, **this setting is not remembered** between sessions. This means that the SDK is in online mode whenever it is started, even if the app was terminated in offline mode.

### <a id="event-buffering"></a>Event buffering

If your app makes heavy use of event tracking, you might want to delay some HTTP requests in order to send them in one batch every minute. You can enable event buffering with your `AdjustConfig` instance by calling `setEventBufferingEnabled` method:

```js
var adjustConfig = new AdjustConfig(appToken, environment);
adjustConfig.setEventBufferingEnabled(true);
Adjust.create(adjustConfig);
```

### <a id="gdpr-forget-me"></a>GDPR right to be forgotten

In accordance with article 17 of the EU's General Data Protection Regulation (GDPR), you can notify Adjust when a user has exercised their right to be forgotten. Calling the following method will instruct the Adjust SDK to communicate the user's choice to be forgotten to the Adjust backend:

```js
Adjust.gdprForgetMe();
```

Upon receiving this information, Adjust will erase the user's data and the Adjust SDK will stop tracking the user. No requests from this device will be sent to Adjust in the future.

## <a id="third-party-sharing"></a>Third-party sharing for specific users

You can notify Adjust when a user disables, enables, and re-enables data sharing with third-party partners.

### <a id="disable-third-party-sharing"></a>Disable third-party sharing for specific users

Call the following method to instruct the Adjust SDK to communicate the user's choice to disable data sharing to the Adjust backend:

```js
var adjustThirdPartySharing = new AdjustThirdPartySharing(false);
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

Upon receiving this information, Adjust will block the sharing of that specific user's data to partners and the Adjust SDK will continue to work as usual.

### <a id="enable-third-party-sharing">Enable or re-enable third-party sharing for specific users</a>

Call the following method to instruct the Adjust SDK to communicate the user's choice to share data or change data sharing, to the Adjust backend:

```js
var adjustThirdPartySharing = new AdjustThirdPartySharing(true);
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

Upon receiving this information, Adjust changes sharing the specific user's data to partners. The Adjust SDK will continue to work as expected.

Call the following method to instruct the Adjust SDK to send the granular options to the Adjust backend:

```js
var adjustThirdPartySharing = new AdjustThirdPartySharing(null);
adjustThirdPartySharing.addGranularOption("PartnerA", "foo", "bar");
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

### <a id="measurement-consent"></a>Consent measurement for specific users

You can notify Adjust when a user exercises their right to change data sharing with partners for marketing purposes, but they allow data sharing for statistical purposes. 

Call the following method to instruct the Adjust SDK to communicate the user's choice to change data sharing, to the Adjust backend:

```js
Adjust.trackMeasurementConsent(true);
```

Upon receiving this information, Adjust changes sharing the specific user's data to partners. The Adjust SDK will continue to work as expected.

### <a id="sdk-signature"></a>SDK signature

When you set up the SDK Signature, each SDK communication package is "signed". This lets Adjust’s servers easily detect and reject any install activity that is not legitimate.

There are just a few steps involved in setting up the SDK Signature. Please contact your Technical Account Manager or support@adjust.com to get started.

### <a id="background-tracking"></a>Background tracking

The default behaviour of the Adjust SDK is to **pause sending HTTP requests while the app is in the background**. You can change this in your `AdjustConfig` instance by calling `setSendInBackground` method:

```js
var adjustConfig = new AdjustConfig(appToken, environment);
adjustConfig.setSendInBackground(true);
Adjust.create(adjustConfig);
```

If nothing is set, sending in background is **disabled by default**.

### <a id="device-ids"></a>Device IDs

Certain services (such as Google Analytics) require you to coordinate Device and Client IDs in order to prevent duplicate reporting.

### <a id="di-idfa">iOS Advertising Identifier

To obtain the IDFA, call the `getIdfa` method of the `Adjust` instance. You need to pass a callback to that method in order to obtain the value:

```js
Adjust.getIdfa(function(idfa) {
    // Use idfa value.
});
```

### <a id="di-gps-adid"></a>Google Play Services advertising identifier
  
The Google Play Services Advertising Identifier (Google advertising ID) is a unique identifier for a device. Users can opt out of sharing their Google advertising ID by toggling the "Opt out of Ads Personalization" setting on their device. When a user has enabled this setting, the Adjust SDK returns a string of zeros when trying to read the Google advertising ID.

> **Important**: If you are targeting Android 12 and above (API level 31), you need to add the [`com.google.android.gms.AD_ID` permission](#gps-adid-permission) to your app. If you do not add this permission, you will not be able to read the Google advertising ID even if the user has not opted out of sharing their ID.

If you need to obtain the Google Advertising ID, you can call the `getGoogleAdId` method of the `Adjust` instance. You need to pass a callback to that method in order to obtain the value:

```js
Adjust.getGoogleAdId(function(googleAdId) {
    // Use googleAdId value.
});
```

Inside the callback method you will have access to the Google Advertising ID as the variable `googleAdId`.

### <a id="di-fire-adid"></a>Amazon advertising identifier

If you need to obtain the Amazon advertising ID, you can call the `getAmazonAdId` method on `Adjust` instance:

```js
Adjust.getAmazonAdId(function(amazonAdId) {
    // Use amazonAdId value.
});
```

Inside the callback method you will have access to the Amazon Advertising ID as the variable `amazonAdId`.

### <a id="di-adid"></a>Adjust device identifier

For every device with your app installed on it, the Adjust backend generates a unique **Adjust device identifier** (**adid**). In order to obtain this identifier, call the `getAdid` method of the `Adjust` instance. You need to pass a callback to that method in order to obtain the value:

```js
Adjust.getAdid(function(adid) {
    // Use adid value.
});
```

**Note**: Information about the **adid** is only available after an app installation has been tracked by the Adjust backend. From that moment on, the Adjust SDK has information about the device **adid** and you can access it with this method. So, **it is not possible** to access the **adid** value before the SDK has been initialised and installation of your app has been successfully tracked.
  
### <a id="set-external-device-id"></a>Set external device ID

> **Note** If you want to use external device IDs, please contact your Adjust representative. They will talk you through the best approach for your use case.

An external device identifier is a custom value that you can assign to a device or user. They can help you to recognize users across sessions and platforms. They can also help you to deduplicate installs by user so that a user isn't counted as multiple new installs.

You can also use an external device ID as a custom identifier for a device. This can be useful if you use these identifiers elsewhere and want to keep continuity.

Check out our [external device identifiers article](https://help.adjust.com/en/article/external-device-identifiers) for more information.

> **Note** This setting requires Adjust SDK **v4.21.0 or later**.

To set an external device ID, assign the identifier to the `externalDeviceId` property of your config instance. Do this before you initialize the Adjust SDK.

```js
adjustConfig.setExternalDeviceId("{Your-External-Device-Id}");
```

> **Important**: You need to make sure this ID is **unique to the user or device** depending on your use-case. Using the same ID across different users or devices could lead to duplicated data. Talk to your Adjust representative for more information.

If you want to use the external device ID in your business analytics, you can pass it as a session callback parameter. See the section on [session callback parameters](#session-callback-parameters) for more information.

You can import existing external device IDs into Adjust. This ensures that the backend matches future data to your existing device records. If you want to do this, please contact your Adjust representative.

### <a id="user-attribution"></a>User attribution

As described in the [attribution callback section](#attribution-callback), this callback is triggered, providing you with information about a new attribution whenever it changes. If you want to access information about a user's current attribution whenever you need it, you can make a call to the `getAttribution` method of the `Adjust` instance:

```js
Adjust.getAttribution(function(attribution) {
    // Use attribution object in same way like in attribution callback.
});
```

**Note**: Information about current attribution is only available after an app installation has been tracked by the Adjust backend and the attribution callback has been triggered. From that moment on, the Adjust SDK has information about a user's attribution and you can access it with this method. So, **it is not possible** to access a user's attribution value before the SDK has been initialised and an attribution callback has been triggered.

### <a id="push-token"></a>Push token

To send us the push notification token, add the following call to Adjust **whenever you get your token in the app or when it gets updated**:

```js
Adjust.setPushToken("YourPushNotificationsToken");
```

Push tokens are used for Audience Builder and client callbacks, and they are required for the uninstall tracking feature.

### <a id="pre-installed-trackers"></a>Pre-installed trackers

If you want to use the Adjust SDK to recognize users that found your app pre-installed on their device, follow these steps.

1. Create a new tracker in your [dashboard](http://dash.adjust.com).
2. Open your app delegate and add set the default tracker of your `AdjustConfig` instance:

    ```js
    var adjustConfig = new AdjustConfig(appToken, environment);
    adjustConfig.setDefaultTracker("{TrackerToken}");
    Adjust.create(adjustConfig);
    ```

  Replace `{TrackerToken}` with the tracker token you created in step 2. Please note that the dashboard displays a tracker 
  URL (including `http://app.adjust.com/`). In your source code, you should specify only the six-character token and not the
  entire URL.

3. Build and run your app. You should see a line like the following in the app's log output:

    ```
    Default tracker: 'abc123'
    ```

### <a id="deeplinking"></a>Deep linking

If you are using the Adjust tracker URL with an option to deep link into your app from the URL, there is the possibility to get info about the deep link URL and its content. Hitting the URL can happen when the user has your app already installed (standard deep linking scenario) or if they don't have the app on their device (deferred deep linking scenario).

### <a id="deeplinking-standard"></a>Standard deep linking scenario

Standard deep linking scenario is a platform specific feature and in order to support it, you need to add some additional settings to your app. If your user already has the app installed and hits the tracker URL with deep link information in it, your application will be opened and the content of the deep link will be sent to your app so that you can parse it and decide what to do next. 

**Note for iOS**: With the introduction of iOS 9, Apple has changed the way deep linking is handled in the app. Depending on which scenario you want to use for your app (or if you want to use them both to support a wide range of devices), you need to set up your app to handle one or both of the following scenarios.

### <a id="deeplinking-android-ios-old"></a>Deep linking on Android & iOS 8 and earlier

To support deep linking handling in your app for Android and iOS 8 and earlier versions, you can use the `Custom URL Scheme` plugin which can be found [here](https://github.com/EddyVerbruggen/Custom-URL-scheme).

After you successfully integrate this plugin, in the callback method used with the plugin described in this [section](https://github.com/EddyVerbruggen/Custom-URL-scheme#3-usage) you will have an access to the content of the URL which opened your app on user's device:

```js
function handleOpenURL(url) {
    setTimeout(function () {
        // Check content of the url object and get information about the URL.
    }, 300);
};
```

By completing integration of this plugin, you should be able to handle deep linking in **Android and iOS 8 and lower**.

### <a id="deeplinking-ios-new"></a>Deep linking on iOS 9 and later

Starting from **iOS 9**, Apple has introduced suppressed support for old style deep linking with custom URL schemes like described above in favour of `universal links`. If you want to support deep linking in your app for iOS 9 and higher, you need to add support for universal links handling.

First thing you need to do is to enable universal links for your app in the Adjust dashboard. Instructions on how to do that can be found in our native iOS SDK [README](https://github.com/adjust/ios_sdk#deeplinking-setup-new).

After you have enabled universal links handling for your app in your dashboard, you need to add support for it in your app as well. You can achieve this by adding this [plugin](https://github.com/nordnet/cordova-universal-links-plugin) to your cordova app. Please, read the README of this plugin, because it precisely describes what should be done in order to properly integrate it.

**Note**: You can disregard any information in the README that states that you need to have a domain and website or you need to upload a file to the root of your domain. Adjust is taking care of this instead of you and you can skip these parts of the README. Also, you don't need to follow the instructions of this plugin for the Android platform, because deep linking in Android is still being handled with `Custom URL scheme` plugin.

To complete the integration of `Cordova Universal Links Plugin` after successfully enabling universal links for your app in the Adjust dashboard you must:

### Edit your `config.xml` file

You need to add following entry to your `config.xml` file:

```xml
<widget>
    <universal-links>
        <host name="[hash].adj.st" scheme="https" event="adjustDeepLinking" />
    </universal-links>
</widget>
```

You should replace the `[hash]` value with the value you generated on the Adjust dashboard. You can name the event also how ever you like.

### Check `ul_web_hooks/ios/` content of the plugin

Go to the `Cordova Universal Links Plugin` install directory in your app and check the `ul_web_hooks/ios/` folder content. In there, you should see a generated file with the name `[hash].ulink.adjust.com#apple-app-site-association`. The content of that file should look like this:

```
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "<YOUR_TEAM_ID_FROM_MEMBER_CENTER>.com.adjust.examples",
        "paths": [
          "/ulink/*"
        ]
      }
    ]
  }
}
```

### Integrate plugin to your `index.js` file

After the `deviceready` event gets fired, you should subscribe to the event you have defined in your `config.xml` file, and define the callback method which gets fired once the event is triggered. Because you don't need this plugin to handle deep linking in Android, you can only need to subscribe to it if your app is running on an iOS device.

```js
// ...

var app = {
    initialize: function() {
        this.bindEvents();
    },

    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },

    onDeviceReady: function() {
        if (device.platform == "iOS") {
            universalLinks.subscribe('adjustDeepLinking', app.didLaunchAppFromLink);
        }
    },

    didLaunchAppFromLink: function(eventData) {
        // Check content of the eventData.url object and get information about the URL.
    }
}
// ...
```

By completing these steps, you have successfully added support for deep linking for iOS 9 and above as well.

### <a id="deeplinking-deferred"></a>Deferred deep linking scenario

While deferred deep linking is not supported out of the box on Android and iOS, our Adjust SDK makes it possible.
 
In order to get info about the URL content in a deferred deep linking scenario, you should set a callback method on the `AdjustConfig` object which will receive one parameter where the content of the URL will be delivered. You should set this method on the config object by calling the method `setDeferredDeeplinkCallbackListener`:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setDeferredDeeplinkCallbackListener(function(deeplink) {
    console.log("Deferred deep link URL content: " + deeplink);
});

Adjust.create(adjustConfig);
```

In deferred deep linking scenario, there is one additional setting which can be set on the `AdjustConfig` object. Once the Adjust SDK gets the deferred deep link info, we are offering you the possibility to choose whether our SDK should open this URL or not. You can choose to set this option by calling the `setShouldLaunchDeeplink` method on the config object:


```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setShouldLaunchDeeplink(true);
// or adjustConfig.setShouldLaunchDeeplink(false);

adjustConfig.setDeferredDeeplinkCallbackListener(function(deeplink) {
    console.log("Deferred deep link URL content: " + deeplink);
});

Adjust.create(adjustConfig);
```

If nothing is set, **the Adjust SDK will always try to launch the URL by default**.

### <a id="deeplinking-reattribution"></a>Reattribution via deep links

Adjust enables you to run re-engagement campaigns by using deep links. For more information on this, please check our [official docs](https://docs.adjust.com/en/deeplinking/#manually-appending-attribution-data-to-a-deep-link).

If you are using this feature, in order for your user to be properly reattributed, you need to make one additional call to the Adjust SDK in your app.

Once you have received deep link content information in your app, add a call to `appWillOpenUrl` method of the `Adjust` instance. By making this call, the Adjust SDK will try to find if there is any new attribution info inside of the deep link and if any, it will be sent to the Adjust backend. If your user should be reattributed due to a click on the Adjust tracker URL with deep link content in it, you will see the [attribution callback](#attribution-callback) in your app being triggered with new attribution info for this user.

In the code examples described above, a call to the `appWillOpenUrl` method should be done like this:

```js
function handleOpenURL(url) {
    setTimeout(function () {
        // Check content of the url object and get information about the URL.
        Adjust.appWillOpenUrl(url);
    }, 300);
};
```

```js
// ...

var app = {
    initialize: function() {
        this.bindEvents();
    },

    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },

    onDeviceReady: function() {
        if (device.platform == "iOS") {
            universalLinks.subscribe('adjustDeepLinking', app.didLaunchAppFromLink);
        }
    },

    didLaunchAppFromLink: function(eventData) {
        // Check content of the eventData.url object and get information about the URL.
        Adjust.appWillOpenUrl(eventData.url);
    }
}
// ...
```

### <a id="data-residency"></a>Data residency

In order to enable data residency feature, make sure to call `setUrlStrategy` method of the `AdjustConfig` instance with one of the following constants:

```js
adjustConfig.setUrlStrategy(AdjustConfig.DataResidencyEU); // for EU data residency region
adjustConfig.setUrlStrategy(AdjustConfig.DataResidencyTR); // for Turkey data residency region
adjustConfig.setUrlStrategy(AdjustConfig.DataResidencyUS); // for US data residency region
```

### <a id="oaid-plugin"></a>OAID plugin

You can enable **native** Adjust OAID plugin directly from Adjust Cordova SDK. In order to do that, first make sure to read [native OAID plugin docs](https://github.com/adjust/android_sdk/blob/master/doc/english/plugins/oaid.md). Since Adjust Cordova SDK is already adding the native Adjust SDK under the hood, only dependency you need to add to your app from OAID plugin docs is the OAID plugin dependency. After that has been done, you have an option to enable usage of native Adjust OAID plugin by calling `setOaidReadingEnabled` method of `AdjustConfig`:

```js
adjustConfig.setOaidReadingEnabled(true);
```
  
### <a id="coppa-compliance"></a>COPPA compliance

By default Adjust SDK doesn't mark app as COPPA compliant. In order to mark your app as COPPA compliant, make sure to call `setCoppaCompliantEnabled` method of `AdjustConfig` instance with boolean parameter `true`:

```js
adjustConfig.setCoppaCompliantEnabled(true);
```

**Note:** By enabling this feature, third-party sharing will be automatically disabled for the users. If later during the app lifetime you decide not to mark app as COPPA compliant anymore, third-party sharing **will not be automatically re-enabled**. Instead, next to not marking your app as COPPA compliant anymore, you will need to explicitly re-enable third-party sharing in case you want to do that.

### <a id="play-store-kids-apps"></a>Play Store Kids Apps

By default Adjust SDK doesn't mark Android app as Play Store Kids App. In order to mark your app as the app which is targetting kids in Play Store, make sure to call `setPlayStoreKidsAppEnabled` method of `AdjustConfig` instance with boolean parameter `true`:

```js
adjustConfig.setPlayStoreKidsAppEnabled(true);
```

## <a id="license"></a>License

The Adjust SDK is licensed under the MIT License.

Copyright (c) 2012-Present Adjust GmbH, http://www.adjust.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
