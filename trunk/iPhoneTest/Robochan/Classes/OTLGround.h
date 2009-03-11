/**
 * @file OTLGround.h
 * @brief OTLGroundクラスのヘッダファイル
 *
 * @author Takashi Ogura
 * @date 2009/03/01
 * @version 0.0.1
*/

/*  $Id:$ */

#import "OTLDrawableObject.h"

/** @brief OTLGroundクラス
 *
 * 床を描画する
 */
@interface OTLGround : OTLDrawableObject
{
  ///床の色(２色)
  GLfloat gcolor[2][4];
  ///床の角の点
  GLfloat gvertex[12];
  ///床の高さ
  float height;
}

- (id) initWithHeight:(float)h;
- (void) setColor:(float)r1:(float)g1:(float)b1:(float)a1:(float)r2:(float)g2:(float)b2:(float)a2;

@end
