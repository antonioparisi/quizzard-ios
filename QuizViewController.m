//
//  QuizViewController.m
//  quizzard
//
//  Created by m3nTe on 11/03/2014.
//  Copyright (c) 2014 gamaroff. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()

@end

@implementation QuizViewController

@synthesize questions = _questions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-1.png"]];
    self.navigationItem.hidesBackButton = YES;
    
    [self.answersTable setDelegate:self];
    [self.answersTable setDataSource:self];
    
    // Init current answer index
    self.currentAnswer = 0;
    
    [self listenForNextQuestion];
    [self listenForRank];
    
    [self setupTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view setUserInteractionEnabled:YES];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.layer setBorderWidth:1.0f];
        [cell.layer setBorderColor:[UIColor grayColor].CGColor];
        
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell setBackgroundColor:[UIColor redColor]];
    }
    
    id question = [[[_questions objectAtIndex:self.currentAnswer] objectForKey:@"answers"] objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[question objectForKey:@"title"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[[_questions objectAtIndex:self.currentAnswer] objectForKey:@"correct_number"] integerValue])
    {
        [self postCorrectAnswer];
    }else {
        [ProgressHUD showError:@"Wrong!"];
    }
}

#pragma Timer

- (void)setupTimer
{
    [self.progressTimer startWithSeconds:10.0f andInterval:0.1f andTimeFormat:@"%.0f"];
    
    [self.progressTimer setDelegate:self];
}

- (void)counterDownFinished:(CircleCounterView *)circleView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Time is up, wait next question, get ready!";
    [hud hide:YES afterDelay:3.0f];
    
    [self.view setUserInteractionEnabled:NO];
}

#pragma API Requests

- (void)postCorrectAnswer
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [[[QuizzardClient sharedClient] requestSerializer] setValue:[prefs valueForKey:@"accessToken"] forHTTPHeaderField:@"X_QUIZZARD_TOKEN"];
    
    [[QuizzardClient sharedClient] POST:@"/quizes/answer_correct" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:@"Correct!"];
        [hud hide:YES afterDelay:1.0f];
        
        [self.view setUserInteractionEnabled:NO];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma Pusher

- (void)listenForNextQuestion
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    BLYChannel *channel = [appDelegate._client subscribeToChannelWithName:@"quiz"];
    [channel bindToEvent:@"next_question" block:^(id message) {
        // Warning the user about the `next question is starting`
        [ProgressHUD show:@"Next question is starting, get ready!"];
        
        [self setCurrentAnswer:self.currentAnswer + 1];
        [self.answersTable reloadData];
        
        [ProgressHUD dismiss];
        [self setupTimer];
    }];
}

- (void)listenForRank
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    BLYChannel *channel = [appDelegate._client subscribeToChannelWithName:@"quiz"];
    [channel bindToEvent:@"rank" block:^(id message) {
        NSMutableArray *ranking = [[NSMutableArray alloc] initWithArray:[[message objectForKey:@"message"] objectForKey:@"rank"]];
        
        [self performSegueWithIdentifier:@"rank" sender:ranking];
    }];
}

#pragma Timer utilities

- (CGRect)frameOfCircleViewOfSize:(CGSize)size inView:(UIView *)view {
    return CGRectInset(view.bounds,
                       (CGRectGetWidth(view.bounds) - size.width)/2.0f,
                       (CGRectGetHeight(view.bounds) - size.height)/2.0f);
}


#pragma Prepare For Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"rank"]) {
        RankViewController *rankVC = [segue destinationViewController];
        [rankVC setRanking:sender];
    }
}

@end
