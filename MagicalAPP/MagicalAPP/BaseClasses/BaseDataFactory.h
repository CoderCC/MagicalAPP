//
//  BaseDataFactory.h
//  MagicalAPP
//
//  Created by 魏朋 on 16/8/20.
//  Copyright © 2016年 魏朋. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DataFactoryFetchMethod) {
    DataFactoryFetchMethodGet = 1,
    DataFactoryFetchMethodPost,
};

@class AFHTTPSessionManager;
@interface BaseDataFactory : NSObject
@property (nonatomic, copy, nonnull) NSString *urlstring;
@property (nonatomic, assign) DataFactoryFetchMethod  fetchMethod;
@property (nonatomic, strong, nullable) NSDictionary *authorization;
@property (nonatomic, strong, nonnull) AFHTTPSessionManager *manager;

- (instancetype _Nonnull)initWithURLString:(NSString * _Nonnull)urlstring authorization:(NSDictionary * _Nullable)auths fetchMethod:(DataFactoryFetchMethod)method;
+ (instancetype _Nonnull)factoryWithURLString:(NSString * _Nonnull)urlstring authorization:(NSDictionary *_Nullable)auths fetchMethod:(DataFactoryFetchMethod)method;


- (BOOL)fetchRawDataWithParameters:(NSDictionary * _Nonnull)params;
- (BOOL)fetchRawHeaderWithParameters:(NSDictionary * _Nonnull)params;
- (NSDictionary * _Nonnull)fetchParameters:(NSDictionary * _Nonnull)params;
@end


@protocol BaseDataFactoryDelegate <NSObject>

- (void)dataFactory:(BaseDataFactory * _Nonnull)factory successFetchRawData:(id _Nullable)rawData withDataTask:(NSURLSessionDataTask  * _Nullable )task;
- (void)dataFactory:(BaseDataFactory * _Nonnull)factory failureFetchRawData:(NSError  * _Nonnull)error withDataTask:(NSURLSessionDataTask  * _Nullable)task;

//- (void)dataFactory:(BaseDataFactory *)factory successFetchRawHeader:(id)rawHeader withDataTask:()
@end

@interface BaseDataFactory(BaseDataFactoryDelegate)
@property (nonatomic, weak, nullable) id<BaseDataFactoryDelegate> delegate;
@end