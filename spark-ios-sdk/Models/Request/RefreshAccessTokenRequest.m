//
//  RefreshAccessTokenRequest.m
//  spark-ios-sdk
//
//  Created by Tomer Har Yoffi on 6/14/15.
//  Copyright (c) 2015 Tomer Har Yoffi. All rights reserved.
//

#import "RefreshAccessTokenRequest.h"

@implementation RefreshAccessTokenRequest

-(instancetype)initWithRefreshCode:(NSString*)refreshCode{
    self = [super init];
    if (self) {
        _refreshCode = refreshCode;
    }
    return self;
}
@end
