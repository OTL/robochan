//
//  OTLTalkView.m
//  Robochan
//
//  Created by 小倉 崇 on 5/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OTLTalkView.h"

@implementation OTLTalkView

- (void) hideDisclosure: (UIPushButton *)calloutButton
{
  UICalloutView *callout = (UICalloutView *)[calloutButton superview];
  [callout fadeOutWithDuration:1.0f];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
      imgView = [[UIImageView alloc] initWithFrame: frame];
      [imgView setImage:[UIImage imageNamed:@"normal.png"]];
      imgView.userInteractionEnabled = NO;
      [self addSubview:imgView];
      [imgView release];
      isVisible = YES;

      UICalloutView *callout = [[[UICalloutView alloc] initWithFrame:CGRectZero] autorelease];
      callout.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
      callout.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

      [callout setTemporaryTitle:@"僕ロボチャンだよ"];
      [callout setTitle:@"今日は何する？"];
      [callout addTarget:self action:@selector(hideDisclosure:)];
      [self addSubview:callout];
      [callout setAnchorPoint:CGPointMake(460.0f, 80.0f)
	       boundaryRect: CGRectMake(0.0f, 0.0f, 320.0f, 100.0f)
	       animate:YES];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [imgView release];
    [super dealloc];
}

- (void) touchesBegan: (NSSet *) touches withEvent : (UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  if ([touch phase] != UITouchPhaseBegan) return;

  isVisible = !isVisible;
  CGContextRef context = UIGraphicsGetCurrentContext();
  [UIView beginAnimations:nil context:context];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.2];

  if (isVisible)
    {
      [imgView setImage:[UIImage imageNamed:@"normal.png"]];
    }
  else
    {
      [imgView setImage:[UIImage imageNamed:@"smile.png"]];
    }
  
  //[imgView setAlpha: (float)isVisible];
  [UIView commitAnimations];
}
  
@end
