//
//  QuizViewController.h
//  quizzard
//
//  Created by m3nTe on 11/03/2014.
//  Copyright (c) 2014 gamaroff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ProgressHUD/ProgressHUD.h>
#import <AFNetworking/AFNetworking.h>

@interface QuizViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *questions;
@property (weak, nonatomic) IBOutlet UITableView *answersTable;
@property (unsafe_unretained ,nonatomic) int currentAnswer;

@end
