package com.dtmtec;

import android.app.Activity;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.telephony.TelephonyManager;

public class Carrier extends CordovaPlugin {
  
  private static final String ACTION_GET_CARRIER_INFO = "getCarrierInfo";
  private static final String ACTION_GEOCODE = "geocodeCountryCode";

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    Context context = this.cordova.getActivity().getApplicationContext();
    JSONObject result = null;
    
    if (ACTION_GET_CARRIER_INFO.equals(action)) {
      result = getCarrierInfo(context);
    } else if (ACTION_GEOCODE.equals(action) && args.length >= 2){
      String cc = getCountryCodeFromLatLng(context, args.optDouble(0), args.optDouble(1));
      result = new JSONObject();
      result.put("countryCode", cc);
      result.put("origin", "geocode");
    } else {
      return false;
    }
    
    if (result != null){
      callbackContext.success(result);
      return true;
    } else {
      return false;
    }
  }
  
  private static JSONObject getCarrierInfo(Context context){
      TelephonyManager manager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);

      String carrierName = manager.getSimOperatorName(); // VIVO
      String networkName = manager.getNetworkOperatorName();

      String simCountryCode = manager.getSimCountryIso(); // br
      String networkCountryCode = manager.getNetworkCountryIso();
      String simOperator = manager.getSimOperator(); // 72411
      String mcc = simOperator.substring(0, Math.min(simOperator.length(), 3)); // 724
      String mnc = simOperator.substring(Math.max(simOperator.length() - 2, 0)); // 11
      
      String origin = null;
      if (networkCountryCode != null){
        origin = "network";
      } else if (simCountryCode != null){
        origin = "sim";
      }
      
      JSONObject result = new JSONObject();

      result.put("carrierName", carrierName);
      result.put("networkName", networkName);
      result.put("simCountryCode", simCountryCode);
      result.put("networkCountryCode", networkCountryCode);
      result.put("mcc", mcc);
      result.put("mnc", mnc);
      
      if (origin != null){
        result.put("countryCodeOrigin", origin);
        if ("network".equals(origin)) {
          result.put("countryCode", networkCountryCode);
        }
        else if ("sim".equals(origin)){
          result.put("countryCode", simCountryCode);
        }
      }
      
      return result;
  }
  
  private static String getCountryCodeFromLatLng(Context context, double lat, double lng) throws IOException{
    Geocoder geocoder = new Geocoder(context);
    List<Address> addresses = geocoder.getFromLocation(lat, lng, 1);
    if (addresses.isEmpty())
        return null;
    return addresses.get(0).getCountryCode() != null ? addresses.get(0).getCountryCode().toLowerCase() : null;
  }
}
