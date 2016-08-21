//
//  TouTiaoModel.h
//  MagicalAPP
//
//  Created by 魏朋 on 16/8/21.
//  Copyright © 2016年 魏朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouTiaoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *author_name;
@property (nonatomic, strong) NSURL *thumbnail_pic_s;
@property (nonatomic, strong) NSURL *thumbnail_pic_so2;
@property (nonatomic, strong) NSURL *thumbnail_pic_so3;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) long long uniquekey;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *realtype;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
+ (NSArray *)modelsWithArray:(NSArray *)objects;
@end
