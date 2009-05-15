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
  [self get_version];
  isConnected = YES;
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
 *  @brief send_buffer[]にあるデータをsizeバイト送信する。
 *
 * @param size 送信サイズ(byte)
 * @retval 1 常に1を返す
 */
- (int) send:(int)size
{
  PRINTF(__FUNCTION__);
  int i;
  unsigned char sum = 0;
  unsigned char buf[1];

  // send OK?
  buf[0] = 0x0d;
  PRINTFD("line", __LINE__);
  write(fd, buf, 1);
  PRINTFD("line", __LINE__);
  //tcflush(fd, TCOFLUSH);
  PRINTFD("line", __LINE__);
  // wait OK
//  usleep(100 * 1000);
  read(fd, buf, 1);
  PRINTFD("line", __LINE__);
  //
  if (size > 0)
    {
      for( i=0; i < size; i++)
        {
          sum += send_buffer[i];
        }
      send_buffer[i] = sum;
      PRINTFD("line", __LINE__);
      write(fd, send_buffer, size+1);
      PRINTFD("line", __LINE__);
      //tcflush(fd, TCOFLUSH);
    }

  return 1;
}

- (int)receive:(int) size
{
  PRINTF(__FUNCTION__);
  int rt = 0;
  int ret = 0;

  PRINTFD("target", size);
//      usleep(300 * 1000);
  while ( rt < size )
    {
      PRINTF("read1");
      PRINTF("read12");
      ret = read(fd, &receive_buffer[rt], size - rt);
      PRINTF("read2");
      if ( ret < 0 ){
	PRINTF ("read error\n");
	return (-1);
      }
      rt += ret;
      PRINTFD("read", rt);
    }

  PRINTF("read finish \n");
  return 1;
}

- (int) send_cmd: (unsigned char) command: (int) size: (int) ack_size
{
  PRINTF(__FUNCTION__);
  send_buffer[0] = command;
  [self send:size];
  [self receive:ack_size];
  return 1;
}

- (int) send_cmd_opt: (unsigned char) command: (unsigned char) option: (int) size: (int) ack_size
{
  PRINTF(__FUNCTION__);
  send_buffer[0] = command;
  send_buffer[1] = option;
  [self send:size];
  if (option & RCB3J_OPT_ACK_ON) 
    {
      [self receive:ack_size];
    }
  return 1;
}

- (int) get_wakeup_motion
{
  PRINTF(__FUNCTION__);
  [self send_cmd:RCB3J_CMD_GET_WAKEUP_MOTION:1:3];
  return 1;
}

- (int) set_wakeup_motion:(unsigned char) option: (unsigned char) btn: (unsigned char) stp
{
  PRINTF(__FUNCTION__);
  send_buffer[2] = btn;
  send_buffer[3] = stp;
  [self send_cmd_opt:RCB3J_CMD_SET_WAKEUP_MOTION:option:4:1];
  return 1;
}


- (int) get_dying_motion
{
  PRINTF(__FUNCTION__);
  [self send_cmd:RCB3J_CMD_GET_DYING_MOTION:1:4];
  return 1;
}

- (int) set_dying_motion:(unsigned char) option: (unsigned short) lvl: (unsigned char) mtn
{
  PRINTF(__FUNCTION__);
  send_buffer[2] = mtn;
  send_buffer[3] = (lvl >> 8) & 0x3;
  send_buffer[4] = lvl & 0xff;
  [self send_cmd_opt:RCB3J_CMD_SET_DYING_MOTION:option:5:1];
  return 1;
}


- (int) get_version
{
  PRINTF(__FUNCTION__);
  [self send_cmd:RCB3J_CMD_GET_RCB3J_VERSION:1:65];
  return 1;
}

- (int) get_soft_sw:(unsigned char) option
{
  PRINTF(__FUNCTION__);
  [self send_cmd_opt:RCB3J_CMD_GET_SOFT_SW:option:2:3];
  return 1;
}

- (int) set_soft_sw:(unsigned char) option: (unsigned char) swh: (unsigned char) swl
{
  send_buffer[2] = swh;
  send_buffer[3] = swl;
  [self send_cmd_opt:RCB3J_CMD_SET_SOFT_SW:option:4:1];
  return 1;
}


- (int) play_motion:(unsigned char) option: (unsigned char) mot
{
  send_buffer[2] = mot;
  [self send_cmd_opt:RCB3J_CMD_PLAY_MOTION:option:3:1];
  return 1;
}


- (int) get_angles
{
  [self send_cmd:RCB3J_CMD_GET_ANGLES:1:49];
  return 1;
}


- (int) set_joint_param:(unsigned char) option:(unsigned char) joint_num:(unsigned char) speed:(unsigned short) param
{
  send_buffer[2] = joint_num;
  send_buffer[3] = speed;
  send_buffer[4] = param >> 8;
  send_buffer[5] = param & 0xff;
  [self send_cmd_opt:RCB3J_CMD_SET_JOINT_PARAM:option:6:1];
  return 1;
}


