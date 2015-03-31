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
#import "DataVerifier.h"
#import "BPush.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate, BPushDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) MainPageView *mainPage;
@property (strong, nonatomic) StartView *startPage;
@property (strong, nonatomic) StewardPageView *stewardPage;
@property (strong, nonatomic) LifePageView *lifePage;
@property (strong, nonatomic) CityPageView *cityPage;
@property (nonatomic, assign) BOOL isFirst;

@end
