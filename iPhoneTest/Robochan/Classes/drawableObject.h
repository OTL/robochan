/** @file drawableObject.h
 @brief drawableObjectクラス
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/*  $Id:$ */

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

/** @brief drawableObjectクラス
 *
 * 描画することができるオブジェクト。
 * 形状の描画をdrawShapeメソッドにより行う。
 *
 * @todo rotが今テンポラリ
 */
@interface drawableObject : NSObject
{
  /// 位置
  float pos[3];
  /// 姿勢
  float rot[4];
}

/// 描画メソッド
- (void)draw;
/// 形状描画メソッド(仮想メソッド)
- (void)drawShape;

/// 位置指定
- (void)setPos:(float)x:(float)y:(float)z;
/// 姿勢指定
- (void)setRot:(float)t:(float)x:(float)y:(float)z;

@end
