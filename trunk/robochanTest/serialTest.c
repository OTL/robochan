#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <termios.h>
#include <time.h>

//#define DEV_NAME    "/dev/ttyS11"        // デバイスファイル名
#define DEV_NAME    "/dev/tty.iap"        // デバイスファイル名
#define BAUD_RATE    B115200                // RS232C通信ボーレート
//#define BAUD_RATE    B9600                // RS232C通信ボーレート

#define RCB3J_OPT_ACK_ON 1
#define RCB3J_OPT_EEPROM 2
#define RCB3J_OPT_FORCE_PLAY 4

static int fd = -1;
static unsigned char RCB3J_send_buffer[128];
static unsigned char RCB3J_receive_buffer[128];

// シリアルポートの初期化
void serial_init()
{
    struct termios tio;
    memset(&tio,0,sizeof(tio));
    tio.c_cflag = CS8 | CLOCAL | CREAD;
    tio.c_cc[VTIME] = 0;
    tio.c_cc[VMIN] = 100; // これが必要
    // ボーレートの設定
    cfsetispeed(&tio,BAUD_RATE);
    cfsetospeed(&tio,BAUD_RATE);
    // デバイスに設定を行う
    tcsetattr(fd,TCSANOW,&tio);
}

int RCB3J_send(int size)
{
    int i;
    unsigned char sum = 0;
    unsigned char buf[1];

    // send OK?
    buf[0] = 0x0d;
    write(fd, buf, 1);
    //    tcflush(fd, TCOFLUSH);
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
	//        tcflush(fd, TCOFLUSH);
    }

    return 1;
}
int RCB3J_receive(int size)
{
    
    read(fd, RCB3J_receive_buffer, size);
    //    tcflush(fd, TCIFLUSH); // 他は読み捨て
    return 1;
}

int RCB3J_send_cmd(unsigned char command, int size, int ack_size)
{
    RCB3J_send_buffer[0] = command;
    RCB3J_send(size);
    RCB3J_receive(ack_size);
    return 1;
}

int RCB3J_send_cmd_opt(unsigned char command, unsigned char option, int size, int ack_size)
{
    RCB3J_send_buffer[0] = command;
    RCB3J_send_buffer[1] = option;
    RCB3J_send(size);
    if (option & RCB3J_OPT_ACK_ON) 
    {
        RCB3J_receive(ack_size);
    }
    return 1;
}

#define RCB3J_CMD_GET_WAKEUP_MOTION 0xee
#define RCB3J_CMD_SET_WAKEUP_MOTION 0xef
int RCB3J_get_wakeup_motion()
{
    RCB3J_send_cmd(RCB3J_CMD_GET_WAKEUP_MOTION, 1, 3);
    return 1;
}

int RCB3J_set_wakeup_motion(unsigned char option, unsigned char btn, unsigned char stp)
{
    RCB3J_send_buffer[2] = btn;
    RCB3J_send_buffer[3] = stp;
    RCB3J_send_cmd_opt(RCB3J_CMD_SET_WAKEUP_MOTION, option, 4, 1);
    return 1;
}


#define RCB3J_CMD_GET_DYING_MOTION 0xeb
#define RCB3J_CMD_SET_DYING_MOTION 0xec
int RCB3J_get_dying_motion()
{
    RCB3J_send_cmd(RCB3J_CMD_GET_DYING_MOTION, 1, 4);
    return 1;
}

int RCB3J_set_dyingp_motion(unsigned char option, unsigned short lvl, unsigned char mtn)
{
    RCB3J_send_buffer[2] = mtn;
    RCB3J_send_buffer[3] = (lvl >> 8) & 0x3;
    RCB3J_send_buffer[4] = lvl & 0xff;
    RCB3J_send_cmd_opt(RCB3J_CMD_SET_DYING_MOTION, option, 5, 1);
    return 1;
}

#define RCB3J_CMD_GET_RCB3J_VERSION 0xff
int RCB3J_get_version()
{
    RCB3J_send_cmd(RCB3J_CMD_GET_RCB3J_VERSION, 1, 65);
    return 1;
}

#define RCB3J_CMD_GET_SOFT_SW 0xf1
#define RCB3J_CMD_SET_SOFT_SW 0xf2
int RCB3J_get_soft_sw(unsigned char option)
{
    RCB3J_send_cmd_opt(RCB3J_CMD_GET_SOFT_SW, option, 2, 3);
    return 1;
}

int RCB3J_set_soft_sw(unsigned char option, unsigned char swh, unsigned char swl)
{
    RCB3J_send_buffer[2] = swh;
    RCB3J_send_buffer[3] = swl;
    RCB3J_send_cmd_opt(RCB3J_CMD_SET_SOFT_SW, option, 4, 1);
    return 1;
}

#define RCB3J_CMD_PLAY_MOTION 0xf4
int RCB3J_play_motion(unsigned char option, unsigned char mot)
{
    RCB3J_send_buffer[2] = mot;
    RCB3J_send_cmd_opt(RCB3J_CMD_PLAY_MOTION, option, 3, 1);
    return 1;
}

#define RCB3J_CMD_GET_ANGLES 0xf0
int RCB3J_get_angles()
{
    RCB3J_send_cmd(RCB3J_CMD_GET_ANGLES, 1, 49);
    return 1;
}

