/**
   @file main.m
   @brief Robochanメインプログラム
   @author Takashi Ogura
   @date 2009/03/01
   @version 0.0.1
*/

/* $Id:$ */

/** \mainpage
 *
 * RobochanとはiPod touchでKHR-2HVを動かすプロジェクト
 * このソフトはそのiPod touch用ソフトウェアです。
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
