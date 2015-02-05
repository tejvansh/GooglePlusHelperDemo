# GPlusHelper
Google Plus Helper Class to integrate google plus signin and share feature easily.

If you haven’t created your Google Developers Console project, create it by following steps on following URL - https://developers.google.com/+/mobile/ios/getting-started

After creating console project, add the Helper and MBProgressHUD class to your project. 

In your app delegate .m file, import GooglePlus/GooglePlus.h.

Call the GPPURLHandler URL handler from your app delegate's URL handler. This handler will properly handle the URL that your application receives at the end of the authentication process.

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
 return [GPPURLHandler handleURL:url
               sourceApplication:sourceApplication
                      annotation:annotation];
}

Atlast, replace your project’s Client ID in the helper class.