/** 
 @file RobochanAppDelegate.h
 @brief アプリメインプログラムのヘッダファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import <UIKit/UIKit.h>

@class EAGLView;
@class KHRInterface;

/** @brief アプリメインクラス
 *
 */
@interface RobochanAppDelegate : NSObject <UIApplicationDelegate> {
  /// iPhoneのウィンドウ
  UIWindow *window;
  /// OpenGL ESで描画する部分
  EAGLView *glView;
  /// 文字列表示（デバッグ用）
  UILabel *label;
  /// ロボット(KHR-2HV)操作インタフェース
  KHRInterface *ki;
}

@property (nonatomic, retain) UIWindow *window;

/// デバッグ用ラベルに文字列を表示する
- (void)setLabelText:(NSString *)str;
/// セグメントコントロールのイベントハンドラ
- (void)sendCommand:(id)sender;
/// セグメントコントロールを追加
- (void)addSegment;
@end

