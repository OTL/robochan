/**
   @file main.m
   @brief Robochan���C���v���O����
   @author Takashi Ogura
   @date 2009/03/01
   @version 0.0.1
*/

/* $Id:$ */

/** \mainpage
 *
 * Robochan�Ƃ�iPod touch��KHR-2HV�𓮂����v���W�F�N�g
 * ���̃\�t�g�͂���iPod touch�p�\�t�g�E�F�A�ł��B
 * 
 * 
 */

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"RobochanAppDelegate");
	[pool release];
	return retVal;
}
