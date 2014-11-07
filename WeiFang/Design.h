//
//  design.h
//  WeiFang
//
//  Created by Seven on 14-11-5.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//建材字段跟设计字段一样所有不再新建模型
//

#import <Foundation/Foundation.h>

@interface Design : NSObject

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *published;
@property (nonatomic, retain) NSString *content;

@property (nonatomic, retain) UIImage * imgData;

@end
