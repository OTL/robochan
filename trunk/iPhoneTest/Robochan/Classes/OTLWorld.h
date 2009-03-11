/** @file OTLWorld.h
 @brief OTLWorldクラスのヘッダファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/*  $Id:$ */

#import "OTLGround.h"
#import "OTLBoxRobot.h"
#import "OTLObjObject.h"

/// 最大表示オブジェクト数
#define MAX_OBJNUM 1000

/** @brief OTLWorldクラス
 * 描画対象を管理し、描画を行う
 */
@interface OTLWorld : NSObject
{
@private
  /// 描画対象
  id drawTargets[MAX_OBJNUM];
  /// 描画対象の数
  unsigned int objNum;
@public
  
  float *viewPos; //< 視点の位置
  float *viewRot; //< 視点の角度

//   int a,e;
//   float b,c,d;
}

/// 描画メソッド
- (void)draw;
/// 描画対象を加える
- (int)addObject:(id)obj;
/// ロボットをランダムな位置におく（デバッグ用）
- (void)addRandomRobot;
/// 視点をセットする
- (void)setCamera;

- (void)setViewPos:(float *)p;
- (void)setViewRot:(float *)r;
- (void)getViewPos:(float *)p;
- (void)getViewRot:(float *)r;

/* @property (readwrite) float *viewPos; */
/* @property (readwrite) float *viewRot; */

// @property (readwrite) int a;
// @property (readwrite) int e;
// @property (readwrite) float b;
// @property (readwrite) float c;
// @property (readwrite) float d;

@end
