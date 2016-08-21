//
//  BaseDataFactory.m
//  MagicalAPP
//
//  Created by 魏朋 on 16/8/20.
//  Copyright © 2016年 魏朋. All rights reserved.
//

#import "BaseDataFactory.h"
#import <AFNetworking.h>

@implementation BaseDataFactory

- (AFHTTPSessionManager *)manager{
    if (nil == _manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (NSDictionary *)fetchParameters:(NSDictionary *)params{
    NSMutableDictionary *ps = [[NSMutableDictionary alloc] initWithDictionary:self.authorization];
    [ps addEntriesFromDictionary:params];
    return ps;
}

- (BOOL)fetchRawDataWithParameters:(NSDictionary *)params{
    
    __weak typeof(self) w_self;
    switch (_fetchMethod) {
        case DataFactoryFetchMethodGet:{
            [self.manager GET:self.urlstring parameters:[self fetchParameters:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong typeof(w_self) s_self;
                if([s_self.delegate respondsToSelector:@selector(dataFactory:successFetchRawData:withDataTask:)])
                   [s_self.delegate dataFactory:s_self successFetchRawData:responseObject withDataTask:task];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong typeof(w_self) s_self;
                if([s_self.delegate respondsToSelector:@selector(dataFactory:failureFetchRawData:withDataTask:)])
                   [s_self.delegate dataFactory:s_self failureFetchRawData:error withDataTask:task];
            }];
        } break;
        case DataFactoryFetchMethodPost:{
            [self.manager POST:self.urlstring parameters:[self fetchParameters:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong typeof(w_self) s_self;
                if([s_self.delegate respondsToSelector:@selector(dataFactory:successFetchRawData:withDataTask:)])
                    [s_self.delegate dataFactory:s_self successFetchRawData:responseObject withDataTask:task];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong typeof(w_self) s_self;
                if([s_self.delegate respondsToSelector:@selector(dataFactory:failureFetchRawData:withDataTask:)])
                    [s_self.delegate dataFactory:s_self failureFetchRawData:error withDataTask:task];
            }];
        } break;
    }
    
    return YES;
}

- (instancetype)initWithURLString:(NSString *)urlstring authorization:(NSDictionary *)auths fetchMethod:(DataFactoryFetchMethod)method{
    self = [super init];
    if (self) {
        self.urlstring = urlstring;
        self.authorization = auths;
        self.fetchMethod = method;
    }
    return self;
}

+ (instancetype)factoryWithURLString:(NSString *)urlstring authorization:(NSDictionary *)auths fetchMethod:(DataFactoryFetchMethod)method{
    return [[self alloc] initWithURLString:urlstring authorization:auths fetchMethod:method];
}

@end
