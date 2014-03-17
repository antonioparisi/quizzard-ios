//
//  QuizViewController.h
//  quizzard
//
//  Created by m3nTe on 11/03/2014.
//  Copyright (c) 2014 gamaroff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ProgressHUD/ProgressHUD.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import "CircleDownCounter.h"
#import "CircleCounterView.h"

#import "Constants.h"
#import "QuizzardClient.h"
#import "AppDelegate.h"

#import "RankViewController.h"

@interface QuizViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CircleCounterViewDelegate>

@property (strong, nonatomic) NSMutableArray *questions;
@property (weak, nonatomic) IBOutlet UITableView *answersTable;
@property (unsafe_unretained ,nonatomic) int currentAnswer;
@property (strong, nonatomic) IBOutlet CircleCounterView *progressTimer;
@property (strong, nonatomic) CircleDownCounter *circleCounter;

@end
