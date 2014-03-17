//
//  LoginViewController.h
//  quizzard
//
//  Created by m3nTe on 10/03/2014.
//  Copyright (c) 2014 gamaroff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AFNetworking/AFNetworking.h>

#import "Constants.h"
#import "QuizzardClient.h"

@interface LoginViewController : UIViewController<FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@end
