//
//  StartView.m
//  DianLiangCity
//
//  Created by Seven on 14-9-29.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "StartView.h"
#import "AppDelegate.h"
#import "MainPageView.h"
#import "SMPageControl.h"

@interface StartView ()
{
    UIImageView *_imageView;
    NSArray *_permissions;
    int GlobalPageControlNumber;
    
    SMPageControl *_pageControl;
}

@end

@implementation StartView

#define KSCROLLVIEW_WIDTH [UIScreen mainScreen].applicationFrame.size.width

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.intoButton.hidden = YES;
    [self buildUI];
    [self createScrollView];
}

#pragma mark - privite method
#pragma mark
- (void)buildUI
{
    _pageControl = [[SMPageControl alloc] init];
    _pageControl.frame = CGRectMake(120, (IS_IPHONE_5?492:404), 80, 37);
    _pageControl.pageIndicatorImage = [UIImage imageNamed:@"pagecontrol"];
    _pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"pagecontrol_h"];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    [self.view addSubview:_pageControl];
    [self.view bringSubviewToFront:_pageControl];
}
#pragma mark createScrollView
-(void)createScrollView
{
    self.scrollView.delegate=self;
    self.scrollView.contentSize=CGSizeMake(KSCROLLVIEW_WIDTH*3, 0);
//    NSLog([NSString stringWithFormat:@"%d", self.scrollView.frame.size])
    for (int i=0; i<3; i++) {
        UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*KSCROLLVIEW_WIDTH, 0, KSCROLLVIEW_WIDTH, self.scrollView.frame.size.height)];
        NSString *str = [NSString stringWithFormat:@"v引导_%d.png",i+1];
        photoImageView.image=[UIImage imageNamed:str];
        [photoImageView setContentMode:UIViewContentModeTop];
        [self.scrollView addSubview:photoImageView];
    }
}

#pragma mark - scrollView delegate Method
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentOffset.x >= KSCROLLVIEW_WIDTH*4) {
        scrollView.contentOffset = CGPointMake(KSCROLLVIEW_WIDTH*4, 0);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    GlobalPageControlNumber = scrollView.contentOffset.x/KSCROLLVIEW_WIDTH;
    _pageControl.currentPage=GlobalPageControlNumber;
    if (GlobalPageControlNumber == 2)
    {
        self.intoButton.hidden = NO;
    }
    else
    {
        self.intoButton.hidden = YES;
    }
}

- (IBAction)enterAction:(id)sender
{
    MainPageView *mainPage = [[MainPageView alloc] initWithNibName:@"MainPageView" bundle:nil];
    UINavigationController *mainPageNav = [[UINavigationController alloc] initWithRootViewController:mainPage];
    self.intoButton.hidden = YES;
    AppDelegate *appdele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [UIView transitionWithView:appdele.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        appdele.window.rootViewController = mainPageNav;
                    }
                    completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
