//
//  JoinViewController.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/5/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "JoinViewController.h"

@interface JoinViewController (){
    MatchingmakingClient * matchmakingClient;
    QuitReason quitReason;
}
- (void)initJoinView;
- (void)initWaitView;
@end

@implementation JoinViewController
@synthesize headingLb, nameLb, nameTf, statusLb, tableView, exitButton, waitView;
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
    
    [self initJoinView];
    
    //dissmiss keyboard
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self.nameTf action:@selector(resignFirstResponder)];
    ges.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:ges];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(!matchmakingClient){
        quitReason = QuitReasonConnectionDropped;
        matchmakingClient  = [[MatchingmakingClient alloc] init];
        matchmakingClient.delegate = self;
        [matchmakingClient startSearchingForServersWithSessionID:SESSION_ID];
        self.nameTf.placeholder = matchmakingClient.session.displayName;
        [self.tableView reloadData];
    }
}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

#pragma mark Public methods
- (void)doClickExit:(id)sender{
#ifdef DEBUG
    NSLog(@"%@: click exit!",self);
#endif
    quitReason = QuitReasonUserQuit;
    [matchmakingClient disconnectFromServer];
//    [self.delegate joinViewControllerDidCancel:self];
}

#pragma mark Private methods
- (void)initJoinView{
#ifdef DEBUG
    NSLog(@"%@: Init hostview!",self);
#endif
    
    //heading lb
    self.headingLb = [[UILabel alloc] initWithFrame:kHeadingLbFrame];
    self.headingLb.textAlignment = UITextAlignmentCenter;
    self.headingLb.textColor = [UIColor blackColor];
    self.headingLb.font = [UIFont systemFontOfSize:22.0f];
    self.headingLb.text = @"JOIN A [X]uHao GAME";
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
    self.statusLb.text = @"Available Games:";
    [self.view addSubview:self.statusLb];
    
    //table view
    UICard *tableViewBg = [[UICard alloc] initCardWithFrame:CGRectMake(11, 113, 458, 150) text:nil textColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] withShader:NO];    
    [self.view addSubview:tableViewBg];
    self.tableView = [[UITableView alloc] initWithFrame:kTableViewFrame];    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //exit btn
    self.exitButton = [[UIButton alloc] initWithFrame:kExitBtnFrame];
    [self.exitButton setBackgroundImage:[UIImage imageNamed:@"ExitButtonPressed.png"] forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(doClickExit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exitButton];
}

- (void)initWaitView{
    self.waitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [self.waitView setBackgroundColor:[UIColor whiteColor]];
    [self.waitView addSubview:self.exitButton];
    UILabel *connectingLb = [[UILabel alloc] initWithFrame:CGRectMake(83, 147, 313, 27)];
    [connectingLb setFont:[UIFont systemFontOfSize:16.0f]];
    connectingLb.textAlignment = UITextAlignmentCenter;
    connectingLb.textColor = [UIColor blackColor];
    connectingLb.text = @"Connecting...";
    [self.waitView addSubview:connectingLb];    
}

#pragma mark UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
#pragma mark UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(matchmakingClient){
        return [matchmakingClient.availableServers count];
    }else {
        return 0;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *peerId = [matchmakingClient peerIDForAvailableServerAtIndex:indexPath.row];
    cell.textLabel.text = [matchmakingClient displayNameForPeerId:peerId];
    return cell;
}

#pragma mark UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(matchmakingClient){
        if(!self.waitView){
            [self initWaitView];
            [self.view addSubview:self.waitView];
            
            NSString *peerId = [matchmakingClient peerIDForAvailableServerAtIndex:indexPath.row];
            [matchmakingClient connectToServerWithPeerID:peerId];
        }        
    }
}

#pragma mark MatchingmakingClient Delegate
- (void)MatchingmakingClient:(MatchingmakingClient *)client serverBecameAvailable:(NSString *)peerID{
    [self.tableView reloadData];
}

- (void)MatchingmakingClient:(MatchingmakingClient *)client serverBecameUnAvailable:(NSString *)peerID {
    [self.tableView reloadData];
}

- (void)MatchmakingClient:(MatchingmakingClient *)client didDisconnectFromServer:(NSString *)peerID {
#if DEBUG
    NSLog(@"%@: Disconnected From server",self);
#endif    
    matchmakingClient.delegate = nil;
    matchmakingClient = nil;
    [self.tableView reloadData];
    [self.delegate joinViewController:self didDisconnectWithReason:quitReason];
}
- (void)MatchmakingClientNoNetwork:(id)client{
    quitReason = QuitReasonNoNetwork;
}
@end
