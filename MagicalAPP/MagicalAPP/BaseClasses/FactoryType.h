//
//  FactoryType.h
//  MagicalAPP
//
//  Created by 魏朋 on 16/8/21.
//  Copyright © 2016年 魏朋. All rights reserved.
//

#ifndef FactoryType_h
#define FactoryType_h

typedef void(^DataSuccessBlockType)(id _Nullable responseData);
typedef void(^DataFailureBlockType)(NSError * _Nonnull error);
typedef id _Nullable (^TransferBlockType)(id _Nullable rawData);

typedef NS_ENUM(NSUInteger, DataFactoryFetchMethod) {
    DataFactoryFetchMethodGet = 1,
    DataFactoryFetchMethodPost,
};

typedef NS_ENUM(NSUInteger, RegEntryRawDataType) {
    RegEntryRawDataTypeJSON = 1,
    RegEntryRawDataTypeXML,
    RegEntryRawDataTypeNone,
};

#endif /* FactoryType_h */
