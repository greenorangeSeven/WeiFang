//
//  MainPageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StewardFeeFrameView.h"
#import "RepairsFrameView.h"
#import "NoticeFrameView.h"
#import "ExpressView.h"
#import "LawView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ADVDetailView.h"

#import "StewardPageView.h"
#import "CommunityView.h"
#import "ProjectCollectionView.h"
#import "VolunteerView.h"


@interface MainPageView : UIViewController<SGFocusImageFrameDelegate, UIActionSheetDelegate>
{
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
    
    MBProgressHUD *hud;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *pointsBtn;
@property (weak, nonatomic) IBOutlet UIImageView *advIv;

- (IBAction)shareAction:(id)sender;
- (IBAction)advDetailAction:(id)sender;
- (IBAction)pointsAction:(id)sender;

#pragma mark -按钮点击事件
- (IBAction)wytzAction:(id)sender;
- (IBAction)wybxAction:(id)sender;
- (IBAction)sqltAction:(id)sender;
- (IBAction)sqbsAction:(id)sender;
- (IBAction)wyjfAction:(id)sender;
- (IBAction)kdsfAction:(id)sender;

@end
