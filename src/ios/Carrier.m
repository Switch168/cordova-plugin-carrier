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
   if (!countryCodeResult)    countryCodeResult = @"";
  

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

- (void)geocodeCountryCode:(CDVInvokedUrlCommand*)command andParams:(NSArray *)paramList
{
   if (!paramList || paramList.count == 0) {return;}
   
   __block NSString *countryCodeResult = @"";
   __block NSString *countryCodeOrigin = @"";
   
   NSNumber *latn = [paramList objectAtIndex:0];
   NSNumber *lngn = [paramList objectAtIndex:1];
   
   if (!latn || ![latn isKindOfClass:[NSNumber class]] || !lngn || ![lngn isKindOfClass:[NSNumber class]]) { return; }
   
   CLLocation *loc = [[CLLocation alloc] initWithLatitude:latn.doubleValue longitude:lngn.doubleValue];
   
   CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
   [reverseGeocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error)
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
   
   NSDictionary *carrierData = [NSDictionary dictionaryWithObjectsAndKeys:
   countryCodeResult,@"countryCode",
   countryCodeOrigin,@"countryCodeOrigin",
   nil];

   CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:carrierData];

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
