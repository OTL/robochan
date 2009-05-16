/** @file OTLKHRInterface.m
 * @brief KHR-2HVを動かすためのシリアル通信プログラム
 * @author Tamaki Nishino & Takashi Ogura
 * @date 2009/03/01
 * @version 0.0.1
 */
 
/* $Id:$ */

//#define PRINTF(s) {FILE* f=fopen("/var/tmp/robochan.log","a");fprintf(f,"%s\n",s);fclose(f);}
#define PRINTF(s) {}
//#define PRINTFD(S,val) {}
#define PRINTFD(s, val) {FILE* f=fopen("/var/tmp/robochan.log","a");fprintf(f,"%s = %d\n",s,val);fclose(f);}
#define PRINTFU(s, val) {FILE* f=fopen("/var/tmp/robochan.log","a");fprintf(f,"%s = %u\n",s,val);fclose(f);}
#define PRINTFF(s, val) {FILE* f=fopen("/var/tmp/robochan.log","a");fprintf(f,"%s = %lf\n",s,val);fclose(f);}
//#define PRINTF(s) {FILE* f=fopen("/var/tmp/robochan.log","a");fclose(f);}
//#define PRINTF(s) {}

#import "OTLKHRInterface.h"

@implementation OTLKHRInterface

@synthesize dof;
@synthesize isConnected;

- (void)connectCheckThreadLoop:(id)info
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  
  [self getVersion];
  isConnected = YES;
  
  [pool release];
  [NSThread exit];
}

