#import "KHRInterface.h"

@implementation KHRInterface

@synthesize fd;

// シリアルポートの初期化
- (void) serial_init
{
  struct termios tio;
  memset(&tio,0,sizeof(tio));
  tio.c_cflag = CS8 | CLOCAL | CREAD;
  tio.c_cc[VTIME] = 0;
  //tio.c_cc[VMIN] = 100; // これが必要
  tio.c_cc[VMIN] = 1; // これが必要
  // ボーレートの設定
  cfsetispeed(&tio,BAUD_RATE);
  cfsetospeed(&tio,BAUD_RATE);
  // デバイスに設定を行う
  tcsetattr(fd,TCSANOW,&tio);
}

- (int) RCB3J_send:(int)size
{
  int i;
  unsigned char sum = 0;
  unsigned char buf[1];

  // send OK?
  buf[0] = 0x0d;
  write(fd, buf, 1);
  tcflush(fd, TCOFLUSH);
  // wait OK
  read(fd, buf, 1);
  //
  if (size > 0)
    {
      for( i=0; i < size; i++)
        {
	  sum += RCB3J_send_buffer[i];
        }
      RCB3J_send_buffer[i] = sum;
      write(fd, RCB3J_send_buffer, size+1);
      tcflush(fd, TCOFLUSH);
    }

  return 1;
}

- (int)RCB3J_receive:(int) size
{
  int rt = 0;
  int ret = 0;
  int i = 0;

  printf("target = %d \n", size);
  while ( rt < size )
    {
      ret = read(fd, RCB3J_receive_buffer, size);
      if ( ret < 0 ){
	printf ("read error\n");
	return (-1);
      }
      rt += ret;
      printf("read = %d\n", rt);
      for (i =0; i< ret; i++)
	{
	  printf("%2x", RCB3J_receive_buffer[i]);
	}
      printf("\n");

    }
  /*     read(fd, RCB3J_receive_buffer, size); */
  /*     tcflush(fd, TCIFLUSH); // 他は読み捨て */
  printf("read finish \n");
  return 1;
}

- (int) RCB3J_send_cmd: (unsigned char) command: (int) size: (int) ack_size
{
  RCB3J_send_buffer[0] = command;
  [self RCB3J_send:size];
  [self RCB3J_receive:ack_size];
  return 1;
}

- (int) RCB3J_send_cmd_opt: (unsigned char) command: (unsigned char) option: (int) size: (int) ack_size
{
  RCB3J_send_buffer[0] = command;
  RCB3J_send_buffer[1] = option;
  [self RCB3J_send:size];
  if (option & RCB3J_OPT_ACK_ON) 
    {
      [self RCB3J_receive:ack_size];
    }
  return 1;
}

- (int) RCB3J_get_wakeup_motion
{
  [self RCB3J_send_cmd:RCB3J_CMD_GET_WAKEUP_MOTION:1:3];
  return 1;
}

- (int) RCB3J_set_wakeup_motion:(unsigned char) option: (unsigned char) btn: (unsigned char) stp
{
  RCB3J_send_buffer[2] = btn;
  RCB3J_send_buffer[3] = stp;
  [self RCB3J_send_cmd_opt:RCB3J_CMD_SET_WAKEUP_MOTION:option:4:1];
  return 1;
}


- (int) RCB3J_get_dying_motion
{
  [self RCB3J_send_cmd:RCB3J_CMD_GET_DYING_MOTION:1:4];
  return 1;
}

- (int) RCB3J_set_dyingp_motion:(unsigned char) option: (unsigned short) lvl: (unsigned char) mtn
{
  RCB3J_send_buffer[2] = mtn;
  RCB3J_send_buffer[3] = (lvl >> 8) & 0x3;
  RCB3J_send_buffer[4] = lvl & 0xff;
  [self RCB3J_send_cmd_opt:RCB3J_CMD_SET_DYING_MOTION:option:5:1];
  return 1;
}


- (int) RCB3J_get_version
{
  [self RCB3J_send_cmd:RCB3J_CMD_GET_RCB3J_VERSION:1:65];
  return 1;
}

- (int) RCB3J_get_soft_sw:(unsigned char) option
{
  [self RCB3J_send_cmd_opt:RCB3J_CMD_GET_SOFT_SW:option:2:3];
  return 1;
}

- (int) RCB3J_set_soft_sw:(unsigned char) option: (unsigned char) swh: (unsigned char) swl
{
  RCB3J_send_buffer[2] = swh;
  RCB3J_send_buffer[3] = swl;
  [self RCB3J_send_cmd_opt:RCB3J_CMD_SET_SOFT_SW:option:4:1];
  return 1;
}


