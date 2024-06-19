KERNOBJ  = kernel-entry.o kernel-userprog.o kernel.o hardware.o libc.o list.o
USEROBJ  = user-entry.o user.o fibonacci.o corre_letras.o

CFLAGS = -O0 -fno-builtin

CC = sisa-gcc
AS = sisa-as
LD = sisa-ld
OBJCOPY = sisa-objcopy -O binary
OBJDUMP = sisa-objdump -d

all: kernel.code.bin kernel.data.bin kernel.user.bin kernel.code.hex kernel.data.hex kernel.user.hex

kernel-userprog.o: user.code.bin user.data.bin

kernel.elf: $(KERNOBJ)
	$(LD) -T kernel.ld $(KERNOBJ) -o $@

user.elf: $(USEROBJ)
	$(LD) -T user.ld $^ -o $@

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

.s.o:
	$(AS) $< -o $@

%.hex: %.bin
	@hexdump -ve '1/2 "%.4x\n"' $< > $@

%.code.bin: %.elf
	$(OBJCOPY) -j .text $< $@

%.data.bin: %.elf
	$(OBJCOPY) -j .data $< $@

%.user.bin: %.elf
	$(OBJCOPY) --set-section-flags .user=alloc,load -j .user $< $@

kdisasm: kernel.elf
	@$(OBJDUMP) $<

udisasm: user.elf
	@$(OBJDUMP) $<

clean:
	@rm -f $(KERNOBJ) $(USEROBJ) \
	kernel.elf user.elf \
	kernel.code.hex kernel.data.hex kernel.user.hex \
	kernel.code.bin kernel.data.bin kernel.user.bin \
	user.code.bin user.data.bin \

upload:
	@rm -f hexes.tar
	@tar -cf hexes.tar *.hex
	@curl -F"file=@hexes.tar" https://envs.sh
