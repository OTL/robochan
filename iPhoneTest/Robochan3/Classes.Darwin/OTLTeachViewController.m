/**
 @file
 @brief
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import "OTLTeachViewController.h"

@implementation OTLTeachViewController

- (id)init
{
  if (self = [super initWithNibName:nil bundle:nil])
  {
		self.view.backgroundColor = [UIColor lightGrayColor];		
		self.title = @"教示";
		self.tabBarItem.image = [UIImage imageNamed:@"teachTabIcon_32.png"]; 
		self.tabBarItem.badgeValue = @"3";
  }

  return self;
}

/**
 @brief OpenGL ESで描画する 
 
*/

- (void)loadView
{
  [super loadView];

}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

@end
