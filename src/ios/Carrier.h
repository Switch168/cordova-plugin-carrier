#import <Cordova/CDV.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CoreLocation.h>

@interface Carrier : CDVPlugin

- (void)getCarrierInfo:(CDVInvokedUrlCommand*)command;
- (void)geocodeCountryCode:(CDVInvokedUrlCommand*)command andLat:(double)lat andLng:(double)lng;
@end
