/**
 @file 
 @brief
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import "OTLTabBarController.h"

@implementation OTLTabBarController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
  return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

// In ResultsViewController
// - (void)viewWillAppear:(BOOL)animated
// {

	//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
  // First rotate the screen:
//   [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
//   // Then rotate the view and re-align it:
//   CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation( M_PI / 2.0);
//   landscapeTransform = CGAffineTransformTranslate( landscapeTransform, +90.0, +90.0 );
//   self.view.bounds  = CGRectMake(0.0, 0.0, 480.0, 320.0);
//   self.view.center  = CGPointMake (240.0, 160.0);

//  [self.view setTransform:landscapeTransform];

//   CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2.0);
// 	self.view.transform = transform;
// 	// Repositions and resizes the view.
// 	CGRect contentRect = CGRectMake(-80, 80, 480, 320);
//   self.view.center  = CGPointMake (240.0, 160.0);
// 	self.view.bounds = contentRect;

// }

@end
