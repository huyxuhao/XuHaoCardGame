//
//  MainViewController.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/4/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "MainViewController.h"

#define kHostGameBtnFrame CGRectMake(158, 173, 165, 37)
#define kJoinGameBtnFrame CGRectMake(158, 218, 165, 37)
#define kSinglePlayerBtnFrame CGRectMake(158, 263, 165, 37)

#define kXCardFrame CGRectMake(35, 24, 90, 132)
#define kUCardFrame CGRectMake(115, 24, 90, 132)
#define kHCardFrame CGRectMake(195, 24, 90, 132)
#define kACardFrame CGRectMake(275, 24, 90, 132)
#define kOCardFrame CGRectMake(355, 24, 90, 132)

@interface MainViewController (){
    BOOL buttonEnabled;
    BOOL performAnimations;
}
- (void)initMenu;
- (void)initCardView;
- (void)prepareforIntroAnim;
- (void)performIntroAnim;
- (void)showDisconnectedAlert;
- (void)showNoNetworkAlert;
- (void)startGameWithBlock:(void (^)(Game *))block;
@end

@implementation MainViewController
@synthesize hostgameBtn,joingameBtn,singlePlayerBtn;
@synthesize xCard,uCard,hCard,aCard,oCard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        performAnimations = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setUserInteractionEnabled:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //init card view
    [self initCardView];
    
    //init menu
    [self initMenu];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view. 
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];    
    if(performAnimations){
        [self prepareforIntroAnim];
    }    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(performAnimations){
        [self performIntroAnim];
    }    
}

#pragma mark Button Methods
- (void)doClickHostGame:(id)sender{    
    if(!buttonEnabled){
        return;
    }    
    
    #ifdef DEBUG
    NSLog(@"MainViewController: Click HostGame!");
    #endif
    
    
    HostViewController *hostVc = [[HostViewController alloc] initWithNibName:nil bundle:nil];
    hostVc.delegate = self;
    if(SYSTEM_VERSION_LESS_THAN(@"5.0")){
        [self presentModalViewController:hostVc animated:NO];
    }else{
        [self presentViewController:hostVc animated:NO completion:nil];
    }
}
- (void)doClickJoinGame:(id)sender{
    if(!buttonEnabled){
        return;
    }
    #ifdef DEBUG
    NSLog(@"MainViewController: Click JoinGame!");    
    #endif
    
    JoinViewController *joinVc = [[JoinViewController alloc] initWithNibName:nil bundle:nil];
    joinVc.delegate = self;
    if(SYSTEM_VERSION_LESS_THAN(@"5.0")){
        [self presentModalViewController:joinVc animated:NO];
    }else{
        [self presentViewController:joinVc animated:NO completion:nil];
    }
}
- (void)doClickSinglePlay:(id)sender{
    if(!buttonEnabled){
        return;
    }
    #ifdef DEBUG
    NSLog(@"MainViewController: Click SinglePlayer!");
    #endif
}

