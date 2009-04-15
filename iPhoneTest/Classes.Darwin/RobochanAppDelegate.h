/** 
 @file RobochanAppDelegate.h
 @brief アプリメインプログラムのヘッダファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import <UIKit/UIKit.h>

@class OTLTeachViewController;
@class OTLKHRInterface;

/** @brief アプリメインクラス
 *
 */
@interface RobochanAppDelegate : NSObject <UIApplicationDelegate> {
  /// iPhoneのウィンドウ
  UIWindow *window;
  /// ViewController
  UITabBarController *tabController;
  OTLTeachViewController *tvController;
  NSArray *controllers;
  /// 文字列表示（デバッグ用）
  //UILabel *label;
  /// ロボット(KHR-2HV)操作インタフェース
  OTLKHRInterface *ki;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabController;

/// デバッグ用ラベルに文字列を表示する
//- (void)setLabelText:(NSString *)str;
/// セグメントコントロールのイベントハンドラ
//- (void)sendCommand:(id)sender;
/// セグメントコントロールを追加
//- (void)addSegment;
@end

