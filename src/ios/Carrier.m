/********* Echo.m Cordova Plugin Implementation *******/

#import "Carrier.h"
#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>

@implementation Carrier

- (void)getCarrierInfo:(CDVInvokedUrlCommand*)command
{
   CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
   CTCarrier *carrier = [netinfo subscriberCellularProvider];

   NSString *carrierNameResult    = [carrier carrierName];
   NSString *carrierCodeResult    = [carrier mobileCountryCode];
   NSString *carrierNetworkResult = [carrier mobileNetworkCode];
   NSString *countryCodeResult = [carrier isoCountryCode];
   NSString *countryCodeOrigin = @"carrier";

   if (!carrierNameResult)    carrierNameResult    = @"";
   if (!carrierCodeResult)    carrierCodeResult    = @"";
   if (!carrierNetworkResult) carrierNetworkResult = @"";

   if (!countryCodeResult)
   {
      countryCodeResult = @"";
      CLLocationManager *locationManager = [[CLLocationManager alloc] init];
      
      if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
         [locationManager requestAlwaysAuthorization];
         locationManager.pausesLocationUpdatesAutomatically = YES;
         
         locationManager.distanceFilter = kCLDistanceFilterNone;
         locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
         [locationManager startUpdatingLocation];
         [locationManager stopUpdatingLocation];
         
         CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
         [reverseGeocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray *placemarks, NSError *error)
         {
            if(!error) {
               CLPlacemark *pm = [placemarks objectAtIndex:0];
               NSString *countryCode = pm.ISOcountryCode;
               if (countryCode) {
                  countryCodeOrigin = @"geocode";
                  countryCodeResult = countryCode;
               }
            }
         }];
      }
   }

   NSDictionary *carrierData = [NSDictionary dictionaryWithObjectsAndKeys:
   carrierNameResult,@"carrierName",
   carrierCodeResult,@"mcc",
   carrierNetworkResult,@"mnc",
   countryCodeResult,@"countryCode",
   countryCodeOrigin,@"countryCodeOrigin",
   nil];

   CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:carrierData];

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
