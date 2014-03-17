//
//  LoginViewController.m
//  quizzard
//
//  Created by m3nTe on 10/03/2014.
//  Copyright (c) 2014 gamaroff. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-1.png"]];
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email"]];
    loginView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setValue:[user objectForKey:@"email"] forKey:@"email"];
    [prefs setValue:user.first_name forKey:@"firstName"];
    [prefs setValue:user.last_name forKey:@"lastName"];
    [prefs setValue:user.id forKey:@"pictureId"];
    [prefs setValue:[[[FBSession activeSession] accessTokenData] accessToken] forKey:@"accessToken"];

    [prefs synchronize];
    
    NSDictionary *parameters = @{
                                 @"email": [prefs valueForKey:@"email"],
                                 @"name": [prefs valueForKey:@"firstName"],
                                 @"lastname": [prefs valueForKey:@"lastName"],
                                 @"picture": [prefs valueForKey:@"pictureId"],
                                 @"access_token": [prefs valueForKey:@"accessToken"]
                                 };
    
    [[QuizzardClient sharedClient] POST:@"/users" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self performSegueWithIdentifier:@"wait_host" sender:self];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    [self performSegueWithIdentifier:@"wait_host" sender:self];

//    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,
//                                                           id<FBGraphUser> fbUserData,
//                                                           NSError *error)
//     {
//         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//         if (![prefs valueForKey:@"accessToken"]) {
//            [prefs setValue:[fbUserData objectForKey:@"email"] forKey:@"email"];
//            [prefs setValue:[fbUserData objectForKey:@"first_name"] forKey:@"firstName"];
//            [prefs setValue:[fbUserData objectForKey:@"last_name"] forKey:@"lastName"];
//            [prefs setValue:[fbUserData objectForKey:@"id"] forKey:@"pictureId"];
//            [prefs setValue:[[[FBSession activeSession] accessTokenData] accessToken] forKey:@"accessToken"];
//            [prefs synchronize];
//             
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
//            NSDictionary *parameters = @{
//                 @"email": [prefs valueForKey:@"email"],
//                 @"name": [prefs valueForKey:@"firstName"],
//                 @"lastname": [prefs valueForKey:@"lastName"],
//                 @"picture": [prefs valueForKey:@"pictureId"],
//                 @"access_token": [[[FBSession activeSession] accessTokenData] accessToken]
//            };
//
//            [manager POST:[NSString stringWithFormat:@"%@/users", kAPI_URL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [self performSegueWithIdentifier:@"wait_host" sender:self];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//         }else {
//             [self performSegueWithIdentifier:@"wait_host" sender:self];
//         }
//    }];
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
