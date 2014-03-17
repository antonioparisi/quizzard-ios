//
//  QuizzardClient.m
//  quizzard
//
//  Created by m3nTe on 15/03/2014.
//  Copyright (c) 2014 gamaroff. All rights reserved.
//

#import "QuizzardClient.h"

@implementation QuizzardClient

+ (QuizzardClient *)sharedClient
{
    static QuizzardClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:kAPI_URL];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"Quizzard iOS 1.0" }];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        [config setURLCache:cache];
        
        _sharedClient = [[QuizzardClient alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}

@end
