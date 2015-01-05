//
//  MaterialsView.m
//  WeiFang
//
//  Created by Seven on 14-11-5.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "MaterialsView.h"

@interface MaterialsView ()

@end

@implementation MaterialsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
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
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[MaterialsCollectionCell class] forCellWithReuseIdentifier:@"MaterialsCollectionCellIdentifier"];
    self.collectionView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = self.typeName;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initMenu];
}

- (void)initMenu
{
    //如果有网络连接
    [Tool showHUD:@"加载中" andView:self.view andHUD:hud];
    if ([UserModel Instance].isNetworkRunning) {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&pid=%@", api_base_url, api_jccate, appkey, self.typeId];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           cateArray = [Tool readJsonStrToJCCate:operation.responseString];
                                           if ([cateArray count] > 0) {
                                               NSMutableArray *typeData = [[NSMutableArray alloc] init];
                                               int menuWidth = 0;
                                               for (MaterialsCate *m in cateArray) {
                                                   [typeData addObject:m.name];
                                                   m.nameWidth = [Tool getTextWidth:m.name andUIFont:14] + 30;
                                                   menuWidth += m.nameWidth;
                                               }
                                               
                                               CCSegmentedControl* segmentedControl = [[CCSegmentedControl alloc] initWithItems:typeData];
                                               segmentedControl.frame = CGRectMake(0, 0, menuWidth , 42);
                                               
                                               segmentedControl.backgroundColor = [UIColor clearColor];
                                               
                                               //阴影部分图片，不设置使用默认椭圆外观的stain
                                               segmentedControl.selectedStainView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cc_btypebg.png"]];
                                               
                                               segmentedControl.selectedSegmentTextColor = [UIColor whiteColor];
                                               segmentedControl.segmentTextColor = [UIColor blackColor];
                                               [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
                                               [self.menuView addSubview:segmentedControl];
                                               [self.menuView setContentSize:CGSizeMake(menuWidth, self.menuView.bounds.size.height)];
                                               MaterialsCate *cate = [cateArray objectAtIndex:0];
                                               currentTypeId = cate.id;
                                               [self reloadMaterials];
                                           }
                                           else
                                           {
                                               [Tool showCustomHUD:@"暂无数据" andView:self.view  andImage:@"" andAfterDelay:2];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               hud.hidden = YES;
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

- (void)valueChanged:(id)sender
{
    CCSegmentedControl* segmentedControl = sender;
    int typeIndex = segmentedControl.selectedSegmentIndex;
    MaterialsCate *cate = [cateArray objectAtIndex:typeIndex];
    currentTypeId = cate.id;
    [self reloadMaterials];
}

//取数方法
- (void)reloadMaterials
{
    [Tool showHUD:@"加载中" andView:self.view andHUD:hud];
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&catid=%@", api_base_url, api_jclist, appkey, currentTypeId];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [self clear];
                                       @try {
                                           materialsArray = [Tool readJsonStrToDesigns:operation.responseString];
                                           if ([materialsArray count] == 0) {
                                               [Tool showCustomHUD:@"暂无数据" andView:self.view  andImage:@"" andAfterDelay:2];
                                           }
                                           [self.collectionView reloadData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               hud.hidden = YES;
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

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [materialsArray count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MaterialsCollectionCellIdentifier" forIndexPath:indexPath];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MaterialsCollectionCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MaterialsCollectionCell class]]) {
                cell = (MaterialsCollectionCell *)o;
                break;
            }
        }
    }
    int indexRow = [indexPath row];
    Design *cate = [materialsArray objectAtIndex:indexRow];
    
    
    
    if (cate.imgData) {
        cell.picIv.image = cate.imgData;
    }
    else
    {
        if ([cate.thumb isEqualToString:@""]) {
            cate.imgData = [UIImage imageNamed:@"loadpic2"];
        }
        else
        {
            NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:cate.thumb]];
            if (imageData)
            {
                cate.imgData = [UIImage imageWithData:imageData];
                cell.picIv.image = cate.imgData;
            }
            else
            {
                IconDownloader *downloader = [_imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                if (downloader == nil) {
                    ImgRecord *record = [ImgRecord new];
                    record.url = cate.thumb;
                    [self startIconDownload:record forIndexPath:indexPath];
                }
            }
        }
        
    }
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(106, 129);
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.photos count] == 0) {
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        for (Design *d in materialsArray) {
            MWPhoto * photo = [MWPhoto photoWithURL:[NSURL URLWithString:d.thumb]];
            NSString *cleanString = [d.summary stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            photo.tel = cleanString;
            [photos addObject:photo];
        }
        self.photos = photos;
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = YES;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
//    browser.wantsFullScreenLayout = YES;//是否全屏
    browser.displayTelButton = YES;
    [browser setCurrentPhotoIndex:[indexPath row]];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:browser animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma 下载图片
- (void)startIconDownload:(ImgRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%d",[indexPath row]];
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:key];
    if (iconDownloader == nil) {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imgRecord = imgRecord;
        iconDownloader.index = key;
        iconDownloader.delegate = self;
        [_imageDownloadsInProgress setObject:iconDownloader forKey:key];
        [iconDownloader startDownload];
    }
}

- (void)appImageDidLoad:(NSString *)index
{
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:index];
    if (iconDownloader)
    {
        int _index = [index intValue];
        if (_index >= [materialsArray count])
        {
            return;
        }
        Design *c = [materialsArray objectAtIndex:[index intValue]];
        if (c) {
            c.imgData = iconDownloader.imgRecord.img;
            // cache it
            NSData * imageData = UIImagePNGRepresentation(c.imgData);
            [_iconCache putImage:imageData withName:[TQImageCache parseUrlForCacheName:c.thumb]];
            [self.collectionView reloadData];
        }
    }
}

#pragma 生命周期
- (void)viewDidUnload
{
    [self setCollectionView:nil];
    [materialsArray removeAllObjects];
    [_imageDownloadsInProgress removeAllObjects];
    materialsArray = nil;
    _iconCache = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    //清空
    for (Design *c in materialsArray) {
        c.imgData = nil;
    }
    
    [super didReceiveMemoryWarning];
}

- (void)clear
{
    [self.photos removeAllObjects];
    [materialsArray removeAllObjects];
    [_imageDownloadsInProgress removeAllObjects];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.imageDownloadsInProgress != nil) {
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    }
}

//MWPhotoBrowserDelegate委托事件
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

@end
