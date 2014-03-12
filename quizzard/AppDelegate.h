//
//  AppDelegate.h
//  quizzard
//
//  Created by m3nTe on 9/03/2014.
//  Copyright (c) 2014 gamaroff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Bully/Bully.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BLYClientDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BLYClient *_client;

@end
