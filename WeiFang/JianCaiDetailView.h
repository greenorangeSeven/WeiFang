//
//  JianCaiDetailView.h
//  WeiFang
//
//  Created by Seven on 15/3/5.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface JianCaiDetailView : UIViewController<UIWebViewDelegate, UIActionSheetDelegate>
{
    Goods *goodDetail;
    MBProgressHUD *hud;
}

@property (weak, nonatomic) Goods *good;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *picIv;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;

- (IBAction)getAction:(id)sender;

@end