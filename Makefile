# Makefile for Typst document compilation

# Variables
TYPST := typst
SOURCE := rapport.typ
OUTPUT := output/rapport.pdf
REFS := references.bib
GLOSSARY := glossary.yaml

# Detect PDF viewer
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	PDF_VIEWER := xdg-open
endif
ifeq ($(UNAME_S),Darwin)
	PDF_VIEWER := open
endif

# Default target
.PHONY: all
all: $(OUTPUT)

# Compile the document
$(OUTPUT): $(SOURCE) $(REFS) $(GLOSSARY)
	$(TYPST) compile $(SOURCE) $(OUTPUT)

# Watch mode - recompile on changes
.PHONY: watch
watch:
	$(TYPST) watch $(SOURCE) $(OUTPUT)

# Open the PDF
.PHONY: open
open: $(OUTPUT)
	$(PDF_VIEWER) $(OUTPUT)

# Build and open
.PHONY: view
view: all open

# Clean generated files
.PHONY: clean
clean:
	rm -f $(OUTPUT)

# Clean all generated files including cache
.PHONY: distclean
distclean: clean
	rm -rf .typst-cache/

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all (default) - Compile the document to PDF"
	@echo "  watch         - Watch for changes and recompile automatically"
	@echo "  open          - Open the compiled PDF"
	@echo "  view          - Compile and open the PDF"
	@echo "  clean         - Remove generated PDF"
	@echo "  distclean     - Remove generated PDF and cache"
	@echo "  help          - Show this help message"

# Check if typst is installed
.PHONY: check
check:
	@which $(TYPST) > /dev/null || (echo "Error: typst not found. Please install typst." && exit 1)
	@echo "typst found: $$($(TYPST) --version)"
