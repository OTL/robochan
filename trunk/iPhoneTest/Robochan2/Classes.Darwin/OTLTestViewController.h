/** 
 @file OTLRobochanViewController.h
 @brief 初期状態で表示するView
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import <UIKit/UIKit.h>

/** @brief 初期状態で表示するViewControllerクラス
 *
 */
@class OTLKHRInterface;

@interface OTLTestViewController : UIViewController{
  /// ロボット(KHR-2HV)操作インタフェース
  OTLKHRInterface *ki;
}

/// セグメントコントロールのイベントハンドラ
- (void)sendCommand:(id)sender;
/// セグメントコントロールを追加
- (void)addSegment;

@end

