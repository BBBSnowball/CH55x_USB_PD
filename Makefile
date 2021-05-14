NAME=usb_pd_mon
CFLAGS=-V -mmcs51 --model-small --xram-size 0x0300 --xram-loc 0x0100 --code-size 0x3800 -I./include -DFREQ_SYS=24000000 -DCLOCK_FREQ_24=1
SOURCES=bootloader.c  ch554_conf.c  crc32.c  delay.c  main.c  usb_cdc.c  usb_desc.c  usb_endp.c  usb_ep0.c  usb_it.c  usbpd_phy.c  usb_string_desc.c
OBJS=$(patsubst %.c,build/%.rel,$(SOURCES))

.PHONY: all clean flash
all: build/$(NAME).hex build/$(NAME).bin

build:
	mkdir -p build

clean:
	rm -rf build

build/%.rel: %.c | build
	sdcc -c -o "$@" $(CFLAGS) "$<"

build/$(NAME).ihx: $(OBJS)
	sdcc $(OBJS) $(CFLAGS) -o "$@"
build/$(NAME).bin: build/$(NAME).ihx
	objcopy -I ihex -O binary "$<" "$@"
build/$(NAME).hex: build/$(NAME).ihx
	packihx "$<" > "$@"

flash: build/$(NAME).bin
	python3 -m ch55xtool -r -f "$@"