#define RCB3J_CMD_SET_JOINT_PARAM 0xfe
int RCB3J_set_joint_param(unsigned char option,
                          unsigned char joint_num,
                          unsigned char speed,
                          unsigned short param)
{
    RCB3J_send_buffer[2] = joint_num;
    RCB3J_send_buffer[3] = speed;
    RCB3J_send_buffer[4] = param >> 8;
    RCB3J_send_buffer[5] = param & 0xff;
    RCB3J_send_cmd_opt(RCB3J_CMD_SET_JOINT_PARAM, option, 6, 1);
    return 1;
}

#define RCB3J_CMD_SET_ALL_JOINT_PARAM 0xfd
int RCB3J_set_all_joint_param(unsigned char option, unsigned char joint_num)
{
    return 1;
}

#define RCB3J_CMD_GET_ALL_JOINT_PARAM 0xfc
int RCB3J_get_all_joint_param(unsigned char option, unsigned char joint_num)
{
//    RCB3J_send_buffer[2] = joint_num;
//    RCB3J_send_cmd_opt(RCB3J_CMD_GET_ALL_JOINT_PARAM, option, 3, 1);
    return 1;
}


int RCB3J_print_receive_buffer(int size)
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
#define RCB3J_MOT_PARAM_NOTRING    0
#define RCB3J_MOT_PARAM_TTL_L      32768
#define RCB3J_MOT_PARAM_TTL_H      32769
#define RCB3J_MOT_PARAM_FREE       32770
#define RCB3J_MOT_PARAM_GET_ANGLE  32774

int main(int argc,char *argv[]){

    if (argc == 1)
    {
        printf("gs : get settings\n");
        printf("00 : set soft switch all off\n");
        printf("p number : play motion\n");
        printf("a : get angles\n");
        printf("g number : free joint and get anlge\n");
    }
    else if(argc > 1)
    {
        // デバイスファイル（シリアルポート）オープン
        fd = open(DEV_NAME,O_RDWR | O_NOCTTY);
        if(fd<0){
            // デバイスの open() に失敗したら
            perror(argv[1]);
            exit(1);
        }

        serial_init();

/* 	if (fcntl(fd, F_SETFL, 0) == -1) */
/* 	  { */
/* 	    printf("Error clearing O_NONBLOCK\n"); */
/* 	  } */
/* 	int i,j; */
/* 	unsigned char *s = "AHOGE"; */

/* 	for(i = 0; i<100; i++) */
/* 	  { */
/* 	    j = write(fd, s, 5); */
/* 	    tcflush(fd, TCOFLUSH); */
/* 	    printf("%d ", j); */
/* 	  } */
/* 	printf("\n"); */

        if (strcmp(argv[1], "gs") == 0)
        {
            printf("get RCB3J version : ");
            RCB3J_get_version();
            printf("[%s]\n", RCB3J_receive_buffer);
            printf("get wakeup motion : ");
            RCB3J_get_wakeup_motion();
            RCB3J_print_receive_buffer(3);
            printf("get dying motion : ");
            RCB3J_get_dying_motion();
            RCB3J_print_receive_buffer(4);
            printf("get soft switch : ");
            RCB3J_get_soft_sw(RCB3J_OPT_ACK_ON | RCB3J_OPT_EEPROM);
            RCB3J_print_receive_buffer(3);
        }
        else if (strcmp(argv[1], "0") == 0)
        {
            printf("set soft switch all 0\n");
            RCB3J_set_soft_sw(RCB3J_OPT_ACK_ON | RCB3J_OPT_EEPROM, 0, 0);
        }
        else if (strcmp(argv[1], "d") == 0)
        {
            printf("set soft switch all 0\n");
            RCB3J_set_soft_sw(RCB3J_OPT_ACK_ON | RCB3J_OPT_EEPROM, 2, 4);
        }
        else if (strcmp(argv[1], "a") == 0)
        {
            printf("get angles\n");
            RCB3J_get_angles();
            RCB3J_print_receive_buffer(49);
        }
        else if (strcmp(argv[1], "g") == 0)
        {

            int i = 0;
            if (argc > 2)
            {
                sscanf(argv[2], "%d", &i);
            }
            printf("free joint and get angle\n");
            while(1) {
                RCB3J_set_joint_param(RCB3J_OPT_ACK_ON,
                                      i,
                                      1,
                                      RCB3J_MOT_PARAM_FREE);//GET_ANGLE);
                RCB3J_get_angles();
/*                 RCB3J_print_receive_buffer(49); */
                printf("angle = %d\n",
                       ((unsigned short)RCB3J_receive_buffer[i*2])*0x100+
                       ((unsigned short)RCB3J_receive_buffer[i*2+1]));
                usleep(100*1000);
            }
        }
        else if (strcmp(argv[1], "s") == 0)
        {

            int i = 0;
            if (argc > 2)
            {
                sscanf(argv[2], "%d", &i);
            }
            printf("set joint angle\n");
            RCB3J_set_joint_param(RCB3J_OPT_ACK_ON,
                                  i,
                                  10,
                                  30000);
        }
        else if (strcmp(argv[1], "p") == 0)
        {
            int i = 0;
            if (argc > 2)
            {
                sscanf(argv[2], "%d", &i);
            }
            printf("play motion\n");
            RCB3J_play_motion(RCB3J_OPT_ACK_ON, (i & 0xff));
        }
        else
        {
            printf("error\n");
        }
        
        close(fd);
    }
    return 1;
}
