//
//  OTLUIViewController.m
//  Test1
//
//  Created by 小倉 崇 on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  OTLRobotInterface
- (BOOL)setJointAngle:(double)ang at:(int)id time:(double)tm;
- (BOOL)setJointAngles:(double *)ang time:(double)tm;
- (BOOL)getJointAngle:(double *)ang at:(int)i;
- (BOOL)getJointAngles:(double *)ang;
- (BOOL)setJointServo:(int)onoff at:(int)i;
- (BOOL)getJointServo:(int *)onoff at:(int)i;
- (BOOL)setJointServos:(int *)onoff;
- (BOOL)getJointServos:(int *)onoff;
@end
