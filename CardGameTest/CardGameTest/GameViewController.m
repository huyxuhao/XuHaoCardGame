//
//  GameViewController.m
//  CardGameTest
//
//  Created by Anlab JSC on 10/9/12.
//  Copyright (c) 2012 Anlab. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

-(void)initGameView;

@end

@implementation GameViewController
@synthesize game;
@synthesize centerLb;
@synthesize exitButton;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        game = [[Game alloc] init];
        game.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initGameView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

#pragma mark Private methods

- (void)initGameView{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //init center label
    self.centerLb = [[UILabel alloc] initWithFrame:CGRectMake(83, 147, 313, 27)];
    [centerLb setFont:[UIFont xh_customFontWithSize:16.0f]];
    centerLb.textAlignment = UITextAlignmentCenter;
    centerLb.textColor = [UIColor blackColor];
    centerLb.text = @"Center Label";
    [self.view addSubview:centerLb];
    
    //init button exit
    self.exitButton = [[UIButton alloc] initWithFrame:kExitBtnFrame];
    [self.exitButton setBackgroundImage:[UIImage imageNamed:@"ExitButtonPressed.png"] forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(doClickExit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exitButton];
}

#pragma mark Public methods
- (void)doClickExit:(id)sender{
#ifdef DEBUG
    NSLog(@"GameViewController: Exit Click!");    
#endif 
    [self.game quitGameWithReason:QuitReasonUserQuit];
}

#pragma mark GameDelegate
- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason{
    [self.delegate gameViewController:self didQuitWithReason:reason];
}

- (void)gameWaitingForServerReady:(Game *)game
{
	self.centerLb.text = NSLocalizedString(@"Waiting for game to start...", @"Status text: waiting for server");
}

- (void)gameWaitingForClientsReady:(Game *)game
{
	self.centerLb.text = NSLocalizedString(@"Waiting for other players...", @"Status text: waiting for clients");
}

@end