#pragma mark Private methods
- (void)initCardView{
    #ifdef DEBUG
    NSLog(@"MainViewController: Init Card View");
    #endif
    self.xCard = [[UICard alloc] initCardWithFrame:kXCardFrame text:@"X" textColor:[UIColor blackColor] backgroundColor:[UIColor orangeColor] withShader:YES];
    self.uCard = [[UICard alloc] initCardWithFrame:kUCardFrame text:@"U" textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] withShader:YES];
    self.hCard = [[UICard alloc] initCardWithFrame:kHCardFrame text:@"H" textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] withShader:YES];
    self.aCard = [[UICard alloc] initCardWithFrame:kACardFrame text:@"A" textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] withShader:YES];
    self.oCard = [[UICard alloc] initCardWithFrame:kOCardFrame text:@"O" textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] withShader:YES];
    
    [self.view addSubview:self.xCard];
    [self.view addSubview:self.uCard];
    [self.view addSubview:self.hCard];
    [self.view addSubview:self.aCard];  
    [self.view addSubview:self.oCard];
}
- (void)initMenu{
    #ifdef DEBUG
    NSLog(@"MainViewController: Init menu!");
    #endif
    //init hostgame button
    self.hostgameBtn = [[UIButton alloc] initWithFrame:kHostGameBtnFrame];
    self.hostgameBtn.titleLabel.font = [UIFont xh_customFontWithSize:20.0f];
    [self.hostgameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.hostgameBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [self.hostgameBtn setTitle:@"* HOST GAME *" forState:UIControlStateNormal];
    [self.hostgameBtn setUserInteractionEnabled:YES];
    [self.hostgameBtn addTarget:self action:@selector(doClickHostGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.hostgameBtn];
    
    //init joingame,e button
    self.joingameBtn = [[UIButton alloc] initWithFrame:kJoinGameBtnFrame];
    self.joingameBtn.titleLabel.font = [UIFont xh_customFontWithSize:20.0f];
    [self.joingameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.joingameBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [self.joingameBtn setTitle:@"* JOIN GAME *" forState:UIControlStateNormal];
    [self.joingameBtn addTarget:self action:@selector(doClickJoinGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.joingameBtn];
    
    //init singleplayer button
    self.singlePlayerBtn = [[UIButton alloc] initWithFrame:kSinglePlayerBtnFrame];    
    self.singlePlayerBtn.titleLabel.font = [UIFont xh_customFontWithSize:20.0f];
    [self.singlePlayerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.singlePlayerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [self.singlePlayerBtn setTitle:@"* SINGLE PLAYER *" forState:UIControlStateNormal];
    [self.singlePlayerBtn addTarget:self action:@selector(doClickSinglePlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.singlePlayerBtn];
}

- (void)prepareforIntroAnim {        
    [self.xCard setHidden:YES];
    [self.uCard setHidden:YES];
    [self.hCard setHidden:YES];
    [self.aCard setHidden:YES];
    [self.oCard setHidden:YES];    
    
    self.hostgameBtn.alpha = 0.0f;
    self.joingameBtn.alpha = 0.0f;
    self.singlePlayerBtn.alpha = 0.0f;
    
    buttonEnabled = NO;
}

- (void)performIntroAnim{
    [self.xCard setHidden:NO];
    [self.uCard setHidden:NO];
    [self.hCard setHidden:NO];
    [self.aCard setHidden:NO];
    [self.oCard setHidden:NO];
    
    CGPoint point = CGPointMake(self.view.bounds.size.width/2.0f, self.view.bounds.size.height*2.0f);
    
    self.xCard.center = point;
    self.uCard.center = point;
    self.hCard.center = point;
    self.aCard.center = point;
    self.oCard.center = point;
    
    [UIView animateWithDuration:0.65f delay:0.5f options:UIViewAnimationCurveEaseOut animations:^{
        self.xCard.center = CGPointMake(80.0f, 108.0f);
        self.xCard.transform = CGAffineTransformMakeRotation(-0.22f);
        
        self.uCard.center = CGPointMake(160.0f, 93.0f);
        self.uCard.transform = CGAffineTransformMakeRotation(-0.1f);
        
        self.hCard.center = CGPointMake(240.0f, 88.0f);
        
        self.aCard.center = CGPointMake(320.0f, 93.0f);
        self.aCard.transform = CGAffineTransformMakeRotation(0.1f);
        
        self.oCard.center = CGPointMake(400.0f, 108.0f);
        self.oCard.transform = CGAffineTransformMakeRotation(0.22f);
        
        self.hostgameBtn.alpha = 1.0f;
        self.joingameBtn.alpha = 1.0f;
        self.singlePlayerBtn.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        buttonEnabled = YES;
    }];
}

- (void)showDisconnectedAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"You were disconnected from the game" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)showNoNetworkAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Network" message:@"To use multiplayer, please enable Bluetooth or Wi-Fi in your device's Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)startGameWithBlock:(void (^)(Game *))block{
    GameViewController *gameVc = [[GameViewController alloc] initWithNibName:nil bundle:nil];
    gameVc.delegate = self;
    Game *game = [[Game alloc] init];
    if(SYSTEM_VERSION_LESS_THAN(@"5.0")){
        [self presentModalViewController:gameVc animated:NO];        
        gameVc.game = game;
        game.delegate = gameVc;
        block(game);
    }else{
        [self presentViewController:gameVc animated:NO completion:^{
            Game *game = [[Game alloc] init];
            gameVc.game = game;
            game.delegate = gameVc;
            block(game);
        }];
    }
}

#pragma mark HostViewContrller Delegate
- (void)hostViewControllerDidCancel:(HostViewController *)controller{
    if(SYSTEM_VERSION_LESS_THAN(@"5.0")){
        [self dismissModalViewControllerAnimated:NO];
    }else{
    [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)hostViewController:(HostViewController *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients {
    performAnimations = NO;
    
    if(SYSTEM_VERSION_LESS_THAN(@"5.0")){
        [self dismissModalViewControllerAnimated:NO];            
        performAnimations = YES;        
        //start game here
        [self startGameWithBlock:^(Game *game)
         {
             [game startServerGameWithSession:session playerName:name clients:clients];
         }];
        
    }else{
        [self dismissViewControllerAnimated:NO completion:^{
            performAnimations = YES;
            
            //start game here
            [self startGameWithBlock:^(Game *game)
             {
                 [game startServerGameWithSession:session playerName:name clients:clients];
             }];
        }];
    }
}
#pragma mark JoinViewController Delegate
- (void)joinViewControllerDidCancel:(JoinViewController *)controller{
    if(SYSTEM_VERSION_LESS_THAN(@"5.0")){
        [self dismissModalViewControllerAnimated:NO];
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (void)joinViewController:(JoinViewController *)controller didDisconnectWithReason:(QuitReason)reason{
    if(reason == QuitReasonConnectionDropped){
#ifdef DEBUG
        NSLog(@"%@ : Disconected!",self);
#endif
        if(SYSTEM_VERSION_LESS_THAN(@"5.0")){
            [self dismissModalViewControllerAnimated:NO];
            [self showDisconnectedAlert];
        }else{
            [self dismissViewControllerAnimated:NO completion:^{
                [self showDisconnectedAlert];
            }];
        }
    }else if (reason == QuitReasonNoNetwork) {
        [self showNoNetworkAlert];
    }
}
- (void)joinViewController:(JoinViewController *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID {
    performAnimations = NO;
    
    if(SYSTEM_VERSION_LESS_THAN(@"5.0")){
        [self dismissModalViewControllerAnimated:NO];            
        performAnimations = YES;        
        //start game here
        [self startGameWithBlock:^(Game *game)
         {
             [game startClientGameWithSession:session playerName:name server:peerID];
         }];
        
    }else{
        [self dismissViewControllerAnimated:NO completion:^{
            performAnimations = YES;
            
            //start game here
            [self startGameWithBlock:^(Game *game)
             {
                 [game startClientGameWithSession:session playerName:name server:peerID];
             }];
        }];
    }
}

#pragma mark GameViewcontroller Delegate
- (void)gameViewController:(GameViewController *)controller didQuitWithReason:(QuitReason)reason{
    if(SYSTEM_VERSION_LESS_THAN(@"5.0")){
        [self dismissModalViewControllerAnimated:NO];            
        [self showDisconnectedAlert];
        
    }else{
        [self dismissViewControllerAnimated:NO completion:^
         {
             if (reason == QuitReasonConnectionDropped)
             {
                 [self showDisconnectedAlert];
             }
         }];
    }    
}
@end
