//
//  StewardNewsView.h
//  WeiFang
//
//  Created by Seven on 14-11-4.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "TQImageCache.h"
#import "CityCell.h"
#import "ADVDetailView.h"
#import "NewsDetailView.h"

@interface StewardNewsView : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate,IconDownloaderDelegate,SGFocusImageFrameDelegate, UIAlertViewDelegate>
{
    NSMutableArray *news;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    BOOL isInitialize;
    TQImageCache * _iconCache;
    
    UIWebView *phoneCallWebView;
    
    MBProgressHUD *hud;
    
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *advIv;

@property (weak, nonatomic) NSString *advId;
@property (weak, nonatomic) NSString *typeStr;
@property (weak, nonatomic) NSString *typeNameStr;

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
