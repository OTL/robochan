//
//  OTLUIViewController.m
//  Test1
//
//  Created by 小倉 崇 on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  OTLRobotInterface
- (int)setJointAngle:(double)ang at:(int)id time:(double)tm;
- (int)setJointAngles:(double *)ang time:(double)tm;
- (int)getJointAngle:(double *)ang at:(int)id;
- (int)getJointAngles:(double *)ang;
- (int)setJointServo:(int)onoff at:(int)id ;
- (int)getJointServo:(int *)onoff at:(int)id ;
- (int)setJointServos:(int *)onoff;
- (int)getJointServos:(int *)onoff;
@end
