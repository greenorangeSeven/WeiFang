//
//  JianCai2View.h
//  WeiFang
//
//  Created by Seven on 15/3/10.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSegmentedControl.h"
#import "MaterialsCate.h"
#import "MaterialsCollectionCell.h"
#import "TQImageCache.h"
#import "MWPhotoBrowser.h"

@interface JianCai2View : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,IconDownloaderDelegate, MWPhotoBrowserDelegate>
{
    NSMutableArray *cateArray;
    NSString *currentTypeId;
    
    NSMutableArray *materialsArray;
    
    TQImageCache * _iconCache;
    
    MBProgressHUD *hud;
    NSMutableArray *_photos;
}

@property (nonatomic, retain) NSMutableArray *photos;
@property (weak, nonatomic) NSString *typeName;
@property (weak, nonatomic) NSString *typeId;

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property (weak, nonatomic) IBOutlet UIScrollView *menuView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end