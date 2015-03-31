//
//  JianCaiDetail2View.m
//  WeiFang
//
//  Created by Seven on 15/3/10.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "JianCaiDetail2View.h"

@interface JianCaiDetail2View ()

@end

@implementation JianCaiDetail2View

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = self.shop.name;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
//        [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    NSString *html = [NSString stringWithFormat:@"<body>%@<meta name='viewport' content='width=decice-width,uer-scalable=no'><div id='web_body'><img src='%@' width='303'/></div><div id='web_body'>%@</div></body>", HTML_Style, self.shop.logo, self.shop.summary];
    NSString *result = [Tool getHTMLString:html];
    [self.webView loadHTMLString:result baseURL:nil];
    
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self isLingQu];
}

//取数方法
- (void)isLingQu
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSMutableString *urlTemp = [[NSMutableString alloc] init];
        
        urlTemp = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&id=%@&type=%@", api_base_url, api_islingqu, appkey, self.shop.id, self.typeId];
        if([[UserModel Instance] isLogin])
        {
            [urlTemp appendString:[NSString stringWithFormat:@"&customer_id=%@", [[UserModel Instance] getUserValueForKey:@"id"]]];
        }
        NSString *url = [[NSString stringWithString:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       @try {
//                                           shopCateData = [Tool readJsonStrToShopsCate:operation.responseString];
//                                           [self.cateCollection reloadData];
                                           if (![operation.responseString isEqualToString:@"1"]) {
                                               [self.getBtn setTitle:@"领返利码" forState:UIControlStateNormal];
                                               self.getBtn.enabled = YES;
                                           }
                                           else
                                           {
                                               [self.getBtn setTitle:@"已领取" forState:UIControlStateNormal];
                                               self.getBtn.enabled = NO;
                                           }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)telAction:(id)sender{
    if (self.shop.tel.length > 0) {
        NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.shop.tel]];
        if (!phoneCallWebView)
        {
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
    }
}

- (IBAction)getAction:(id)sender
{
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    
    self.getBtn.enabled = NO;
    NSString *getUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_jclingqu];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:getUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:self.shop.id forKey:@"id"];
    [request setPostValue:[[UserModel Instance] getUserValueForKey:@"id"] forKey:@"customer_id"];
    [request setPostValue:self.typeId forKey:@"type"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestGet:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在提交" andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
}

- (void)requestGet:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    NSLog(@"%@", request.responseString);
    User *user = [Tool readJsonStrToUser:request.responseString];
    
    int errorCode = [user.status intValue];
    switch (errorCode) {
        case 1:
        {
            [Tool showCustomHUD:@"领取成功" andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:1];
            [self.getBtn setTitle:@"已领取" forState:UIControlStateDisabled];
            
            NSMutableString *msgTemp = [[NSMutableString alloc] init];
            msgTemp = [NSMutableString stringWithFormat:@"已成功领取绘生活返利码%@", user.suiji_code];
            [msgTemp appendString:@"，可在“我的返利码”中查看，您在前往商家店面自主议价后确定最终价格，再出示返利码给商家凭收据或发票联系绘生活可获得领取返利5%的现金。"];
            NSString *msg = [NSString stringWithString:msgTemp];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"恭喜您" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
            break;
        case 2:
        {
            [Tool showCustomHUD:@"领取失败" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
            self.getBtn.enabled = YES;
        }
            break;
        case 3:
        {
            [Tool showCustomHUD:@"已领取" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
            [self.getBtn setTitle:@"已领取" forState:UIControlStateDisabled];
            self.getBtn.enabled = NO;
        }
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
