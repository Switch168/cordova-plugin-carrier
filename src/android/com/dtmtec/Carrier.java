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

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("getCarrierInfo")) {
      Context context = this.cordova.getActivity().getApplicationContext();

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
        switch (origin) {
          case "network" : 
            result.put("countryCode", networkCountryCode);
            break;
          case "sim" : 
            result.put("countryCode", simCountryCode);
            break;
        }
      }

      callbackContext.success(result);

      return true;
    } else {
      return false;
    }
  }
}
