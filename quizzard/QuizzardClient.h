//
//  QuizzardClient.h
//  quizzard
//
//  Created by m3nTe on 15/03/2014.
//  Copyright (c) 2014 gamaroff. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "Constants.h"

@interface QuizzardClient : AFHTTPSessionManager

+ (QuizzardClient *)sharedClient;

@end
