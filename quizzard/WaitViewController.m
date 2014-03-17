//
//  WaitViewController.m
//  quizzard
//
//  Created by m3nTe on 10/03/2014.
//  Copyright (c) 2014 gamaroff. All rights reserved.
//

#import "WaitViewController.h"

@interface WaitViewController ()

@end

@implementation WaitViewController

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
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email"]];
    loginView.delegate = self;

    [self initCirclePulse];
    
    [self joinMatch];
    [self waitMatch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                           id<FBGraphUser> fbUserData,
                                                           NSError *error)
     {
         self.profilePictureView.profileID = fbUserData.id;
         [self performSelector:@selector(getUserImageFromFBView) withObject:nil afterDelay:1.0];
     }];
}

#pragma Wrap facebook profile image into an UIImageView

- (void)getUserImageFromFBView{
    UIImage *img = nil;
    
    for (NSObject *obj in [self.profilePictureView subviews]) {
        if ([obj isMemberOfClass:[UIImageView class]]) {
            UIImageView *objImg = (UIImageView *)obj;
            img = objImg.image;
            break;
        }
    }
    
    CGSize viewSize = self.view.bounds.size;
    
    self.profileImage.alpha = 0;
    self.profileImage.image = img;
    [self setRoundedView:self.profileImage toDiameter:100.0];
    
    [self.profileImage setFrame:(CGRectMake((viewSize.width / 2) - 50, (self.view.bounds.size.height / 2) - 150, self.profileImage.bounds.size.width, self.profileImage.bounds.size.height))];
    
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.profileImage.alpha = 1; }
                     completion:^(BOOL finished){
                        
                     }
     ];
}

- (void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.layer.masksToBounds = YES;
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)initCirclePulse
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.3;
    scaleAnimation.repeatCount = HUGE_VAL;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.2];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.8];
    
    [self.loadingCircle.layer addAnimation:scaleAnimation forKey:@"scale"];
}

#pragma pusher

- (void)joinMatch
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [[[QuizzardClient sharedClient] requestSerializer] setValue:[prefs valueForKey:@"accessToken"] forHTTPHeaderField:@"X_QUIZZARD_TOKEN"];
    
    [[QuizzardClient sharedClient] POST:@"/users/join" parameters:nil success:nil failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)waitMatch
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    BLYChannel *channel = [appDelegate._client subscribeToChannelWithName:@"quiz"];
    [channel bindToEvent:@"start" block:^(id message) {
        NSString *jsonString = [[message objectForKey:@"message"] objectForKey:@"questions"];
        NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

        NSError *error;
        NSDictionary *dictQuestions = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray *questions = [[NSMutableArray alloc] init];
        for (NSDictionary *question in dictQuestions)
        {
            [questions addObject:question];
        }
        
        // Warning the user about the `quiz is starting`
        [ProgressHUD show:@"Quiz is starting, get ready!"];
        
        [self performSelector:@selector(startQuiz:) withObject:questions];
    }];
}

- (void)startQuiz:(id)questions
{
    [ProgressHUD dismiss];
    
    [self performSegueWithIdentifier:@"quizStart" sender:questions];
}

#pragma Prepare For Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"quizStart"]) {
        QuizViewController *quizVC = [segue destinationViewController];
        [quizVC setQuestions:sender];
    }
}

@end
