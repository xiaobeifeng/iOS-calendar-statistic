//
//  ViewController.m
//  CalendarStatistic
//
//  Created by ZhouJian on 2023/7/7.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
#import "CSJ2CConstant.h"

@interface ViewController()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) WKWebViewConfiguration* webViewConfiguration;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    _webViewConfiguration.userContentController = [WKUserContentController new];
    _webViewConfiguration.mediaTypesRequiringUserActionForPlayback = NO;
    _webViewConfiguration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    [_webViewConfiguration.userContentController addScriptMessageHandler:self name:j2c_getCalendars];
    [_webViewConfiguration.userContentController addScriptMessageHandler:self name:j2c_getCalendarEvent];
    WKPreferences* preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    _webViewConfiguration.preferences = preferences;
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:_webViewConfiguration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"dist/"];
    NSURL *pathURL = [NSURL fileURLWithPath:filePath];
//    NSString *localUrlString = [NSString stringWithFormat:@"http://192.168.3.56:8081"];
//    NSURL *pathURL = [NSURL URLWithString:localUrlString];
    [_webView loadRequest:[NSURLRequest requestWithURL:pathURL]];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

}

- (void)userContentController:(nonnull WKUserContentController *)userContentController
      didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if ([message.name isEqualToString:j2c_getCalendars]) {
        [self handleGetCalendars:message.body];
    }
    if ([message.name isEqualToString:j2c_getCalendarEvent]) {
        [self handleCalendarEvent:message.body];
    }
}

#pragma mark - didReceiveScriptMessage
- (void)handleGetCalendars:(NSDictionary *)body {
    __weak __typeof(self)weakSelf = self;
    [[CSCalendarStoreManager sharedManager] getCalendarsForEntityType:^(NSArray * _Nonnull calendars) {
        NSLog(@"%@", calendars);
        NSString *javaScript = kJ2CEvaluateJavaScript(j2c_callback4getCalendars, @{@"data": calendars});
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.webView evaluateJavaScript:javaScript completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                NSLog(@"value: %@ error: %@", response, error);
            }];
        });
    }];
    
//    NSLog(@"%@", body);
//    NSDictionary *dict = @{@"name": @"zhoujian"};

}

- (void)handleCalendarEvent:(NSDictionary *)body {
    [[CSCalendarStoreManager sharedManager] getCalendarEventWithCalendarIdentifier:body[@"id"] completion:^(NSDictionary * _Nonnull result) {
        NSLog(@"%@", result);
        __weak __typeof(self)weakSelf = self;
        NSString *javaScript = kJ2CEvaluateJavaScript(j2c_callback4getCalendarEvent, @{@"data": result});
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.webView evaluateJavaScript:javaScript completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                NSLog(@"value: %@ error: %@", response, error);
            }];
        });
    }];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
