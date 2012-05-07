PACKAGE_NAME = wdb-partition
VERSION = 0.1.0

PREFIX = $(DESTDIR)/usr
SQLDIR = $(PREFIX)/share/$(PACKAGE_NAME)
BINDIR = $(PREFIX)/bin

BIN_SOURCES = wdb-create-partition.sh wdb-setup-partition.sh
SQL_SOURCES = setup_partitioning.sql partition_wdb.sql
ALL_DIST_FILES = $(BIN_SOURCES) $(SQL_SOURCES) Makefile

BUILT_FILES = $(BIN_SOURCES:.sh=)

all:	$(BUILT_FILES)


wdb-create-partition:	wdb-create-partition.sh
	sed s_SHAREDIR\=\._SHAREDIR=$(SQLDIR)_g $< > $@
	
wdb-setup-partition: wdb-setup-partition.sh
	sed s_SHAREDIR\=\._SHAREDIR=$(SQLDIR)_g $< > $@

clean:
	rm -f $(BUILT_FILES)


install:	all
	mkdir -p $(SQLDIR)
	install -m444 -t $(SQLDIR) $(SQL_SOURCES)
	mkdir -p $(BINDIR)
	install -t $(BINDIR) $(BUILT_FILES)

uninstall:
	cd $(BINDIR) && rm -f $(BUILT_FILES)
	cd $(SQLDIR) && rm -f $(SQL_SOURCES)

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
