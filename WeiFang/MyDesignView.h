//
//  MyDesignView.h
//  WeiFang
//
//  Created by Seven on 14-11-5.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDesignCell.h"
#import "TQImageCache.h"
#import "Design.h"
#import "MyDesignDetailView.h"

@interface MyDesignView : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate,IconDownloaderDelegate>
{
    NSMutableArray *designArray;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    BOOL isInitialize;
    TQImageCache * _iconCache;
    
    MBProgressHUD *hud;
    
}

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

