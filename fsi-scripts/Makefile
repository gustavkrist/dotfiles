FSPACK_FLAGS := --framework net11.0 -nsc -sf --aot
SRCS := $(shell gfind . -maxdepth 1 -name '*.fsx' -printf '%P\n')
TARGETS := $(SRCS:.fsx=)
INSTALL_TARGETS := $(addprefix install-,$(TARGETS))

.DELETE_ON_ERROR:
.PHONY: all
all: $(TARGETS)

.PHONY: install
install: $(INSTALL_TARGETS)

install-%: %
	ln -nfs "$(PWD)/$^/$^" "$(HOME)/.local/bin/$^"

$(TARGETS): $(SRCS)
	fspack "$@.fsx" -o "$@" --framework net11.0 -nsc -sf --aot

.PHONY: clean
clean:
	rm -rf $(TARGETS)

.PHONY: uninstall
uninstall:
	@for bin in $(TARGETS); do \
		echo rm -f "$(HOME)/.local/bin/$$bin"; \
		rm -f "$(HOME)/.local/bin/$$bin"; \
	done
