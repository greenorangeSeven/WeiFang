//
//  MainPageView.m
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "MainPageView.h"
#import "ConvView.h"
#import "RechargeView.h"
#import "SubtleView.h"
#import "BusinessView.h"
#import "CityView.h"

@interface MainPageView ()

@end

@implementation MainPageView

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"绘生活";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 31, 28)];
        [lBtn addTarget:self action:@selector(myAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"navi_my"] forState:UIControlStateNormal];
        UIBarButtonItem *btnMy = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnMy;
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 31, 28)];
        [rBtn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setImage:[UIImage imageNamed:@"navi_setting"] forState:UIControlStateNormal];
        UIBarButtonItem *btnSetting = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnSetting;
    }
    return self;
}

- (void)myAction
{
    [Tool pushToMyView:self.navigationController];
}

- (void)settingAction
{
    [Tool pushToSettingView:self.navigationController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //适配iOS7uinavigationbar遮挡tableView的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self initMainADV];
    [self getInBoxRemind];
}

- (void)initMainADV
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&spaceid=2", api_base_url, api_getadv, appkey];
        NSString *cid = [[UserModel Instance] getUserValueForKey:@"cid"];
        if (cid != nil && [cid length] > 0) {
            [tempUrl appendString:[NSString stringWithFormat:@"&cid=%@", cid]];
        }
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           advDatas = [Tool readJsonStrToADV:operation.responseString];
                                           
                                           int length = [advDatas count];
                                           //点赞按钮初始化
                                           Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
                                           [self.pointsBtn setTitle:[NSString stringWithFormat:@"点赞(%@)", adv.points] forState:UIControlStateNormal];
                                           
                                           NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                           if (length > 1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:length-1];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           for (int i = 0; i < length; i++)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:i];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                               
                                           }
                                           //添加第一张图 用于循环
                                           if (length >1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:0];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 177) delegate:self imageItems:itemArray isAuto:NO];
                                           [bannerView scrollToIndex:0];
                                           [self.advIv addSubview:bannerView];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           //                                           if (hud != nil) {
                                           //                                               [hud hide:YES];
                                           //                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

//顶部图片滑动点击委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title);
    Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    if (adv) {
        ADVDetailView *advDetail = [[ADVDetailView alloc] init];
        advDetail.hidesBottomBarWhenPushed = YES;
        advDetail.adv = adv;
        [self.navigationController pushViewController:advDetail animated:YES];
    }
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
    advIndex = index;
    Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    [self.pointsBtn setTitle:[NSString stringWithFormat:@"点赞( %@ )", adv.points] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    bannerView.delegate = self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bannerView.delegate = nil;
}

- (void)getInBoxRemind
{
    if ([[UserModel Instance] isLogin]) {
        //如果有网络连接
        if ([UserModel Instance].isNetworkRunning) {
            NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_getinboxremindy, appkey, [[UserModel Instance] getUserValueForKey:@"id"]];
            NSString *cid = [[UserModel Instance] getUserValueForKey:@"cid"];
            if (cid != nil && [cid length] > 0) {
                [tempUrl appendString:[NSString stringWithFormat:@"&cid=%@", cid]];
            }
            NSString *url = [NSString stringWithString:tempUrl];
            [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           @try {
                                               if (operation.responseString) {
                                                   [[UserModel Instance] saveValue:operation.responseString ForKey:@"inboxnum"];
                                               }
                                               
                                           }
                                           @catch (NSException *exception) {
                                               [NdUncaughtExceptionHandler TakeException:exception];
                                           }
                                           @finally {
                                               
                                           }
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           if ([UserModel Instance].isNetworkRunning == NO) {
                                               return;
                                           }
                                           if ([UserModel Instance].isNetworkRunning) {
                                               [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                           }
                                       }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}


- (IBAction)wytzAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    NoticeFrameView *noticeFrame = [[NoticeFrameView alloc] init];
    noticeFrame.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noticeFrame animated:YES];
}

- (IBAction)wybxAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    RepairsFrameView *repairsFrame = [[RepairsFrameView alloc] init];
    repairsFrame.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:repairsFrame animated:YES];
}

- (IBAction)sqltAction:(id)sender {
    ProjectCollectionView *bbsView = [[ProjectCollectionView alloc] init];
    bbsView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bbsView animated:YES];
}

- (IBAction)sqbsAction:(id)sender {
    if ([UserModel Instance].isLogin == NO)
    {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    ArticleView *artView = [[ArticleView alloc] init];
    artView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:artView animated:YES];
}

- (IBAction)wyjfAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    StewardFeeFrameView *feeFrame = [[StewardFeeFrameView alloc] init];
    feeFrame.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feeFrame animated:YES];
}

- (IBAction)kdsfAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    ExpressView *expressView = [[ExpressView alloc] init];
    expressView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:expressView animated:YES];
}

- (IBAction)fwznAction:(id)sender {
    CommunityView *communityView = [[CommunityView alloc] init];
    communityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:communityView animated:YES];
}

- (IBAction)wyfcAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    StewardNewsView *cityView = [[StewardNewsView alloc] init];
    cityView.typeStr = @"4";
    cityView.typeNameStr = @"物业风采";
    cityView.advId = @"11";
    cityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityView animated:YES];
}

- (IBAction)yzxzAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    StewardNewsView *cityView = [[StewardNewsView alloc] init];
    cityView.typeStr = @"5";
    cityView.typeNameStr = @"业主须知";
    cityView.advId = @"11";
    cityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityView animated:YES];
}

- (IBAction)glgyAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    StewardNewsView *cityView = [[StewardNewsView alloc] init];
    cityView.typeStr = @"6";
    cityView.typeNameStr = @"管理规约";
    cityView.advId = @"11";
    cityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityView animated:YES];
}


- (IBAction)shareAction:(id)sender {
    Advertisement *adv = [advDatas objectAtIndex:advIndex];
    NSString *shareStr = [Tool flattenHTML:adv.content];
    if (adv) {
        NSDictionary *contentDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    adv.title , @"title",
                                    adv.content, @"summary",
                                    adv.pic, @"thumb",
                                    nil];
        [Tool shareAction:sender andShowView:self.view andContent:contentDic];
    }
}



- (IBAction)advDetailAction:(id)sender {
    Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    if (adv) {
        ADVDetailView *advDetail = [[ADVDetailView alloc] init];
        advDetail.hidesBottomBarWhenPushed = YES;
        advDetail.adv = adv;
        [self.navigationController pushViewController:advDetail animated:YES];
    }
}

- (IBAction)myDesignAction:(id)sender {
    MyDesignView *designView = [[MyDesignView alloc] init];
    designView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:designView animated:YES];
    
}

- (IBAction)pointsAction:(id)sender {
    Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    if (adv) {
        NSString *pointslUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&model=poster&id=%@", api_base_url, api_points, appkey, adv.id];
        NSURL *url = [ NSURL URLWithString : pointslUrl];
        // 构造 ASIHTTPRequest 对象
        ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
        // 开始同步请求
        [request startSynchronous ];
        NSError *error = [request error ];
        assert (!error);
        // 如果请求成功，返回 Response
        NSString *response = [request responseString ];
        NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSString *status = @"0";
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if (json) {
            status = [json objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                adv.points = [NSString stringWithFormat:@"%d", [adv.points intValue] + 1];
                [self.pointsBtn setTitle:[NSString stringWithFormat:@"点赞( %@ )", adv.points] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

@end