- (int) set_all_joint_param:(unsigned char) option: (unsigned char *) pSpeed:(unsigned short *)pParam
{
  return 1;
}


- (int) get_all_joint_param:(unsigned char) option: (unsigned char) joint_num
{
  //    send_buffer[2] = joint_num;
  //    send_cmd_opt(RCB3J_CMD_GET_ALL_JOINT_PARAM, option, 3, 1);
  return 1;
}


- (int) print_receive_buffer:(int) size
{
  int i;
  for( i=0;i<size;i++)
    {
      PRINTFD("[%02X]", receive_buffer[i]);
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
  [self send_cmd_opt: RCB3J_CMD_GET_HOME: RCB3J_OPT_ACK_ON: 2: 49];
  for (i = 0; i < dof; i++)
  {
    homeAngles[i] = (receive_buffer[2*i] << 8) + receive_buffer[2*i+1];
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

- (int)getSettings
{
//  printf("get RCB3J version : ");
  [self get_version];
//  printf("[%s]\n", receive_buffer);
//  printf("get wakeup motion : ");
  [self get_wakeup_motion];
  [self print_receive_buffer:3];
//  printf("get dying motion : ");
  [self get_dying_motion];
  [self print_receive_buffer:4];
//  printf("get soft switch : ");
  [self get_soft_sw:(RCB3J_OPT_ACK_ON | RCB3J_OPT_EEPROM)];
  [self print_receive_buffer:3];
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
  [self print_receive_buffer:49];
  return 0;
}


#define RCB3J_PARAMSCALE 6000

- (double)param2angle:(unsigned short) param
{
  double ret = 0;
  ret = (( (double)param - (double)RCB3J_MOT_PARAM_ANGLE_CENTER ) / (RCB3J_MOT_PARAM_ANGLE_CENTER -1))  * RCB3J_PARAMSCALE;
  PRINTFU("param2angle: before\n", param);
  PRINTFF("param2angle: after\n", ret);
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

- (BOOL)getJointAngles:(double *)ang
{
  int i = 0;
  unsigned short param = 0;

  // 全軸フリーにする
//  for (int i = 0; i < dof; i++)
//  {
//    [self setJointServo:0 at:i];
  //  }
  
  // 関節角度（2byte * dof）を受信
  [self send_cmd: RCB3J_CMD_GET_ANGLES: 1: 49]; // 49 = 2(byte data) * 24(dof) + 1(check sum)
  
  for (i = 0; i < dof; i++)
  {
    // 上位ビット(unsigned char)をunsigned short型へ変換
    param = (unsigned short) receive_buffer[2*i];
    // 上位ビットなので256倍する
    param = param << 8;
    // 下位ビットを加える
    param += receive_buffer[2*i+1];
    // doubleの角度(deg)へ書き込み
    ang[i] = [self param2angle: param];
  }

  return YES;
}

- (BOOL)setJointServoOffAll
{
  for (int i = 0; i < dof; i++)
  {
    [self setJointServo:0 at:i];
  }
  return YES;
}

- (BOOL)setJointServoOnAll
{
  for (int i = 0; i < dof; i++)
  {
    [self setJointServo:0 at:i];
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
  [self set_joint_param:RCB3J_OPT_ACK_ON:i:1:RCB3J_MOT_PARAM_FREE];
  return YES;
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
  
  send_buffer[2] = 0; // 利用するモーション番号 ( 0 ~ 79)
  send_buffer[3] = 0; // 利用するポジション番号（RAMなので無関係)
  
  send_buffer[4] = [self time2speed:tm]; // 速度の設定
  
  // 角度の設定
  for (int i = 0; i < dof; i++)
  {
    params[i] = [self angle2param:ang[i]];
    send_buffer[5 + 2*i]   = params[i] >> 8;
    send_buffer[5 + 2*i+1] = params[i] & 0xff;
  }
  
  [self send_cmd_opt:RCB3J_CMD_SET_ALL_JOINT_PARAM :RCB3J_OPT_ACK_ON :53 :1]; // 送信
  
  return YES;
}

- (unsigned char)time2speed:(double)tm
{
  unsigned char sp = 1;
  // 10     -> 100
  // 10000  ->   1
  if ( tm > 10000 )
  {
    tm = 10000;
  }
  else if ( tm < 10 )
  {
    tm = 10;
  }
  sp = (2000/tm) + 1;

  // 0を送ってはいけないので念のためチェック
  if ( sp == 0 )
  {
    NSLog(@"%s:%d error sp = 0\n", __FUNCTION__, __LINE__);
    sp = 1;
  }
  
  return sp;
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
  [self set_joint_param:RCB3J_OPT_ACK_ON :(unsigned char)jointId :(unsigned char)tm : pang];

  return YES;
}

- (int)playMotion:(int)i
{
//  printf("play motion\n");
  [self play_motion:RCB3J_OPT_ACK_ON:(i & 0xff)];
  return 0;
}
 
- (void)dealloc
{
  close(fd);
  PRINTF("CLOSE!!\n");
//  NSLog(@"close interface\n");
  [super dealloc];
}

@end
