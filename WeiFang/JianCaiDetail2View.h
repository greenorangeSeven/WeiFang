//
//  JianCaiDetail2View.h
//  WeiFang
//
//  Created by Seven on 15/3/10.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JianCaiDetail2View : UIViewController<UIActionSheetDelegate>
{
    MBProgressHUD *hud;
    UIWebView *phoneCallWebView;
}

@property (weak, nonatomic) NSString *typeId;
@property (weak, nonatomic) Shop *shop;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;

- (IBAction)getAction:(id)sender;
- (IBAction)telAction:(id)sender;

@end
