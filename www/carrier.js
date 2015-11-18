var carrier = {
  getCarrierInfo: function (successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, 'Carrier', 'getCarrierInfo', []);
  },
  geocodeCountryCode: function (params, successCallback, errorCallback){
    cordova.exec(successCallback, errorCallback, 'Carrier', 'geocodeCountryCode', params);
  }
}

cordova.addConstructor(function () {
  if (!window.plugins) {
    window.plugins = {};
  }

  window.plugins.carrier = carrier;
  return window.plugins.carrier;
});
