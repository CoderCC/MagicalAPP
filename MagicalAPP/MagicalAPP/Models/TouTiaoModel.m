//
//  TouTiaoModel.m
//  MagicalAPP
//
//  Created by 魏朋 on 16/8/21.
//  Copyright © 2016年 魏朋. All rights reserved.
//

#import "TouTiaoModel.h"

#define D2M(PROPERTY_NAME, DICTIONARY_NAME) \
self.PROPERTY_NAME = DICTIONARY_NAME[@"PROPERTY_NAME"]

@implementation TouTiaoModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        self.date = [formatter dateFromString:dict[@"date"]];
        D2M(author_name, dict);
        self.thumbnail_pic_s = [NSURL URLWithString:dict[@"thumbnail_pic_s"]];
        self.thumbnail_pic_so2 = [NSURL URLWithString:dict[@"thumbnail_pic_so1"]];
        self.thumbnail_pic_so3 = [NSURL URLWithString:dict[@"thumbnail_pic_so3"]];
        self.url = [NSURL URLWithString:dict[@"url"]];
        self.uniquekey = [dict[@"uniquekey"] longLongValue];
        D2M(type, dict);
        D2M(realtype, dict);
    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

+ (NSArray *)modelsWithArray:(NSArray *)objects{
    NSMutableArray *m_models = [NSMutableArray array];
    for (NSDictionary *object in objects) {
        [m_models addObject:[self modelWithDictionary:object]];
    }
    return m_models;
}
@end
