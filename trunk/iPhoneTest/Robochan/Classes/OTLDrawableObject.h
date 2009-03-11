/** @file OTLDrawableObject.h
 @brief OTLDrawableObjectクラスのヘッダファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/*  $Id:$ */

#ifdef WIN32

#import <GL/glut.h>
#import "OTLCygwin.h"

#else

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

//#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#endif

/** @brief OTLDrawableObjectクラス
 *
 * 描画することができるオブジェクト。
 * 形状の描画をdrawShapeメソッドにより行う。
 *
 * @todo rotが今テンポラリ
 */
@interface OTLDrawableObject : NSObject
{
  /// 位置
  float pos[3];
  /// 姿勢
  float rot[4];
}

/* 公開メソッド */
- (void)draw;
- (void)drawShape;
- (void)setPos:(float)x:(float)y:(float)z;
- (void)setRot:(float)t:(float)x:(float)y:(float)z;

@end
