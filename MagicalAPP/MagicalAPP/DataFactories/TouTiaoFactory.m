//
//  TouTiaoFactory.m
//  MagicalAPP
//
//  Created by 魏朋 on 16/8/21.
//  Copyright © 2016年 魏朋. All rights reserved.
//

#import "TouTiaoFactory.h"

@interface TouTiaoFactory() <BaseDataFactoryDelegate>

@end

@implementation TouTiaoFactory

- (void)setupRegistry{
    [super setupRegistry];
    // 头条新闻
    [self registerDataClass:NSClassFromString(@"TouTiaoModel")
                  urlstring:@"http://v.juhe.cn/toutiao/index"
          precastParameters:@{@"key": @"ffd1762fd6eec6929c807522bb681fc2"}
                withKeyPath:@"{result}.{data}"
                fetchMethod:DataFactoryFetchMethodGet transfer:nil];
    // 天气信息 03bf2aa170b4a56b2439fa983c4dc5a7
    
}




+ (instancetype)factory{
    TouTiaoFactory *factory = [[TouTiaoFactory alloc] init];
    factory.delegate = factory;
    [factory setupRegistry];
    return factory;
}

#pragma mark - BaseDataFactory Delegate
- (void)dataFactory:(BaseDataFactory *)factory successFetchRawData:(id)rawData ofClass:cls withDataTask:(NSURLSessionDataTask *)task{
    NSLog(@"%@", rawData);
}
- (void)dataFactory:(BaseDataFactory *)factory failureFetchRawData:(NSError *)error ofClass:cls withDataTask:(NSURLSessionDataTask *)task{
    NSLog(@"%@", error);
}
@end
