set -ex
NAME=usb_pd_mon
CFLAGS="-V -mmcs51 --model-small --xram-size 0x0300 --xram-loc 0x0100 --code-size 0x3800 -I./include -DFREQ_SYS=24000000 -DCLOCK_FREQ_24=1"
mkdir -p build
for x in *.c ; do
  sdcc -c -o "build/${x%.*}.rel" $CFLAGS "$x"
done
sdcc build/*.rel $CFLAGS -o build/$NAME.ihx
objcopy -I ihex -O binary build/$NAME.ihx build/$NAME.bin
packihx build/$NAME.ihx > build/$NAME.hex
