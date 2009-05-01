/**
 @file RobochanAppDelegate.m
 @brief アプリメインプログラムのファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import "OTLRobochanViewController.h"

@implementation OTLRobochanViewController

- (id)init
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
		self.view.backgroundColor = [UIColor lightGrayColor];		
		self.title = @"会話";
		self.tabBarItem.image = [UIImage imageNamed:@"mainTabIcon_32.png"]; 
		//self.tabBarItem.badgeValue = @"3";
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  talkView = [[OTLTalkView alloc] initWithFrame:CGRectMake(0, 0, 480, 300)];
  [self.view addSubview:talkView];
  [talkView release];

//   UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 30)];
//   label.font = [UIFont boldSystemFontOfSize:22];
//   label.backgroundColor = [UIColor lightGrayColor];
//   label.textColor = [UIColor blackColor];
//   label.text = @"Main View";
//   label.textAlignment = UITextAlignmentCenter;		
//   [self.view addSubview:label];			
//   [label release];		
}

@end
