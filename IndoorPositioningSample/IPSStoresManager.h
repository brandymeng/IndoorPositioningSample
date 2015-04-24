//
//  IPSStoreManager.h
//  IndoorPositioningSample
//
//  Created by Ruben Xifré on 21/4/15.
//  Copyright (c) 2015 Ruben Xifré. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPSStore;

@interface IPSStoresManager : NSObject

+ (instancetype) sharedManagager;

- (IPSStore *)storeForProximityUUIDString:(NSString *)uuid;

@end
