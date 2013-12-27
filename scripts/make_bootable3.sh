#! /bin/bash
# v1 : FAT16 and FAT32, based on Trammel version
# v2 : exFAT supported. 
# arm.indiana@gmail.com
# v(blablabla) merged to 1 file by Bas Lichtjaar
# patch the SD/CF card bootsector to make it bootable on Canon DSLR
# See http://chdk.setepontos.com/index.php/topic,4214.0.html
#     http://en.wikipedia.org/wiki/File_Allocation_Table#Boot_Sector
#     http://www.sans.org/reading_room/whitepapers/forensics/reverse-engineering-microsoft-exfat-file-system_33274
# 
# usage: make_bootable.sh <device> (/dev/sdc1 for example)
# if things f#ck up use (dd if=/dev/zero of=/dev/sdb bs=446 count=1) to erase MBR
#
dev=$1
dump_file=exfat_dump.bin
if [ "$(whoami)" != 'root' ]; then
 echo -e "You are using a non-privileged account, you better use:\nsudo $0 $1"; exit 1
fi
[ -x ./exfat_sum ] || ( tail -47 $0 | gcc -o exfat_sum -xc - ) #c code = 47 lines from end
if [ "$#" -eq 0 ]; then
 echo -e "You better use:\n$0 <device> (/dev/sdc1 for example)"; exit 1
fi
echo -e "\nMagicLantern card pacher Only\n" 
# read the boot sector to determine the filesystem version
DEV32EX=`dd if=$dev bs=1 skip=3 count=8 2>/dev/null` 
DEV32=`dd if="$dev" bs=1 skip=82 count=8 2>/dev/null`
DEV16=`dd if="$dev" bs=1 skip=54 count=8 2>/dev/null`
if [ "$DEV16" != 'FAT16   ' -a "$DEV32" != 'FAT32   ' -a "$DEV32EX" != 'EXFAT   ' ]; then
  echo "Error: "$dev" is not a FAT16, FAT32 or EXFAT device"
  exit
fi
if [ "$DEV16" = 'FAT16   ' ]; then
  offset1=43
  offset2=64
  FS='FAT16'
elif [ "$DEV32" = 'FAT32   ' ]; then
  offset1=71
  offset2=92
  FS='FAT32'
elif [ "$DEV32EX" = 'EXFAT   ' ]; then
  offset1=130
  offset2=122
  FS='EXFAT'
fi
echo "Applying "$FS" parameters on "$dev" device:"
echo " writing EOS_DEVELOP at offset" $offset1 
echo EOS_DEVELOP | dd of="$dev" bs=1 seek=$offset1 count=11 2>/dev/null
echo " writing BOOTDISK at offset" $offset2 
echo BOOTDISK | dd of="$dev" bs=1 seek=$offset2 count=8 2>/dev/null
if [ "$FS" = 'EXFAT' ]; then
  # write them also in backup VBR, at sector 13
  echo EOS_DEVELOP | dd of="$dev" bs=1 seek=$(($offset1++512*12)) count=11 2>/dev/null
  echo BOOTDISK | dd of="$dev" bs=1 seek=$(($offset2+512*12)) count=8 2>/dev/null
  dd if=$dev of="$dump_file" bs=1 skip=0 count=6144 2>/dev/null
  echo -n ' recompute checksum. '
  ./exfat_sum "$dump_file" 
  # write VBR checksum (from sector 0 to sector 10) at offset 5632 (sector 11) and offset 11776 (sector 23, for backup VBR)
  # checksum sector is stored in $dump_file at offset 5632 
  dd of="$dev" if="$dump_file" bs=1 seek=5632 skip=5632 count=512 2>/dev/null
  dd of="$dev" if="$dump_file" bs=1 seek=11776 skip=5632 count=512 2>/dev/null
  #dd if=$dev of=verif_dump.bin bs=1 skip=0 count=12288 2>/dev/null
  rm -f "$dump_file"
fi
exit
/*
 * recompute a exFAT VBR checksum in sector 11 (first is 0)
 */

#include<stdio.h>

typedef unsigned long UINT32;

UINT32 VBRChecksum( unsigned char octets[], long NumberOfBytes) {
   UINT32 Checksum = 0;
   long Index;
   for (Index = 0; Index < NumberOfBytes; Index++) {
     if (Index != 106 && Index != 107 && Index != 112)  // skip 'volume flags' and 'percent in use'
	 Checksum = ((Checksum <<31) | (Checksum>> 1)) + (UINT32) octets[Index];
   }
   return Checksum;
}

inline unsigned long endian_swap(unsigned long x) {
   return (x<<24) | ((x>>8) & 0x0000FF00) | ((x<<8) & 0x00FF0000) | (x>>24);
}

#define SIZE (512*11)

int main(int argc, char *argv[]) {
  FILE* f;
  unsigned long buffer[SIZE+512];
  int i=0;
  unsigned long sum, swappedSum;

  f=(FILE*)fopen(argv[1], "rb+");
  if (f) {
    fread(buffer, 1, SIZE+512, f);
    printf("old=0x%lx, ", buffer[ SIZE/4 ]);
		sum = VBRChecksum((unsigned char*)buffer, SIZE);
    printf("new=0x%lx\n", sum);
//    swappedSum = endian_swap( sum );
    //    printf("0x%lx\n", swappedSum);
    for(i=0; i<512/4; i++)
      buffer[ i] = sum;  // works only in Litte Endian architectures
    fseek(f, SIZE, SEEK_SET);
    fwrite(buffer, 1, 512, f);
    fclose(f);
  }

}

