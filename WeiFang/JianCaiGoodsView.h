//
//  JianCaiGoodsView.h
//  WeiFang
//
//  Created by Seven on 15/3/5.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JianCaiGoodsView : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIWebView *phoneCallWebView;
    NSMutableArray *goods;
    MBProgressHUD *hud;
}

@property (weak, nonatomic) Shop *shop;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
