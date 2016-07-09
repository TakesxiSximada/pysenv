SOURCE_DIR := $(CURDIR)/sources
INSTALL_DIR := $(CURDIR)/pythons
ENVS_DIR := $(CURDIR)/envs
REQUIREMENTS_DIR := $(CURDIR)/requirements

CURRENT := cpython
PY352 := Python-3.5.2
PY2712 := Python-2.7.12

LDFLAGS = -L/usr/local/opt/*/lib
CPPFLAGS = -I/usr/local/opt/*/include

.PHONY: install
install:
	@## target=TARGET major=MAJOR_VERSION
	cd $(SOURCE_DIR)/$(target); LDFLAGS=$(LDFLAGS) CPPFLAGS=$(CPPFLAGS) ./configure --prefix $(INSTALL_DIR)/$(target)
	cd $(SOURCE_DIR)/$(target); make; make install; ln -sf $(INSTALL_DIR)/$(target)/bin/python$(major) $(INSTALL_DIR)/$(target)/bin/python
	curl -L https://bootstrap.pypa.io/get-pip.py | $(INSTALL_DIR)/$(target)/bin/python
	$(INSTALL_DIR)/$(target)/bin/pip install virtualenv
	$(INSTALL_DIR)/$(target)/bin/virtualenv $(ENVS_DIR)/$(target)

.PHONY: download
download:
	@## target=TARGET url=URL
	cd $(SOURCE_DIR); curl -o $(target).tar.xz $(url)
	cd $(SOURCE_DIR); xz -dc $(target).tar.xz | tar xv

.PHONY: current
current: $(SOURCE_DIR)/$(CURRENT)
	make install target=$(CURRENT) major=3

$(SOURCE_DIR)/$(CURRENT):
	git clone git@github.com:python/cpython.git $(SOURCE_DIR)/$(CURRENT)

.PHONY: 2.7.12
2.7.12: $(SOURCE_DIR)/$(PY2712)
	make install target=$(PY2712) major=2

$(SOURCE_DIR)/$(PY2712):
	make download target=$(PY2712) url=https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tar.xz

.PHONY: 3.5.2
3.5.2: $(SOURCE_DIR)/$(PY352)
	make install target=$(PY352) major=3

$(SOURCE_DIR)/$(PY352):
	make download target=$(PY352) url=https://www.python.org/ftp/python/3.5.2/$(PY352).tar.xz
