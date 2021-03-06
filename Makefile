#
# Makefile for FileIntegrityChecker
#

CC     := g++
CFLAGS := `pkg-config gtkmm-3.0 --cflags`
LIBS   := `pkg-config gtkmm-3.0 --libs`
OBJDIR := obj
BINDIR := bin

vpath %.cc src

objs := $(OBJDIR)/main.o \
				$(OBJDIR)/gui_main.o \
				$(OBJDIR)/gui_dialogs.o \
				$(OBJDIR)/backend/FileReader.o \
				$(OBJDIR)/backend/HashChecker.o \
				$(OBJDIR)/backend/HashGenerator.o \
				$(OBJDIR)/backend/Hash.o \
				$(OBJDIR)/backend/md5.o \
				$(OBJDIR)/backend/sha1.o

$(BINDIR)/FileIntegrityChecker : $(objs) | $(BINDIR)/gui/mainWindow.glade
	$(CC) -o $@ $(objs) $(LIBS)

$(BINDIR)/gui/mainWindow.glade : src/gui/mainWindow.glade
	mkdir -p $(@D)
	cp -f $< $@

$(OBJDIR)/backend/%.o : backend/%.cc | $(OBJDIR)/backend
	$(CC) -c $< -o $@

$(OBJDIR)/%.o : %.cc | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: all clean targz

all : $(BINDIR)/FileIntegrityChecker

clean :
	rm -rf $(BINDIR) FileIntegrityChecker.tar.gz $(OBJDIR) *~ src/*~ src/backend/*~ src/gui/*~

targz : $(BINDIR)/FileIntegrityChecker $(BINDIR)/gui/mainWindow.glade
	tar czf FileIntegrityChecker.tar.gz $^

$(OBJDIR)/backend : $(OBJDIR)
	mkdir -p $@

$(OBJDIR) :
	mkdir -p $@

