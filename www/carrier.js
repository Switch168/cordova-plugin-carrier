var carrier = {
  getCarrierInfo: function (successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, 'Carrier', 'getCarrierInfo', []);
  },
  geocodeCountryCode: function (lat, lng, successCallback, errorCallback){
    cordova.exec(successCAllback, errorCallback, 'Carrier', 'geocodeCountryCode', [lat, lng]);
  }
}

cordova.addConstructor(function () {
  if (!window.plugins) {
    window.plugins = {};
  }

  window.plugins.carrier = carrier;
  return window.plugins.carrier;
});
