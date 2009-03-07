/** @file OTLKHRInterface.h
 @brief KHR-2HVを動かすためのシリアル通信プログラムのヘッダファイル
 @author Tamaki Nishino & Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/*  $Id:$ */

#import <Foundation/NSObject.h>
#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <fcntl.h>
#import <string.h>
#import <termios.h>
#import <time.h>

#define DEV_NAME    "/dev/tty.iap"        //< デバイスファイル名
#define BAUD_RATE    B115200              //< RS232C通信ボーレート

#define RCB3J_OPT_ACK_ON 1
#define RCB3J_OPT_EEPROM 2
#define RCB3J_OPT_FORCE_PLAY 4

#define RCB3J_MOT_PARAM_NOTRING    0
#define RCB3J_MOT_PARAM_TTL_L      32768
#define RCB3J_MOT_PARAM_TTL_H      32769
#define RCB3J_MOT_PARAM_FREE       32770
#define RCB3J_MOT_PARAM_GET_ANGLE  32774

#define RCB3J_CMD_GET_WAKEUP_MOTION 0xee
#define RCB3J_CMD_SET_WAKEUP_MOTION 0xef
#define RCB3J_CMD_GET_DYING_MOTION 0xeb
#define RCB3J_CMD_SET_DYING_MOTION 0xec
#define RCB3J_CMD_GET_RCB3J_VERSION 0xff
#define RCB3J_CMD_GET_SOFT_SW 0xf1
#define RCB3J_CMD_SET_SOFT_SW 0xf2
#define RCB3J_CMD_PLAY_MOTION 0xf4
#define RCB3J_CMD_GET_ANGLES 0xf0
#define RCB3J_CMD_SET_JOINT_PARAM 0xfe
#define RCB3J_CMD_SET_ALL_JOINT_PARAM 0xfd
#define RCB3J_CMD_GET_ALL_JOINT_PARAM 0xfc


//@class KHRInterface;

/** 
 * @brief KHR-2HVをシリアル通信で操作するためのインタフェースとなるクラス
 * 
 * 
 */
@interface OTLKHRInterface : NSObject {
  /// USARTファイルディスクリプタ
  int fd;
  /// 送信用バッファ
  unsigned char send_buffer[128];
  /// 受信用バッファ
  unsigned char receive_buffer[128];
}

@property (readonly) int fd;

///ロボットの状態取得
- (int)getSettings;
- (int)OO;
- (int)d;
///ロボットの関節角度取得
- (int)getAngles;
///サーボオフの関節の現在角度を取得する
- (int)freeJointAndGetAngles:(int)i;
///ロボットの関節角度を指定する
- (int)setJointAngle:(int)i;
///プリセットモーションを再生する
- (int)playMotion:(int)i;

@end
