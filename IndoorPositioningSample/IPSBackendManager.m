//
//  IPSBackendManager.m
//  IndoorPositioningSample
//
//  Created by Ruben Xifré on 23/4/15.
//  Copyright (c) 2015 Ruben Xifré. All rights reserved.
//

#import "IPSBackendManager.h"
#import <Parse/Parse.h>

@implementation IPSBackendManager

+ (instancetype)sharedManager
{
    static IPSBackendManager *sharedManagager = nil;
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

- (void)syncBeacons
{
    PFQuery *query = [PFQuery queryWithClassName:@"Beacon"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)getIBeaconsWithSuccessBlock:(void(^)(NSArray *liveFeedArray))successBlock andFailureBlock:(void(^)(NSError *error))failureBlock
{
    
}

@end
