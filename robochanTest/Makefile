HOST=192.168.11.3
SRCDIR=src/robochanTest/

all: install

install:
	scp serialTest.c root@$(HOST):$(SRCDIR)

install-test:
	scp serialTest.c root@$(HOST):$(SRCDIR)
	ssh root@$(HOST) "cd $(SRCDIR);make;./serialTest p 0"

make:
	scp serialTest.c root@$(HOST):$(SRCDIR)
	ssh root@$(HOST) "cd $(SRCDIR);make"

test:
	ssh root@$(HOST) "cd $(SRCDIR);./serialTest p 0"

