//
//  StewardPageView.m
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "StewardPageView.h"
#import "CommunityServiceView.h"
#import "JianCai2View.h"

@interface StewardPageView ()

@end

@implementation StewardPageView

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"智慧家居";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
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
    self.view.backgroundColor = [Tool getBackgroundColor];
    scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    [Tool roundView:self.telBg andCornerRadius:3.0];
    [self initMainADV];
}

- (void)initMainADV
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&spaceid=3", api_base_url, api_getadv, appkey];
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
                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 145) delegate:self imageItems:itemArray isAuto:NO];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    bannerView.delegate = self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bannerView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

- (IBAction)telAction:(id)sender{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", servicephone]];
    if (!phoneCallWebView)
    {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

- (IBAction)serviceAction:(id)sender
{
    CommunityServiceView *commView = [[CommunityServiceView alloc] init];
    commView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commView animated:YES];

}

- (IBAction)myDesignAction:(id)sender {
    MyDesignView *designView = [[MyDesignView alloc] init];
    designView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:designView animated:YES];
    
}

- (IBAction)jdAction:(id)sender {
//    MaterialsView *materialView = [[MaterialsView alloc] init];
//    materialView.typeId = @"4";
//    materialView.typeName = @"家电";
//    materialView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:materialView animated:YES];
    JianCai2View *jcView = [[JianCai2View alloc] init];
    jcView.typeId = @"3";
    jcView.typeName = @"家电";
    jcView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jcView animated:YES];
}

- (IBAction)jzgyAction:(id)sender {
    MaterialsView *materialView = [[MaterialsView alloc] init];
    materialView.typeId = @"16";
    materialView.typeName = @"家装工艺";
    materialView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:materialView animated:YES];
}

- (IBAction)yqAction:(id)sender {
    MaterialsView *materialView = [[MaterialsView alloc] init];
    materialView.typeId = @"43";
    materialView.typeName = @"装修公司";
    materialView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:materialView animated:YES];
}

- (IBAction)jcAction:(id)sender {
//    MaterialsView *materialView = [[MaterialsView alloc] init];
//    materialView.typeId = @"14";
//    materialView.typeName = @"建材";
//    materialView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:materialView animated:YES];
    JianCai2View *jcView = [[JianCai2View alloc] init];
    jcView.typeId = @"1";
    jcView.typeName = @"建材";
    jcView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jcView animated:YES];
}

- (IBAction)jjAction:(id)sender {
//    MaterialsView *materialView = [[MaterialsView alloc] init];
//    materialView.typeId = @"12";
//    materialView.typeName = @"家居";
//    materialView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:materialView animated:YES];
    JianCai2View *jcView = [[JianCai2View alloc] init];
    jcView.typeId = @"2";
    jcView.typeName = @"家居";
    jcView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jcView animated:YES];
}

- (IBAction)rzAction:(id)sender {
//    MaterialsView *materialView = [[MaterialsView alloc] init];
//    materialView.typeId = @"10";
//    materialView.typeName = @"软装";
//    materialView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:materialView animated:YES];
    JianCai2View *jcView = [[JianCai2View alloc] init];
    jcView.typeId = @"4";
    jcView.typeName = @"软装";
    jcView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jcView animated:YES];
}



@end
