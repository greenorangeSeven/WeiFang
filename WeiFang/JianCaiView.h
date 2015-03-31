//
//  JianCaiView.h
//  WeiFang
//
//  Created by Seven on 15/3/5.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shop.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "BusinessCateCell.h"
#import "BusinessCell.h"
#import "BusinessDetailView.h"
#import "BusniessSearchView.h"

@interface JianCaiView : UIViewController<UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *shopData;
    NSMutableArray *shopCateData;
    MBProgressHUD *hud;
    NSString *catid;
    UILabel *noDataLabel;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *cateCollection;

@end
