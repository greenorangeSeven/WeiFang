//
//  MaterialsDetailView.h
//  WeiFang
//
//  Created by Seven on 15/4/2.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialsDetailView : UIViewController
{
    UIWebView *phoneCallWebView;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) Design *design;
@property (weak, nonatomic) IBOutlet UILabel *hitLb;
- (IBAction)telAction:(id)sender;

@end
