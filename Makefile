RFNOC_REPO   ?= git@gitlab.home.lan:yuriy/rfnoc-oot-blocks.git
RFNOC_COMMIT ?= 3007aa1
BUILD_DIR    ?= rfnoc-oot-blocks

PATCHES := $(sort $(wildcard *.patch))

.PHONY: all patch clean

all: patch

$(BUILD_DIR):
	git clone $(RFNOC_REPO) $(BUILD_DIR)
	cd $(BUILD_DIR) && git checkout $(RFNOC_COMMIT)

patch: $(BUILD_DIR)
	cd $(BUILD_DIR) && git am $(addprefix $(CURDIR)/,$(PATCHES))

clean:
	rm -rf $(BUILD_DIR)
