//
//  MyRebateView.m
//  WeiFang
//
//  Created by Seven on 15/3/25.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "MyRebateView.h"
#import "MyRebateCell.h"
#import "Shop.h"

@interface MyRebateView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *codeData;
    MBProgressHUD *hud;
}

@end

@implementation MyRebateView

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text = @"我的返利码";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [lBtn setImage:[UIImage imageNamed:@"head_back"] forState:UIControlStateNormal];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    //加载缴费历史记录
    [self loadData];
}

#pragma mark 获取缴费历史记录集合
- (void)loadData{
    UserModel *usermodel = [UserModel Instance];
    //如果有网络连接
    if (usermodel.isNetworkRunning) {
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&customer_id=%@", api_base_url, api_getLingquShop, appkey,[usermodel getUserValueForKey:@"id"]];
        
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [codeData removeAllObjects];
                                       @try {
                                           codeData = [Tool readJsonStrToShopArray:operation.responseString];
                                           if(codeData.count == 0)
                                           {
                                               [Tool showCustomHUD:@"您暂未领取返利码" andView:self.view andImage:nil andAfterDelay:2];                                         }
                                           else
                                           {
                                               [self.tableView reloadData];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return codeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRebateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyRebateCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyRebateCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MyRebateCell class]]) {
                cell = (MyRebateCell *)o;
                break;
            }
        }
    }
    Shop *s = [codeData objectAtIndex:indexPath.row];
    cell.titleLb.text = s.title;
    cell.codeLb.text = [NSString stringWithFormat:@"返利码:%@", s.suiji_code];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
