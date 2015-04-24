//
//  IPSStore.m
//  IndoorPositioningSample
//
//  Created by Ruben Xifré on 21/4/15.
//  Copyright (c) 2015 Ruben Xifré. All rights reserved.
//

#import "IPSStore.h"

@interface IPSStore()

@property (strong, nonatomic) NSString *proximityUUIDString;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *detailDescription;

@end

@implementation IPSStore

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _proximityUUIDString = [dictionary objectForKey:@"proximityUUIDString"];
        _name = [dictionary objectForKey:@"name"];
        _detailDescription = [dictionary objectForKey:@"detailDescription"];
    }
    return self;
}

@end