- (BOOL)checkConnection
{
  [NSThread detachNewThreadSelector:@selector(connectCheckThreadLoop:) toTarget:self withObject:nil];
  [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
  return isConnected;
}

/** シリアルポートの初期化
 *
 * 
 */
- (BOOL) serialInit
{
  struct termios tio; // シリアルポート設定用構造体
  
  // すでに開いているときはいったんクローズする
  if ( fd > 0 )
  {
    close(fd);
  }
  // ポートのオープン
  fd = open(DEV_NAME,O_RDWR | O_NOCTTY);
  if ( fd < 0 )
  {
    NSLog(@"%s: error in open %s\n", __FUNCTION__, DEV_NAME);
    return NO;
  }
  // ポートの設定
  memset(&tio,0,sizeof(tio));
  tio.c_cflag = CS8 | CLOCAL | CREAD;
  tio.c_cc[VTIME] = 0;
  tio.c_cc[VMIN] = 1; // これが必要

  // ボーレートの設定
  cfsetispeed(&tio,BAUD_RATE);
  cfsetospeed(&tio,BAUD_RATE);
  
  // デバイスに設定を行う
  tcsetattr(fd,TCSANOW,&tio);
  
  return YES;
}

/**
 *  @brief sendBuffer[]にあるデータをsizeバイト送信する。
 *
 * @param size 送信サイズ(byte)
 * @retval 1 常に1を返す
 */
- (int) sendWithSize:(int)size
{
  int i;
  unsigned char sum = 0;
  unsigned char buf[1];

  // send OK?
  buf[0] = RCB3J_CMD_INIT;
  write(fd, buf, 1);
  read(fd, buf, 1);
  // make check sum
  if (size > 0)
  {
    for( i=0; i < size; i++)
    {
      sum += sendBuffer[i];
    }
    sendBuffer[i] = sum; // set check sum to buffer
    // write all buffer
    write(fd, sendBuffer, size+1);
  }

  return 1;
}

/** データの受信
 *  最後のチェックサムを無視している
 */
- (int)receiveWithSize:(int)size
{
  int rt = 0;  // 読み込んだ位置
  int ret = 0; // 返り値

  while ( rt < size )
  {
    ret = read(fd, &receiveBuffer[rt], size - rt);
    if ( ret < 0 ){
      NSLog (@"read error\n");
      return (-1);
    }
    rt += ret;
  }
  
  return 1;
}

/** バッファのクリア
 *
 */
- (void)clearBuffer
{
  memset(sendBuffer, 0, RCB3J_BUFFER_SIZE);
  memset(receiveBuffer, 0, RCB3J_BUFFER_SIZE);
}

/** コマンドの送信
 *
 */
- (int) sendCommand:(unsigned char)command sendSize:(int)size	receiveSize:(int)ack_size
{
  // コマンドセット
  sendBuffer[0] = command;
  // 送信 
  [self sendWithSize:size];
  // 受信
  [self receiveWithSize:ack_size];

  return 1;
}

/** オプション付きのコマンド送信
 *
 */
- (int) sendCommand: (unsigned char) command sendSize:(int) size receiveSize:(int)ack_size option:(unsigned char)option
{
  // コマンド・オプションの設定
  sendBuffer[0] = command;
  sendBuffer[1] = option;
  // 送信
  [self sendWithSize:size];
  if (option & RCB3J_OPT_ACK_ON)
  {
    // 受信
    [self receiveWithSize:ack_size];
  }
  
  return 1;
}

/*
- (int) get_wakeup_motion
{
  PRINTF(__FUNCTION__);
  [self sendCommand:RCB3J_CMD_GET_WAKEUP_MOTION
           sendSize:1
        receiveSize:3];
  return 1;
}

- (int) set_wakeup_motion:(unsigned char) option: (unsigned char) btn: (unsigned char) stp
{
  PRINTF(__FUNCTION__);
  sendBuffer[2] = btn;
  sendBuffer[3] = stp;
  [self sendCommand:RCB3J_CMD_SET_WAKEUP_MOTION
           sendSize:4
        receiveSize:1
             option:option];
  return 1;
}
*/

/*
- (int) get_dying_motion
{
  PRINTF(__FUNCTION__);
  [self sendCommand:RCB3J_CMD_GET_DYING_MOTION
           sendSize:1
        receiveSize:4];
  return 1;
}

- (int) set_dying_motion:(unsigned char) option: (unsigned short) lvl: (unsigned char) mtn
{
  PRINTF(__FUNCTION__);
  sendBuffer[2] = mtn;
  sendBuffer[3] = (lvl >> 8) & 0x3;
  sendBuffer[4] = lvl & 0xff;
  [self sendCommand:RCB3J_CMD_SET_DYING_MOTION
           sendSize:5
        receiveSize:1
             option:option];
  return 1;
}
*/

/** バージョン情報取得
 *
 */
- (int) getVersion
{
  [self sendCommand:RCB3J_CMD_GET_RCB3J_VERSION
           sendSize:1
        receiveSize:65];
  receiveBuffer[64] = '\0';
  NSLog(@"RCB3J version = [%s]\n", receiveBuffer);
  
  return 1;
}

/*
- (int) get_soft_sw:(unsigned char) option
{
  PRINTF(__FUNCTION__);
  [self sendCommand:RCB3J_CMD_GET_SOFT_SW
           sendSize:2
        receiveSize:3
             option:option];
  return 1;
}

- (int) set_soft_sw:(unsigned char) option: (unsigned char) swh: (unsigned char) swl
{
  sendBuffer[2] = swh;
  sendBuffer[3] = swl;
  [self sendCommand:RCB3J_CMD_SET_SOFT_SW
            sendSize:4
         receiveSize:1
              option:option];
  return 1;
}
*/
/*
- (int) play_motion:(unsigned char) option: (unsigned char) mot
{
  sendBuffer[2] = mot;
  [self sendCommand:RCB3J_CMD_PLAY_MOTION
           sendSize:3
        receiveSize:1
             option:option];
  return 1;
}
*/
/*
- (int) get_angles
{
  [self sendCommand:RCB3J_CMD_GET_ANGLES
           sendSize:1
        receiveSize:49];
  return 1;
}
*/

- (int) setJointParam:(unsigned short) param jointId:(unsigned char) joint_num speed:(unsigned char) speed option:(unsigned char) option
{
  sendBuffer[2] = joint_num;
  sendBuffer[3] = speed;
  sendBuffer[4] = param >> 8;
  sendBuffer[5] = param & 0xff;
  NSLog(@"setJointParam: %u %u %u\n", joint_num, speed, param);
  [self sendCommand:RCB3J_CMD_SET_JOINT_PARAM
           sendSize:6
        receiveSize:1
             option:option];
  return 1;
}


/*
- (int) set_all_joint_param:(unsigned char) option: (unsigned char *) pSpeed:(unsigned short *)pParam
{
  return 1;
}


- (int) get_all_joint_param:(unsigned char) option: (unsigned char) joint_num
{
  //    sendBuffer[2] = joint_num;
  //    sendCommand(RCB3J_CMD_GET_ALL_JOINT_PARAM, option, 3, 1);
  return 1;
}
*/

- (int) printReceiveBuffer:(int) size
{
  int i;
  for( i=0;i<size;i++)
    {
      PRINTFD("[%02X]", receiveBuffer[i]);
    }
 // printf("\n");
  return 1;
}


/* --------------------------------------------------------------------- */
/* メイン                                                                */
/* --------------------------------------------------------------------- */

/**
 * まちがっている
 */
- (void)getHomeAngles
{
  int i = 0;
  [self sendCommand:RCB3J_CMD_GET_HOME
	sendSize:2
	receiveSize:49
	option:RCB3J_OPT_ACK_ON];
  for (i = 0; i < dof; i++)
  {
    homeAngles[i] = (receiveBuffer[2*i] << 8) + receiveBuffer[2*i+1];
  }
}


- (OTLKHRInterface *)init
{
  // デバイスファイル（シリアルポート）オープン
  PRINTF(__FUNCTION__);
  dof = RCB3J_MAX_DOF; // KHR-2HVは17ではない。欠番があるようだ。
  isConnected = NO;
  [self serialInit];
//  [self getHomeAngles];
  [super init];
  return self;
}

/*
- (int)getSettings
{
//  printf("get RCB3J version : ");
  [self getVersion];
//  printf("[%s]\n", receiveBuffer);
//  printf("get wakeup motion : ");
  [self get_wakeup_motion];
  [self print_receiveBuffer:3];
//  printf("get dying motion : ");
  [self get_dying_motion];
  [self print_receiveBuffer:4];
//  printf("get soft switch : ");
  [self get_soft_sw:(RCB3J_OPT_ACK_ON | RCB3J_OPT_EEPROM)];
  [self print_receiveBuffer:3];
  return 0;
}

- (int)OO
{
//  printf("set soft switch all 0\n");
  [self set_soft_sw:(RCB3J_OPT_ACK_ON | RCB3J_OPT_EEPROM):0:0];
  return 0;
}

- (int)d
{
//  printf("set soft switch all 0\n");
  [self set_soft_sw:(RCB3J_OPT_ACK_ON | RCB3J_OPT_EEPROM):2:4];
  return 0;
}

- (int)getAngles
{
//  printf("get angles\n");
  [self get_angles];
  [self print_receiveBuffer:49];
  return 0;
}
*/


- (double)param2angle:(unsigned short) param
{
  double ret = 0;
  ret = (( (double)param - (double)RCB3J_MOT_PARAM_ANGLE_CENTER ) / (RCB3J_MOT_PARAM_ANGLE_CENTER -1))  * RCB3J_PARAMSCALE;
  return ret;
}

- (unsigned short)angle2param:(double) ang
{
  unsigned short ret = 0;
  if ( ang > 180 )
  {
    ang = 180;
  }
  else if (ang < -180)
  {
    ang = -180;
  }
  ret = (RCB3J_MOT_PARAM_ANGLE_CENTER + ((RCB3J_MOT_PARAM_ANGLE_CENTER - 1.0) / RCB3J_PARAMSCALE) * ang);

  // 最大値を超えていないかチェックする
  if ( ret > RCB3J_MOT_PARAM_ANGLE_MAX)
  {
    NSLog(@"%s: error out of range angle param for KHR %u > 32767", __FUNCTION__, ret);
    ret = RCB3J_MOT_PARAM_ANGLE_MAX;
  }
  
  return ret;
}

- (unsigned char)time2speed:(double)tm
{
  unsigned char sp = 1;
  // 10     -> 1
  // 5000  -> 250
  if ( tm > 5000 )
  {
    tm = 5000;
  }
  else if ( tm < 10 )
  {
    tm = 10;
  }
//  sp = (2000/tm) + 1;
  sp = (tm / RCB3J_SPEED_RATE) + 1;

  // 0を送ってはいけない
  if ( sp == 0 )
  {
    sp = 1;
  }
  
  return sp;
}

- (BOOL)getJointAngles:(double *)ang
{
  int i = 0;
  unsigned short param = 0;
  
  // 関節角度（2byte * dof）を受信
  [self sendCommand:RCB3J_CMD_GET_ANGLES
           sendSize:1
        receiveSize:49]; // 49 = 2(byte data) * 24(dof) + 1(check sum)
  
  for (i = 0; i < dof; i++)
  {
    // 上位ビット(unsigned char)をunsigned short型へ変換
    param = (unsigned short) receiveBuffer[2*i];
    // 上位ビットなので256倍する
    param = param << 8;
    // 下位ビットを加える
    param += receiveBuffer[2*i+1];
    // doubleの角度(deg)へ書き込み
    ang[i] = [self param2angle: param];
  }

  return YES;
}

- (BOOL)setJointServoOffAll
{
  for (int i = 0; i < dof; i++)
  {
    [self setJointServo: (int)OTLServoOff at:i];
  }
  return YES;
}

- (BOOL)setJointServoOnAll
{
  for (int i = 0; i < dof; i++)
  {
    [self setJointServo: (int)OTLServoOn at:i];
  }
  return YES;
}

- (BOOL)getJointServo:(int *)onoff at:(int)i
{
  return NO;
}

- (BOOL)getJointServos:(int *)onoff
{
  return NO;
}

- (BOOL)setJointServo:(int)onoff at:(int)i
{
  BOOL ret = NO;
  if ( onoff != (int)OTLServoOn ){
    //    [self set_joint_param:RCB3J_OPT_ACK_ON:i:1:RCB3J_MOT_PARAM_FREE];
    [self setJointParam:RCB3J_MOT_PARAM_FREE
                jointId:i
                  speed:1
                 option:RCB3J_OPT_ACK_ON];
    ret = YES;
  }
  return ret;
}

- (BOOL)setJointServos:(int *) onoff
{
  for (int i = 0; i < dof; i++)
  {
    [self setJointServo:onoff[i] at:i];
  }
  return YES;
}

// 全軸受信しかできないのでgetJointAnglesを利用する
- (BOOL)getJointAngle:(double *)ang at:(int)i
{
  double angles[RCB3J_MAX_DOF];

  [self getJointAngles:angles];
  *ang = angles[i];

  return YES;
}

- (BOOL)setJointAngles:(double *)ang time:(double)tm
{
  unsigned short params[RCB3J_MAX_DOF];
  
  sendBuffer[2] = 0; // 利用するモーション番号 ( 0 ~ 79)
  sendBuffer[3] = 0; // 利用するポジション番号（RAMなので無関係)
  
  sendBuffer[4] = [self time2speed:tm]; // 速度の設定
  
  // 角度の設定
  for (int i = 0; i < dof; i++)
  {
    params[i] = [self angle2param:ang[i]];
    sendBuffer[5 + 2*i]   = params[i] >> 8;
    sendBuffer[5 + 2*i+1] = params[i] & 0xff;
  }
  
  [self sendCommand:RCB3J_CMD_SET_ALL_JOINT_PARAM
           sendSize:53
        receiveSize:1
             option:RCB3J_OPT_ACK_ON]; // 送信
  
  return YES;
}


- (BOOL)setJointAngle:(double)ang at:(int)jointId time:(double)tm;
{
//  unsigned short pang = 0;
  unsigned short pang = 0;

  if ( jointId > dof ){
    perror("out of DoF error\n");
    return -1;
  }
  
//  pang = (unsigned short)((128 * 256 -1) * ( 1.0 / 180) * ang + (128 * 256 -1) / 2.0);
//  pang = (unsigned short)((64 * 256) + ((64.0 * 256.0 - 1.0) / 90.0) * ang);
//  pang = homeAngles[jointId] + [self angle2param: ang];
  pang = [self angle2param: ang];
  //  pang = (unsigned short)((64 * 256) + ang);
  PRINTFD("homeAngles[jointId]", homeAngles[jointId]);
  [self setJointParam:pang
              jointId:(unsigned char)jointId
                speed:[self time2speed:tm]
               option:RCB3J_OPT_ACK_ON];
  return YES;
}

- (int)playPresetMotionId:(int)i
{
  sendBuffer[2] = (i & 0xff);
  [self sendCommand:RCB3J_CMD_PLAY_MOTION
           sendSize:3
        receiveSize:1
             option:RCB3J_OPT_ACK_ON];

  return 0;
}
 
- (void)dealloc
{
  close(fd);
  NSLog(@"close interface\n");
  [super dealloc];
}

@end
