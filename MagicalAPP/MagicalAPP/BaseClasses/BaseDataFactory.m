//
//  BaseDataFactory.m
//  MagicalAPP
//
//  Created by 魏朋 on 16/8/20.
//  Copyright © 2016年 魏朋. All rights reserved.
//

#import "BaseDataFactory.h"
#import <AFNetworking.h>

@interface DataFactoryRegEntry : NSObject
// 请求相关
@property (nonatomic, copy, nonnull) NSString *urlstring;
@property (nonatomic, copy, nullable) NSDictionary *precastParameters;
@property (nonatomic, copy, nullable) NSString *keyPath;
@property (nonatomic) DataFactoryFetchMethod fatchMethod;
// 模型相关
@property (nonatomic, copy, nonnull) NSString *className;
@property (nonatomic, copy) TransferBlockType transferBlock;

- (instancetype)initWithClass:(Class)cls
                    urlstring:(NSString *)urlstring
            precastParameters:(NSDictionary *)precastParameters
                      keyPath:(NSString *)keyPath
                  fetchMethod:(DataFactoryFetchMethod)fetchMethod
                     transfer:(TransferBlockType)transfer;

+ (instancetype)regEntryWithClass:(Class)cls
                        urlstring:(NSString *)urlstring
                precastParameters:(NSDictionary *)precastParameters
                          keyPath:(NSString *)keyPath
                      fetchMethod:(DataFactoryFetchMethod)fetchMethod
                         transfer:(TransferBlockType)transfer;

- (NSDictionary *)fetchParameters:(NSDictionary *)params;

@end

@implementation DataFactoryRegEntry
- (instancetype)initWithClass:(Class)cls
                    urlstring:(NSString *)urlstring
            precastParameters:(NSDictionary *)precastParameters
                      keyPath:(NSString *)keyPath
                  fetchMethod:(DataFactoryFetchMethod)fetchMethod
                     transfer:(TransferBlockType)transfer{
    self = [super init];
    if (self) {
        self.className = NSStringFromClass(cls);
        self.urlstring = urlstring;
        self.precastParameters = precastParameters;
        self.keyPath = keyPath;
        self.transferBlock = [transfer copy];
        self.fatchMethod = fetchMethod;
    }
    return self;
}

+ (instancetype)regEntryWithClass:(Class)cls
                        urlstring:(NSString *)urlstring
                precastParameters:(NSDictionary *)precastParameters
                          keyPath:(NSString *)keyPath
                      fetchMethod:(DataFactoryFetchMethod)fetchMethod
                         transfer:(TransferBlockType)transfer{
    
    return [[self alloc] initWithClass:cls
                             urlstring:urlstring
                     precastParameters:precastParameters
                               keyPath:keyPath
                           fetchMethod:fetchMethod
                              transfer:transfer];
}

- (NSDictionary *)fetchParameters:(NSDictionary *)params{
    NSMutableDictionary *ps = [[NSMutableDictionary alloc] initWithDictionary:self.precastParameters];
    [ps addEntriesFromDictionary:params];
    return ps;
}

@end


//###############################################################################

@interface BaseDataFactory()
@property (nonatomic, strong, nonnull) AFHTTPSessionManager *manager;
@property (nonatomic, strong, nullable) NSMutableDictionary *dataRegistry;
@end

@implementation BaseDataFactory

- (NSMutableDictionary *)dataClassRegistry{
    if (nil == _dataRegistry) {
        _dataRegistry = [NSMutableDictionary dictionary];
    }
    return _dataRegistry;
}

- (void)setupRegistry{

}

- (void)registerDataClass:(Class)cls urlstring:(NSString *)urlstring
        precastParameters:(NSDictionary *)precastParameters
              withKeyPath:(NSString *)keyPath
              fetchMethod:(DataFactoryFetchMethod)fetchMethod
                 transfer:(TransferBlockType)transfer{
    DataFactoryRegEntry *regEntry = [DataFactoryRegEntry regEntryWithClass:cls
                                                                 urlstring:urlstring
                                                         precastParameters:precastParameters
                                                                   keyPath:keyPath
                                                               fetchMethod:fetchMethod
                                                                  transfer:transfer];
    
    [self.dataClassRegistry setObject:regEntry forKey:NSStringFromClass(cls)];
}

