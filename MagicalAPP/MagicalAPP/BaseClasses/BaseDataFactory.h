//
//  BaseDataFactory.h
//  MagicalAPP
//
//  Created by 魏朋 on 16/8/20.
//  Copyright © 2016年 魏朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactoryType.h"


@class BaseDataFactory;
@protocol BaseDataFactoryDelegate <NSObject>
- (void)dataFactory:(BaseDataFactory * _Nonnull)factory successFetchRawData:(id _Nullable)rawData ofClass:(Class _Nonnull)cls withDataTask:(NSURLSessionDataTask  * _Nullable )task;
- (void)dataFactory:(BaseDataFactory * _Nonnull)factory failureFetchRawData:(NSError  * _Nonnull)error ofClass:(Class _Nonnull)cls withDataTask:(NSURLSessionDataTask  * _Nullable)task;
@end


@class AFHTTPSessionManager;
@interface BaseDataFactory : NSObject
@property (nonatomic, weak, nullable) id<BaseDataFactoryDelegate> delegate;

- (instancetype _Nonnull)initWithDataRegistry:(NSMutableDictionary * _Nullable)dataReg;

- (void)registerDataClass:(Class _Nonnull)cls urlstring:(NSString * _Nonnull)urlstring
        precastParameters:(NSDictionary * _Nullable)precastParameters
              withKeyPath:(NSString * _Nullable)keyPath
              fetchMethod:(DataFactoryFetchMethod)fetchMethod
                 transfer:(TransferBlockType _Nullable)transfer;

- (void)setupRegistry;

- (void)fetchRawDataOfClass:(Class _Nonnull)cls WithParameters:(NSDictionary * _Nonnull)params dataSuccess:(DataSuccessBlockType _Nullable)dataSuccess dataFailure:(DataFailureBlockType _Nullable)dataFailure;
//- (BOOL)fetchRawHeaderWithParameters:(NSDictionary * _Nonnull)params;
@end
