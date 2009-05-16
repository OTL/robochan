/** 
 @file RobochanAppDelegate.h
 @brief アプリメインプログラムのヘッダファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import <UIKit/UIKit.h>
#import "OTLKHRInterface.h"
#import "OTLTabBarController.h"
#import "OTLRobochanViewController.h"
#import "OTLGLViewController.h"
#import "OTLPoseTeachViewController.h"
#import "OTLNullViewController.h"
#import "OTLJointTestViewController.h"
#import "OTLWindow.h"
#import "OTLUINavigationController.h"

/** @brief アプリメインクラス
 *
 */
@interface RobochanAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
@private
  
  UIWindow *window;  @private// iPhoneのウィンドウ
  
  UITabBarController *tabController; // ViewController
  OTLGLViewController *glController; // ViewController
  NSArray *controllers; // ViewController
  OTLKHRInterface *ri; 
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, retain) OTLKHRInterface *ri;

/// デバッグ用ラベルに文字列を表示する
//- (void)setLabelText:(NSString *)str;
/// セグメントコントロールのイベントハンドラ
//- (void)sendCommand:(id)sender;
/// セグメントコントロールを追加
//- (void)addSegment;

@end

