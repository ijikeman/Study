#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <linux/udp.h>

unsigned char packet[]={
 0x45,0x00,0x00,0x42,
 0x19,0x10,0x40,0x00,
 0x40,0x11,0xA7,0x42,
 0x3C,0x38,0xE5,0x19,
 0x3D,0xC2,0x1B,0x45,
 0x80,0xA5,0x00,0x35,
 0x00,0x2E,0xED,0x6E,
};

int main() {
  int i;
  struct udphdr *uh;

  for(i=0; i<28; i++){
   if( i && !(i%4) )
    printf("\n");
   printf("%02X", packet[i]);
  }
  printf("\n");

  uh=(struct udphdr *)&packet[20]; //キャスティング
  printf("uh->dest=%04X\n", uh->dest);
  printf("htons(uh->dest)=%d\n", htons(uh->dest) );
}