- (AFHTTPSessionManager *)manager{
    if (nil == _manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (id)objectForKeyPath:(NSString *)keyPath rootObject:(id)rootObject{
    if (nil == keyPath || nil == rootObject) return nil;
    NSArray *nodes = [keyPath componentsSeparatedByString:@"."];
    id target = rootObject;
    NSString *nodeName = nil;
    
    for (NSString *node in nodes) {
        if(nil == target) return nil;
        
        if ([node hasPrefix:@"{"]) {
             nodeName = [node stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
            target = [(NSDictionary *)target objectForKey:nodeName];
        } else if ([node hasPrefix:@"["]){
            nodeName = [node stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
            target = [(NSArray *)target objectAtIndex:[nodeName integerValue]];
        } else {
            target = [target valueForKey:node];
        }
    }
    return target;
}

- (void)lookupRegForClass:(Class)cls responseObject:(id)responseObject dataSuccess:(DataSuccessBlockType)dataSuccess dataFailure:(DataFailureBlockType)dataFailure{
    // 如果已经注册数据类（模型）:如果已经注册，按照
    DataFactoryRegEntry *regEntry = [self.dataClassRegistry objectForKey:NSStringFromClass(cls)];
    if(nil != regEntry){
        // 获取 keyPath 对应的对象
        id object = [self objectForKeyPath:regEntry.keyPath rootObject:responseObject];
        // 获取 keyPath 对应的对象失败：可能因为1.keyPath为空；2.返回数据格式错误
        if (nil != object){
            // 如果有注册解析方法，则使用注册的方法进行解析；
            if(regEntry.transferBlock){
                id result = regEntry.transferBlock(object);
                if (nil != result) {
                    dataSuccess(result);
                }
            } else { // 如果没有注册解析方法，使用默认解析方法；
                if ([object isKindOfClass:[NSDictionary class]]) {
                    dataSuccess([[cls alloc] initWithDictionary:object]);
                } else if ([object isKindOfClass:[NSArray class]]){
                    NSMutableArray *m_models = [NSMutableArray array];
                    for (NSDictionary *obj in (NSArray *)object) {
                        [m_models addObject:[[cls alloc] initWithDictionary:obj]];
                    }
                    dataSuccess(m_models);
                }
            }
        } else {
            NSLog(@"获取 keyPath 对应的对象失败：可能因为1.keyPath为空；2.返回数据格式错误");
        }
    } else {
        NSLog(@"没有注册条目");
    }
}

- (void)fetchRawDataOfClass:(Class)cls WithParameters:(NSDictionary *)params dataSuccess:(DataSuccessBlockType _Nullable)dataSuccess dataFailure:(DataFailureBlockType _Nullable)dataFailure{
    
    __weak typeof(self) w_self;
    DataFactoryRegEntry *regEntry = [self.dataClassRegistry objectForKey:NSStringFromClass(cls)];
    switch (regEntry.fatchMethod) {
        case DataFactoryFetchMethodGet:{
            [self.manager GET:regEntry.urlstring parameters:[regEntry fetchParameters:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong typeof(w_self) s_self;
                
                [self lookupRegForClass:cls responseObject:responseObject dataSuccess:dataSuccess dataFailure:dataFailure];
                
                if([s_self.delegate respondsToSelector:@selector(dataFactory:successFetchRawData:ofClass:withDataTask:)])
                    [s_self.delegate dataFactory:s_self successFetchRawData:responseObject ofClass:cls withDataTask:task];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong typeof(w_self) s_self;
                if([s_self.delegate respondsToSelector:@selector(dataFactory:failureFetchRawData:ofClass:withDataTask:)])
                    [s_self.delegate dataFactory:s_self failureFetchRawData:error ofClass:cls withDataTask:task];
            }];
        } break;
            
        case DataFactoryFetchMethodPost:{
            [self.manager POST:regEntry.urlstring parameters:[regEntry fetchParameters:params] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong typeof(w_self) s_self;
                
                [self lookupRegForClass:cls responseObject:responseObject dataSuccess:dataSuccess dataFailure:dataFailure];
                
                if([s_self.delegate respondsToSelector:@selector(dataFactory:successFetchRawData:ofClass:withDataTask:)])
                    [s_self.delegate dataFactory:s_self successFetchRawData:responseObject ofClass:cls withDataTask:task];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong typeof(w_self) s_self;
                if([s_self.delegate respondsToSelector:@selector(dataFactory:failureFetchRawData:ofClass:withDataTask:)])
                    [s_self.delegate dataFactory:s_self failureFetchRawData:error ofClass:cls withDataTask:task];
            }];
        } break;
    }
}

- (instancetype)initWithDataRegistry:(NSMutableDictionary *)dataReg{
    self = [super init];
    if (self) {
        self.dataRegistry = dataReg;
    }
    return self;
}

@end
