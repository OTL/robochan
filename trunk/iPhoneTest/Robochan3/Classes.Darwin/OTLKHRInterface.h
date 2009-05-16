/** @file OTLKHRInterface.h
 @brief KHR-2HVを動かすためのシリアル通信プログラムのヘッダファイル
 @author Tamaki Nishino & Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/*  $Id:$ */

#import <Foundation/Foundation.h>

#import "OTLRobotInterface.h"

#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <fcntl.h>
#import <string.h>
#import <termios.h>
#import <time.h>

#define DEV_NAME    "/dev/tty.iap"        //< デバイスファイル名
#define BAUD_RATE    B115200              //< RS232C通信ボーレート

#define RCB3J_PARAMSCALE 6000
#define RCB3J_SPEED_RATE 20

typedef enum _OTLKHRConst {
  RCB3J_MAX_DOF = 24,
  RCB3J_BUFFER_SIZE = 128
} OTLKHRConst;

typedef enum _RCB3JOption {
  RCB3J_OPT_ACK_ON      = 1,
  RCB3J_OPT_EEPROM      = 2,
  RCB3J_OPT_FORCE_PLAY  = 4
} RCB3JOption;

typedef enum _RCB3JMotionParam {
  RCB3J_MOT_PARAM_NOTRING       = 0,
  RCB3J_MOT_PARAM_ANGLE_MAX     = 32767,
  RCB3J_MOT_PARAM_ANGLE_CENTER  = (64 * 256),
  RCB3J_MOT_PARAM_TTL_L         = 32768,
  RCB3J_MOT_PARAM_TTL_H         = 32769,
  RCB3J_MOT_PARAM_FREE          = 32770,
  RCB3J_MOT_PARAM_GET_ANGLE     = 32774,
} RCB3JMotionPrarm;

typedef enum _RCB3JCommand {
  RCB3J_CMD_INIT                  = 0x0d,
  RCB3J_CMD_GET_WAKEUP_MOTION     = 0xee,
  RCB3J_CMD_SET_WAKEUP_MOTION     = 0xef,
  RCB3J_CMD_GET_DYING_MOTION      = 0xeb,
  RCB3J_CMD_SET_DYING_MOTION      = 0xec,
  RCB3J_CMD_GET_RCB3J_VERSION     = 0xff,
  RCB3J_CMD_GET_ANGLES            = 0xf0,
  RCB3J_CMD_GET_SOFT_SW           = 0xf1,
  RCB3J_CMD_SET_SOFT_SW           = 0xf2,
  RCB3J_CMD_PLAY_MOTION           = 0xf4,
  RCB3J_CMD_GET_HOME              = 0xf9,
  RCB3J_CMD_SET_JOINT_PARAM       = 0xfe,
  RCB3J_CMD_SET_ALL_JOINT_PARAM   = 0xfd,
  RCB3J_CMD_GET_ALL_JOINT_PARAM   = 0xfc
} RCB3JCommand;
  
typedef enum _OTLKHRInterfaceServoOnOff {
  OTLServoOff = 0,
  OTLServoOn  = 1
} OTLKHRInterfaceServoOnOff;


/** 
 * @brief KHR-2HVをシリアル通信で操作するためのインタフェースとなるクラス
 * 
 * 
 */
@interface OTLKHRInterface : NSObject <OTLRobotInterface>
{
@private
  int fd; // USARTファイルディスクリプタ
  int dof; // 自由度
  unsigned char sendBuffer[RCB3J_BUFFER_SIZE]; // 送信用バッファ
  unsigned char receiveBuffer[RCB3J_BUFFER_SIZE]; // 受信用バッファ
  unsigned short homeAngles[RCB3J_MAX_DOF];        // ホーム姿勢(現在未使用)
  BOOL isConnected; // RCB3Jと接続されているかどうか
}

@property (readonly) int dof;
@property (readonly) BOOL isConnected;

- (int)playPresetMotionId:(int)i;
- (int)getVersion;
- (BOOL)serialInit;
- (BOOL)checkConnection;
- (BOOL)setJointServoOffAll;

- (unsigned char)time2speed:(double)tm;


@end
