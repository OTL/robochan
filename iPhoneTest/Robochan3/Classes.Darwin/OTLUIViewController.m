//
//  OTLUIViewController.m
//  Test1
//
//  Created by 小倉 崇 on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OTLUIViewController.h"

@implementation OTLUIViewController

@synthesize ri;

- (id)initWithRobotInterface:(OTLKHRInterface *)ari
{
  self = [self init];
  self.ri = ari;
  NSLog(@"ri = %d\n", ri);

  return (self);
}

- (void)dealloc
{
  [ri release];
  [super dealloc];
}

@end
