var exec = require("cordova/exec");

module.exports = {
  verityApkSignature: function (packageName, apkPath, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "VerityApkSignature", "verityApkSignature", [
      packageName,
      apkPath,
    ]);
  },
  isProxy: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "VerityApkSignature", "isProxy");
  },
};
