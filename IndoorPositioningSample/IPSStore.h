//
//  IPSStore.h
//  IndoorPositioningSample
//
//  Created by Ruben Xifré on 21/4/15.
//  Copyright (c) 2015 Ruben Xifré. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPSStore : NSObject

@property (strong, nonatomic, readonly) NSString *proximityUUIDString;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *detailDescription;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
