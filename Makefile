PACKAGE_NAME = wdb-partition
VERSION = 0.1.0

PREFIX = $(DESTDIR)/usr
SQLDIR = $(PREFIX)/share/$(PACKAGE_NAME)
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1/

BIN_SOURCES = wdb-create-partition.sh wdb-setup-partition.sh
SQL_SOURCES = setup_partitioning.sql partition_wdb.sql
ALL_DIST_FILES = $(BIN_SOURCES) $(SQL_SOURCES) Makefile

EXECUTABLES = $(BIN_SOURCES:.sh=)
MANPAGES = $(BIN_SOURCES:.sh=.1)

BUILT_FILES = $(EXECUTABLES) $(MANPAGES)

all:	$(BUILT_FILES)


%: %.sh
	sed s_SHAREDIR\=\._SHAREDIR=$(SQLDIR)_g $< > $@
	chmod 775 $@

%.1: %
	help2man -Nn"`./$< --help | head -n1`" ./$< > $@

clean:
	rm -f $(BUILT_FILES)


install:	all
	mkdir -p $(SQLDIR)
	install -m444 -t $(SQLDIR) $(SQL_SOURCES)
	mkdir -p $(BINDIR)
	install -t $(BINDIR) $(EXECUTABLES)
	mkdir -p $(MANDIR)
	install -t $(MANDIR) $(MANPAGES)

uninstall:
	cd $(BINDIR) && rm -f $(EXECUTABLES)
	cd $(SQLDIR) && rm -f $(SQL_SOURCES)
	cd $(MANDIR) && rm -f $(MANPAGES)

DISTFILE = wdb-partition-$(VERSION).tar.gz
ARCHITECTURE = `dpkg-architecture -qDEB_BUILD_ARCH`

dist:	
	mkdir -p wdb-partition-$(VERSION)
	cp $(ALL_DIST_FILES) wdb-partition-$(VERSION)
	tar cvzf $(DISTFILE) wdb-partition-$(VERSION)
	rm -r wdb-partition-$(VERSION)

debian: dist
	mv $(DISTFILE) ..
	dpkg-buildpackage -us -uc
	rm -r debian/wdb-partition
	lintian ../wdb-partition_$(VERSION).dsc ../wdb-partition_$(VERSION)_$(ARCHITECTURE).deb

.PHONY: all clean install uninstall dist debian
