//
//  ViewController.m
//  PhotoSharingApp
//
//  Created by Saikrishna on 4/18/15.
//  Copyright (c) 2015 Sadhana. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
static NSString * const BaseURLStringGet=@"http://localhost:3000/photoshare/api/v1/test";

static NSString * const BaseURLStringPost=@"http://localhost:3000/photoshare/api/v1/test";

@interface ViewController ()

@end

@implementation ViewController

 NSMutableArray *tableData;

- (void)viewDidLoad {
    [super viewDidLoad];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    _inviteFriends.enabled=NO;
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    [self.view addSubview:loginButton];
    //loginButton.center=self.view.center;
    //loginButton.center = self.CGPointMake(320.0, 480.0);// for bottomright
    loginButton.frame = CGRectMake(60, 430, 200, 50);
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [loginButton setDelegate:self];
    NSLog(@"3");
   

    if([FBSDKAccessToken currentAccessToken]){
        NSLog(@"Hello There");
        [self returnUserProfileData];
        // [self returnUserFriendsData];
     //  [self inviteFriends:tableData];

        
   }
 
      NSLog(@"Value of Access Token");

  }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"5");
    
}


- (void) loginButton: (FBSDKLoginButton *)loginButton
didCompleteWithResult: 	(FBSDKLoginManagerLoginResult *)result
               error: 	(NSError *)error{
       // self.profilePicture.hidden=YES;
    NSLog(@"U are suceesfully logged in hereeeee");
     [self returnUserProfileData];
        _inviteFriends.enabled=YES;
  //[self inviteFriends:tableData];
    //[self returnUserFriendsData];
    
}

//-(IBAction)disableButton{
  //      inviteFriends.enabled=NO;
//}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
    NSLog(@"U are suceesfully logged out");
    self.emailLabel.text =@"";
    self.nameLabel.text=@"";
   // self.profilePicture.hidden=YES;
    
    
}
-(void) returnUserProfileData {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"name, email"}]
     
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog( @"%@",result);
             //NSLog(@"Email: %@",[result objectForKey:@"email"]);
             //  NSLog(@"First Name : %@",[result objectForKey:@"name"]);
             
             NSLog(@"fetched user name :%@  and Email : %@", result[@"name"],result[@"email"]);
             //                   lblUsername.text = @"hjkhkjh";
             FBSDKProfilePictureView *profilePictureview = [[FBSDKProfilePictureView alloc]init];
             [profilePictureview setProfileID:result[@"id"]];
             [self.view addSubview:profilePictureview];
             self.emailLabel.text=result[@"email"];
             self.nameLabel.text=result[@"name"];
         }
     }];
}

-(void) returnFriendsData{
    NSLog(@"List of friends");
    // [self returnUserFriendsData];
    NSDictionary *parameters = @{
                                 @"fields": @"name,picture"
                                 
                                 };
    // This will only return the list of friends who have this app installed
    FBSDKGraphRequest *friendsRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/taggable_friends"
                                                                          parameters:parameters];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:friendsRequest
         completionHandler:^(FBSDKGraphRequestConnection *innerConnection, NSDictionary *result, NSError *error) {
             if (error) {
                 NSLog(@"%@", error);
                 return;
             }
             
             if (result) {
                 
                 NSArray* friends = [result objectForKey:@"data"];
                 
                 NSLog(@"Found: %lu friends", friends.count);
                 
                 for (NSDictionary<FBSDKGraphRequestConnectionDelegate>* friend in friends) {
                     
                     
                     NSLog(@"fetched user name :%@ ", [friend objectForKey:@"name"]);
                     
                     NSDictionary *pictureData = [[friend objectForKey:@"picture"] objectForKey:@"data"];
                     
                     NSString *imageUrl = [pictureData objectForKey:@"url"];
                     
                     NSLog(@"Facebook profile image url %@", imageUrl);
                     NSMutableArray *data = [friend objectForKey:@"name"];
                     tableData = [data copy];
                     // [UITableView reloadData];
                     //for(id obj in tableData)
                     //  NSLog(@"TABLE DATA VALUES",obj);
                     
                 }
                 
                 
             }
         }];
    // start the actual request
    [connection start];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Don't have the cell highlighted since we use the checkmark instead
   // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *data = [tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = [data objectForKey:@"name"];
    return cell;
}



- (IBAction)inviteFriends:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"Hey There";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"sadhana@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)jsonData:(id)sender {
    // 1
    
    NSString *string = BaseURLStringGet;
    
    NSURL *url = [NSURL URLWithString:string];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    
    // 2
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        // 3
        
        NSDictionary *dic  = (NSDictionary *)responseObject;
        
        NSString *name= [dic objectForKey:@"name"];
        NSLog(@"%@", name);
        
        NSLog(@"%@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 4
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                  
                                                            message:[error localizedDescription]
                                  
                                                           delegate:nil
                                  
                                                  cancelButtonTitle:@"Ok"
                                  
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
    }];
    
    // 5
    
    [operation start];
    
    NSLog(@"%@",@"Trying to post now");
    
    //step one generate url to post
    
    NSString *String = BaseURLStringPost;
    
    NSURL *url1 = [NSURL URLWithString:String];
    
    NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
    
    // step two generate manager
    
    
    
    AFHTTPRequestOperationManager *newManager = [AFHTTPRequestOperationManager manager];
    
    newManager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    
    
    NSDictionary *paramerters = @{@"name": @"Sadhana",
                                  
                                  @"userid": @"2342323423"};
    
    NSString *name=@"sadhana";
    
    NSString *userid=@"2342323423";
    
    
    NSDictionary *jsonSignUpDictionary = @{@"name":name, @"userid":userid};
    
    
    
    NSLog(@"Dictionary: %@", [jsonSignUpDictionary description]);
    
    [newManager POST:BaseURLStringPost parameters:jsonSignUpDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