- (int) RCB3J_play_motion:(unsigned char) option: (unsigned char) mot
{
  RCB3J_send_buffer[2] = mot;
  [self RCB3J_send_cmd_opt:RCB3J_CMD_PLAY_MOTION:option:3:1];
  return 1;
}


- (int) RCB3J_get_angles
{
  [self RCB3J_send_cmd:RCB3J_CMD_GET_ANGLES:1:49];
  return 1;
}


- (int) RCB3J_set_joint_param:(unsigned char) option:(unsigned char) joint_num:(unsigned char) speed:(unsigned short) param
{
  RCB3J_send_buffer[2] = joint_num;
  RCB3J_send_buffer[3] = speed;
  RCB3J_send_buffer[4] = param >> 8;
  RCB3J_send_buffer[5] = param & 0xff;
  [self RCB3J_send_cmd_opt:RCB3J_CMD_SET_JOINT_PARAM:option:6:1];
  return 1;
}


- (int) RCB3J_set_all_joint_param:(unsigned char) option: (unsigned char) joint_num
{
  return 1;
}


- (int) RCB3J_get_all_joint_param:(unsigned char) option: (unsigned char) joint_num
{
  //    RCB3J_send_buffer[2] = joint_num;
  //    RCB3J_send_cmd_opt(RCB3J_CMD_GET_ALL_JOINT_PARAM, option, 3, 1);
  return 1;
}


- (int) RCB3J_print_receive_buffer:(int) size
{
  int i;
  for( i=0;i<size;i++)
    {
      printf("[%02X]", RCB3J_receive_buffer[i]);
    }
  printf("\n");
  return 1;
}


/* --------------------------------------------------------------------- */
/* メイン                                                                */
/* --------------------------------------------------------------------- */

- (KHRInterface *)init
{
  // デバイスファイル（シリアルポート）オープン
  fd = open(DEV_NAME,O_RDWR);
  if(fd<0){
    // デバイスの open() に失敗したら
    perror("fail to open device");
  }else{
    [self serial_init];
    tcflush(fd, TCIOFLUSH);
  }
  return [super init];
}

//         printf("gs : get settings\n");
//         printf("00 : set soft switch all off\n");
//         printf("p number : play motion\n");
//         printf("a : get angles\n");
//         printf("g number : free joint and get anlge\n");

- (int)getSettings
{
  printf("get RCB3J version : ");
  [self RCB3J_get_version];
  printf("[%s]\n", RCB3J_receive_buffer);
  printf("get wakeup motion : ");
  [self RCB3J_get_wakeup_motion];
  [self RCB3J_print_receive_buffer:3];
  printf("get dying motion : ");
  [self RCB3J_get_dying_motion];
  [self RCB3J_print_receive_buffer:4];
  printf("get soft switch : ");
  [self RCB3J_get_soft_sw:(RCB3J_OPT_ACK_ON | RCB3J_OPT_EEPROM)];
  [self RCB3J_print_receive_buffer:3];
  return 0;
}

- (int)OO
{
  printf("set soft switch all 0\n");
  [self RCB3J_set_soft_sw:(RCB3J_OPT_ACK_ON | RCB3J_OPT_EEPROM):0:0];
  return 0;
}

- (int)d
{
  printf("set soft switch all 0\n");
  [self RCB3J_set_soft_sw:(RCB3J_OPT_ACK_ON | RCB3J_OPT_EEPROM):2:4];
  return 0;
}

- (int)getAngles
{
  printf("get angles\n");
  [self RCB3J_get_angles];
  [self RCB3J_print_receive_buffer:49];
  return 0;
}

// while(1) ??
- (int)freeJointAndGetAngles:(int)i
{
  printf("free joint and get angle\n");
  while(1) {
    [self RCB3J_set_joint_param:RCB3J_OPT_ACK_ON:i:1:
	    RCB3J_MOT_PARAM_FREE];
    [self RCB3J_get_angles];
    /*                 RCB3J_print_receive_buffer(49); */
    printf("angle = %d\n",
	   ((unsigned short)RCB3J_receive_buffer[i*2])*0x100+
	   ((unsigned short)RCB3J_receive_buffer[i*2+1]));
    usleep(100*1000);
  }
  return 0;
}

- (int)setJointAngle:(int)i
{
  printf("set joint angle\n");
  [self RCB3J_set_joint_param:RCB3J_OPT_ACK_ON:i:10:30000];
  return 0;
}

- (int)playMotion:(int)i
{
  printf("play motion\n");
  [self RCB3J_play_motion:RCB3J_OPT_ACK_ON:(i & 0xff)];
  return 0;
}
 
- (void)dealloc
{
  close(fd);
  [super dealloc];
}

@end
