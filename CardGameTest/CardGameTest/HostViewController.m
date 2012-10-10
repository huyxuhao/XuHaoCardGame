//
//  HostViewController.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/4/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "HostViewController.h"

@interface HostViewController () {
    MatchmakingServer *matchMakingServer;
}

@end

@implementation HostViewController
@synthesize headingLb, nameLb, nameTf, statusLb, tableView, startButton, exitButton;
@synthesize delegate;

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
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setUserInteractionEnabled:YES];
    
    [self initHostView];
    
    //dismiss keyboard 
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.nameTf action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!matchMakingServer){
        matchMakingServer = [[MatchmakingServer alloc] init];
        matchMakingServer.delegate = self;
        matchMakingServer.maxClients =3;
        [matchMakingServer startAcceptingConnectionsForSeesionID:SESSION_ID];
        self.nameTf.placeholder = matchMakingServer.session.displayName;
        [self.tableView reloadData];
    }
}

- (void)dealloc
{
    #ifdef DEBUG
	NSLog(@"%@: dealloc", self);
    #endif
}

#pragma mark Private methods
- (void)initHostView{
    
    #ifdef DEBUG
    NSLog(@"HostViewController: Init hostview!");
    #endif
    
    //heading lb
    self.headingLb = [[UILabel alloc] initWithFrame:kHeadingLbFrame];
    self.headingLb.textAlignment = UITextAlignmentCenter;
    self.headingLb.textColor = [UIColor blackColor];
    self.headingLb.font = [UIFont systemFontOfSize:22.0f];
    self.headingLb.text = @"HOST A [X]uHao GAME";
    [self.view addSubview:self.headingLb];
    
    //name lb
    self.nameLb = [[UILabel alloc] initWithFrame:kNameLbFrame];
    self.nameLb.textColor = [UIColor blackColor];
    self.nameLb.font = [UIFont systemFontOfSize:14.0f];
    self.nameLb.text = @"YOUR NAME:";
    [self.view addSubview:self.nameLb];
    
    //name tf
    UICard *nameTfBg = [[UICard alloc] initCardWithFrame:CGRectMake(167, 46, 240, 32) text:nil textColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] withShader:NO];
    [self.view addSubview:nameTfBg];
    self.nameTf = [[UITextField alloc] initWithFrame:kNameTfFrame];
    self.nameTf.delegate = self;
    self.nameTf.placeholder = @"Input your host name here!";
    [self.nameTf setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.nameTf];
    
    //status lb
    self.statusLb  = [[UILabel alloc] initWithFrame:kStatusLbFrame];
    self.statusLb.textColor = [UIColor blackColor];
    self.statusLb.textAlignment = UITextAlignmentCenter;
    self.statusLb.font = [UIFont systemFontOfSize:14.0f];
    self.statusLb.text = @"Waiting for players to connect...";
    [self.view addSubview:self.statusLb];
    
    //table view
    UICard *tableViewBg = [[UICard alloc] initCardWithFrame:CGRectMake(11, 113, 458, 150) text:nil textColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] withShader:NO];    
    [self.view addSubview:tableViewBg];
    self.tableView = [[UITableView alloc] initWithFrame:kTableViewFrame];    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //start btn
    self.startButton = [[UIButton alloc] initWithFrame:kStartBtnFrame];
    [self.startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(doClickStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
    
    //exit btn
    self.exitButton = [[UIButton alloc] initWithFrame:kExitBtnFrame];
    [self.exitButton setBackgroundImage:[UIImage imageNamed:@"ExitButtonPressed.png"] forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(doClickExit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exitButton];
}

#pragma mark Public method
- (void)doClickStart:(id)sender{
    #ifdef DEBUG
    NSLog(@"HomeViewController: Start Click!");    
    #endif      
    
    if(matchMakingServer && [matchMakingServer.connectedClieent count] > 0){
        NSString *name = [self.nameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([name length] == 0){
            name = matchMakingServer.session.displayName;
            [matchMakingServer stopAcceptingConnections];
            [self.delegate hostViewController:self startGameWithSession:matchMakingServer.session playerName:name clients:matchMakingServer.connectedClieent];
        }
    }
}

- (void)doClickExit:(id)sender{
    #ifdef DEBUG
    NSLog(@"HomeViewController: Exit Click!");    
    #endif    
    [self.delegate hostViewControllerDidCancel:self];
}

#pragma mark UITableView delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

#pragma mark UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (matchMakingServer) {
        return [matchMakingServer.connectedClieent count];
    }else {
        return 0;
    }    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	NSString *peerID = [matchMakingServer peerIDForConnectedClientAtIndex:indexPath.row];
	cell.textLabel.text = [matchMakingServer displayNameForPeerID:peerID];
    
	return cell;
}

#pragma mark UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  NO;
}

#pragma mark MatchMakingServer delegate
- (void)matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID
{
#ifdef DEBUG
    NSLog(@"%@ : client did connect with id:%@",self,peerID);
#endif
	[self.tableView reloadData];
}

- (void)matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID
{
#ifdef DEBUG
    NSLog(@"%@ : client did dis connect with id:%@",self,peerID);
#endif    
	[self.tableView reloadData];
}

@end
