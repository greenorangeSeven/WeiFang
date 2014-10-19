//
//  AppDelegate.h
//  QuJing
//
//  Created by Seven on 14-9-14.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckNetwork.h"
#import "MainPageView.h"
#import "StartView.h"
#import "StewardPageView.h"
#import "LifePageView.h"
#import "SettingView.h"
#import "CityPageView.h"
#import "ShoppingCartView.h"
#import "BMapKit.h"
#import <sys/xattr.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "BPush.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) MainPageView *mainPage;
@property (strong, nonatomic) StartView *startPage;
@property (nonatomic, assign) BOOL isFirst;

@end
