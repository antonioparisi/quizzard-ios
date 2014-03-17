//
//  RankViewController.h
//  quizzard
//
//  Created by m3nTe on 17/03/2014.
//  Copyright (c) 2014 gamaroff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *ranking;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
