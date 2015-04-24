//
//  IPSStoreManager.m
//  IndoorPositioningSample
//
//  Created by Ruben Xifré on 21/4/15.
//  Copyright (c) 2015 Ruben Xifré. All rights reserved.
//

#import "IPSStoresManager.h"
#import "IPSStore.h"

@interface IPSStoresManager()

@property (strong, nonatomic) NSDictionary *storesDictionary;

@end

@implementation IPSStoresManager

+ (instancetype) sharedManagager
{
    static IPSStoresManager *sharedManagager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManagager = [[self alloc] init];
    });
    return sharedManagager;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSDictionary *)storesDictionary
{
    if (!_storesDictionary) {
        NSDictionary *storesDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"B9407F30-F5F8-466E-AFF9-25556B57FE6D", @"proximityUUIDString",
                                    @"sdfsfsfs dsf sd", @"name",
                                    @"sdfsfsfs dsf sd skfñskf ñslkf ñsakfñ slkfslkjdf lskjdf lskjdf slkjf lskjd flskjdflskjfl kajsfl kjslfkj salkjf lskj flskj lfksaj f", @"detailDescription",
                                    nil],
                                   @"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                                   nil];
        _storesDictionary = storesDic;
    }
    return _storesDictionary;
}

- (IPSStore *)storeForProximityUUIDString:(NSString *)uuid
{
    IPSStore *store = nil;
    NSDictionary *storeDic = [self.storesDictionary objectForKey:uuid];
    if (storeDic) {
        store = [[IPSStore alloc] initWithDictionary:storeDic];
    }
    return store;
}

@end
