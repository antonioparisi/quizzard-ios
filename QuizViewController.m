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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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

#pragma API Requests

- (void)postCorrectAnswer
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[prefs valueForKey:@"accessToken"] forHTTPHeaderField:@"X_QUIZZARD_TOKEN"];
    
    [manager POST:@"http://quizzard-api.herokuapp.com/quizes/answer_correct" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD showSuccess:@"Correct!"];
        [self setCurrentAnswer:self.currentAnswer + 1];
        [self.answersTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
