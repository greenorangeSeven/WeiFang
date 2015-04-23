//
//  MaterialsDetailView.m
//  WeiFang
//
//  Created by Seven on 15/4/2.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "MaterialsDetailView.h"
#import "Design.h"

@interface MaterialsDetailView ()

@end

@implementation MaterialsDetailView

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
    titleLabel.text = self.design.title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    self.hitLb.text = [NSString stringWithFormat:@"浏览量:%@", self.design.hits];
    
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //        [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    NSString *html = [NSString stringWithFormat:@"<body>%@<meta name='viewport' content='width=decice-width,uer-scalable=no'><div id='web_body'><img src='%@' width='303'/></div><div id='web_body'>%@<br>%@</div></body>", HTML_Style, self.design.thumb, self.design.summary,self.design.content];
    NSString *result = [Tool getHTMLString:html];
    [self.webView loadHTMLString:result baseURL:nil];
    
    [self setHits];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//取数方法
- (void)setHits
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSMutableString *urlTemp = [[NSMutableString alloc] init];
        urlTemp = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_getjcinfo, appkey, self.design.id];
        NSString *url = [[NSString stringWithString:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       @try {
                                           NSLog(@"222");
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)telAction:(id)sender {
    if (self.design.phone.length > 0) {
        NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.design.phone]];
        if (!phoneCallWebView)
        {
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
    }
}
@end
