MAKEFLAGS += --no-print-directory

PREFIX ?= /usr
SBINDIR ?= $(PREFIX)/sbin
MANDIR ?= $(PREFIX)/share/man

MKDIR ?= mkdir -p
INSTALL ?= install
CC ?= "gcc"

CFLAGS ?= -O2 -g
CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration

OBJS = rfkill.o version.o
ALL = rfkill

ifeq ($(V),1)
Q=
NQ=true
else
Q=@
NQ=echo
endif

all: $(ALL)


%.o: %.c rfkill.h
	@$(NQ) ' CC  ' $@
	$(Q)$(CC) $(CFLAGS) -c -o $@ $<

rfkill:	$(OBJS)
	@$(NQ) ' CC  ' rfkill
	$(Q)$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o rfkill

check:
	$(Q)$(MAKE) all CC="REAL_CC=$(CC) CHECK=\"sparse -Wall\" cgcc"

%.gz: %
	@$(NQ) ' GZIP' $<
	$(Q)gzip < $< > $@

install: rfkill rfkill.8.gz
	@$(NQ) ' INST rfkill'
	$(Q)$(MKDIR) $(DESTDIR)$(SBINDIR)
	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)$(SBINDIR) rfkill
	@$(NQ) ' INST rfkill.8'
	$(Q)$(MKDIR) $(DESTDIR)$(MANDIR)/man8/
	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)$(MANDIR)/man8/ rfkill.8.gz

clean:
	$(Q)rm -f rfkill *.o *~ *.gz version.c *-stamp
