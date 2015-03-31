//
//  JianCaiDetailView.m
//  WeiFang
//
//  Created by Seven on 15/3/5.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "JianCaiDetailView.h"

@interface JianCaiDetailView ()

@end

@implementation JianCaiDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"详情";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"loadingpic4.png"]];
    imageView.imageURL = [NSURL URLWithString:self.good.thumb];
    imageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 213.0f);
    [self.picIv addSubview:imageView];
    
    self.priceLb.text = [NSString stringWithFormat:@"￥%@", self.good.price];
    self.titleLb.text = self.good.title;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    //    NSString *detailUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_getjcgoodinfo, appkey, self.good.id];
    NSMutableString *urlTemp = [[NSMutableString alloc] init];
    
    urlTemp = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_getjcgoodinfo, appkey, self.good.id];
    if([[UserModel Instance] isLogin])
    {
        [urlTemp appendString:[NSString stringWithFormat:@"&customer_id=%@", [[UserModel Instance] getUserValueForKey:@"id"]]];
    }
    NSString *detailUrl = [[NSString stringWithString:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [ NSURL URLWithString : detailUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSError *error = [request error ];
    assert (!error);
    goodDetail = [Tool readJsonStrToGoodsInfo:[request responseString]];
    
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    self.webView.delegate = self;
    NSString *html = [NSString stringWithFormat:@"<body>%@<div id='web_summary'>%@</div><div id='web_column'>%@</div><div id='web_body'>%@</div></body>", HTML_Style, goodDetail.summary, @"详情", goodDetail.content];
    NSString *result = [Tool getHTMLString:html];
    [self.webView loadHTMLString:result baseURL:nil];
    
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.webView.opaque = YES;
    for (UIView *subView in [self.webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            //            ((UIScrollView *)subView).bounces = YES;
            ((UIScrollView *)subView).scrollEnabled = NO;
        }
    }
    
    if (goodDetail.lingqu_status == 0) {
        [self.getBtn setTitle:@"领取优惠" forState:UIControlStateNormal];
        self.getBtn.enabled = YES;
    }
    else
    {
        [self.getBtn setTitle:@"已领取" forState:UIControlStateNormal];
        self.getBtn.enabled = NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewP
{
    if (hud != nil) {
        [hud hide:YES];
    }
    NSArray *arr = [webViewP subviews];
    UIScrollView *webViewScroll = [arr objectAtIndex:0];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, webViewP.frame.origin.y + [webViewScroll contentSize].height);
    [webViewP setFrame:CGRectMake(webViewP.frame.origin.x, webViewP.frame.origin.y, webViewP.frame.size.width, [webViewScroll contentSize].height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.webView stopLoading];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self viewWillAppear:animated];
//    if([[UserModel Instance] isLogin])
//    {
//        NSMutableString *urlTemp = [[NSMutableString alloc] init];
//        
//        urlTemp = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&id=%@&customer_id=%@", api_base_url, api_getjcgoodinfo, appkey, self.good.id, [[UserModel Instance] getUserValueForKey:@"id"]];
//        NSString *detailUrl = [[NSString stringWithString:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *url = [ NSURL URLWithString : detailUrl];
//        // 构造 ASIHTTPRequest 对象
//        ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
//        // 开始同步请求
//        [request startSynchronous ];
//        NSError *error = [request error ];
//        assert (!error);
//        goodDetail = [Tool readJsonStrToGoodsInfo:[request responseString]];
//        
//        if (goodDetail.lingqu_status == 0) {
//            [self.getBtn setTitle:@"领取优惠" forState:UIControlStateNormal];
//            self.getBtn.enabled = YES;
//        }
//        else
//        {
//            [self.getBtn setTitle:@"已领取" forState:UIControlStateNormal];
//            self.getBtn.enabled = NO;
//        }
//    }
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
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
    [request setPostValue:self.good.id forKey:@"id"];
    [request setPostValue:[[UserModel Instance] getUserValueForKey:@"id"] forKey:@"customer_id"];
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
    User *user = [Tool readJsonStrToUser:request.responseString];
    
    int errorCode = [user.status intValue];
    switch (errorCode) {
        case 1:
        {
            [Tool showCustomHUD:@"领取成功" andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:1];
            [self.getBtn setTitle:@"已领取" forState:UIControlStateDisabled];
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
