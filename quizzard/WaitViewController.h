//
//  WaitViewController.h
//  quizzard
//
//  Created by m3nTe on 10/03/2014.
//  Copyright (c) 2014 gamaroff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>

#import <ProgressHUD/ProgressHUD.h>
#import <Bully/Bully.h>

#import "AppDelegate.h"
#import "QuizViewController.h"

@interface WaitViewController : UIViewController<FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIView *loadingCircle;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@end
