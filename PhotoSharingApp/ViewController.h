//
//  ViewController.h
//  PhotoSharingApp
//
//  Created by Saikrishna on 4/18/15.
//  Copyright (c) 2015 Sadhana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController <FBSDKLoginButtonDelegate,MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblLoginStatus;
@property (weak, nonatomic) IBOutlet UIButton *inviteFriends;
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *profilePicture;


- (IBAction)inviteFriends:(id)sender;


- (IBAction)jsonData:(id)sender;


@end

