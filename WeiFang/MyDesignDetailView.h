//
//  MyDesignDetailView.h
//  WeiFang
//
//  Created by Seven on 14-11-5.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDesignDetailView : UIViewController
{
    Design *design;
}

@property (weak, nonatomic) NSString *desId;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
