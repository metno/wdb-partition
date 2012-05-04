PACKAGE_NAME = wdb-partition
VERSION = 0.1.0

PREFIX = /usr
SQLDIR = $(PREFIX)/share/$(PACKAGE_NAME)
BINDIR = $(PREFIX)/bin

BIN_SOURCES = create_partition.sh
SQL_SOURCES = setup_partitioning.sql partition_wdb.sql
ALL_DIST_FILES = $(BIN_SOURCES) $(SQL_SOURCES) Makefile


create_partition:	create_partition.sh
	sed s_SHAREDIR\=\._SHAREDIR=$(SQLDIR)_g $< > $@

all:	create_partition

clean:
	rm -f create_partition


install:	all
	mkdir -p $(SQLDIR)
	install -m444 -t $(SQLDIR) $(SQL_SOURCES)
	mkdir -p $(BINDIR)
	install -t $(BINDIR) $(BIN_SOURCES:.sh=)

uninstall:
	cd $(BINDIR) && rm -f $(BIN_SOURCES:.sh=)
	cd $(SQLDIR) && rm -f $(SQL_SOURCES)

dist:	
	mkdir -p wdb-partition-$(VERSION)
	cp $(ALL_DIST_FILES) wdb-partition-$(VERSION)
	tar cvzf wdb-partition-$(VERSION).tar.gz wdb-partition-$(VERSION)
	rm -r wdb-partition-$(VERSION)
