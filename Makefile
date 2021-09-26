# Default target
all:

# List of supported boards
BOARDS = promicro promicro_3v3 teensy_2 teensy_2_3v3 teensy_2pp teensy_2pp_3v3

# LUFA make flags for supported boards
FLAGS.promicro		= MCU=atmega32u4  BOARD=LEONARDO F_CPU=16000000
FLAGS.promicro_3v3	= MCU=atmega32u4  BOARD=LEONARDO F_CPU=8000000
FLAGS.teensy_2		= MCU=atmega32u4  BOARD=TEENSY2  F_CPU=16000000
FLAGS.teensy_2_3v3	= MCU=atmega32u4  BOARD=TEENSY2  F_CPU=8000000  F_USB=16000000
FLAGS.teensy_2pp	= MCU=at90usb1286 BOARD=TEENSY2  F_CPU=16000000
FLAGS.teensy_2pp_3v3	= MCU=at90usb1286 BOARD=TEENSY2  F_CPU=8000000  F_USB=16000000

ALL_HEXS = $(patsubst %,AVRISP-MKII-%.hex,$(BOARDS))

all: $(ALL_HEXS)

AVRISP-MKII-%.hex: lufa/Projects/AVRISP-MKII-%.hex
	cp -p lufa/Projects/AVRISP-MKII/AVRISP-MKII-$*.hex $@

lufa/Projects/AVRISP-MKII-%.hex: always
	$(MAKE) -C lufa/Projects/AVRISP-MKII hex $(FLAGS.$*) OBJDIR=obj-$* TARGET=AVRISP-MKII-$*

always:

ALL_CLEAN = $(patsubst %,clean-%,$(BOARDS))

clean: $(ALL_CLEAN)

$(ALL_CLEAN): clean-%:
	$(MAKE) -C lufa/Projects/AVRISP-MKII clean $(FLAGS.$*) OBJDIR=obj-$* TARGET=AVRISP-MKII-$*
	-rm -f $(ALL_HEXS)

.PHONY: all always clean $(ALL_CLEAN)
