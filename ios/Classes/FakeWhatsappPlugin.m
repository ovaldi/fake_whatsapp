#import "FakeWhatsappPlugin.h"

@implementation FakeWhatsappPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"v7lin.github.io/fake_whatsapp"
                                     binaryMessenger:[registrar messenger]];
    FakeWhatsappPlugin* instance = [[FakeWhatsappPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

static NSString * const METHOD_ISWHATSAPPINSTALLED = @"isWhatsappInstalled";
static NSString * const METHOD_SHARETEXT = @"shareText";
static NSString * const METHOD_SHAREIMAGE = @"shareImage";
static NSString * const METHOD_SHAREWEBPAGE = @"shareWebpage";

static NSString * const ARGUMENT_KEY_TEXT = @"text";
static NSString * const ARGUMENT_KEY_IMAGEURI = @"imageUri";
static NSString * const ARGUMENT_KEY_WEBPAGEURL = @"webpageUrl";

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([METHOD_ISWHATSAPPINSTALLED isEqualToString:call.method]) {
        result([NSNumber numberWithBool: [self isAppInstalled:@"whatsapp"]]);
    } else if ([METHOD_SHARETEXT isEqualToString:call.method]) {
        [self shareText:call result:result];
    } else if ([METHOD_SHAREIMAGE isEqualToString:call.method]) {
        [self shareImage:call result:result];
    } else if ([METHOD_SHAREWEBPAGE isEqualToString:call.method]) {
        [self shareWebpage:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void) shareText:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString * text = call.arguments[ARGUMENT_KEY_TEXT];
    NSURL * whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@", [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    result(nil);
}

- (void) shareImage:(FlutterMethodCall*)call result:(FlutterResult)result {
    UIViewController * topViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topViewController.presentedViewController != nil) {
        topViewController = topViewController.presentedViewController;
    }
    NSString * imageUri = call.arguments[ARGUMENT_KEY_IMAGEURI];
    NSURL * imageUrl = [NSURL URLWithString:imageUri];
    UIDocumentInteractionController * documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:imageUrl];
    documentInteractionController.UTI = @"net.whatsapp.image";
    [documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:topViewController.view animated: YES];
    result(nil);
}

- (void) shareWebpage:(FlutterMethodCall*)call result:(FlutterResult)result {
    UIViewController * topViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topViewController.presentedViewController != nil) {
        topViewController = topViewController.presentedViewController;
    }
    NSString * text = call.arguments[ARGUMENT_KEY_TEXT];
    NSString * webpageUrl = call.arguments[ARGUMENT_KEY_WEBPAGEURL];
    webpageUrl = [webpageUrl stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    webpageUrl = [webpageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    webpageUrl = [webpageUrl stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    webpageUrl = [webpageUrl stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    webpageUrl = [webpageUrl stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    webpageUrl = [webpageUrl stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    NSURL * whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@%@", [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [webpageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    result(nil);
}

// ---

- (BOOL) isAppInstalled:(NSString*)scheme{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", scheme]];
    return [[UIApplication sharedApplication] canOpenURL:url];
}

@end
