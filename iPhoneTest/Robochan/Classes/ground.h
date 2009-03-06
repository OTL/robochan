/** @file ground.h
 @brief groundクラス
 @author Takashi Ogura
 @date 2009/03/01
 @version{0.0.1}
*/

/*  $Id:$ */

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "drawableObject.h"

/** @brief groundクラス
 *
 * 床を描画する
 */
@interface ground : drawableObject
{
  ///床の色(２色)
  GLfloat gcolor[2][4];
  ///床の角の点
  GLfloat gvertex[12];
  ///床の高さ
  float height;
}

/// 高さを指定して初期化
- (id) initWithHeight:(float)h;
/// 床の色を指定する（２色）
- (void) setColor:(float)r1:(float)g1:(float)b1:(float)a1:(float)r2:(float)g2:(float)b2:(float)a2;

@end
