//
//  NoticeFrameView.m
//  BeautyLife
//
//  Created by Seven on 14-8-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "NoticeFrameView.h"

@interface NoticeFrameView ()

@end

@implementation NoticeFrameView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"物业通知公告";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"head_back"] forState:UIControlStateNormal];
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
    //下属控件初始化
    self.noticeView = [[NewsTableView alloc] init];
    self.noticeView.catalog = 1;
    self.activityView = [[NewsTableView alloc] init];
    self.activityView.catalog = 2;
    self.activityView.view.hidden = YES;
    [self addChildViewController:self.noticeView];
    [self addChildViewController:self.activityView];
    [self.mainView addSubview:self.noticeView.view];
    [self.mainView addSubview:self.activityView.view];
    UserModel *usermodel = [UserModel Instance];
    if ([[usermodel getUserValueForKey:@"house_number"] isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提醒"
                                                     message:@"您的个人信息不完善，此功能暂不能使用，请完善个人信息！"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
        [av show];
    }
    
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (IBAction)noticeAction:(id)sender {
    [self.noticeBtn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
    [self.activityBtn setTitleColor:[UIColor scrollViewTexturedBackgroundColor] forState:UIControlStateNormal];
    self.noticeView.view.hidden = NO;
    self.activityView.view.hidden = YES;
}

- (IBAction)activityAction:(id)sender {
    [self.noticeBtn setTitleColor:[UIColor scrollViewTexturedBackgroundColor] forState:UIControlStateNormal];
    [self.activityBtn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
    self.noticeView.view.hidden = YES;
    self.activityView.view.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    UserModel *usermodel = [UserModel Instance];
    if ([[usermodel getUserValueForKey:@"house_number"] isEqualToString:@""] == NO)
    {
        [self.noticeView reloadType:1];
        [self.activityView reloadType:2];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UserInfoView *userinfoView = [[UserInfoView alloc] init];
        userinfoView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userinfoView animated:YES];
    }
}

@end
