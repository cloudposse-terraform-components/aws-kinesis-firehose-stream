export TERRAFORM_SOURCE_DIR ?= /src

all: docs

readme: docs/terraform.md
	atmos generate docs readme
	atmos generate docs component

.PHONY : docs/terraform.md
## Update `docs/terraform.md` from `terraform-docs`
docs/terraform.md:
	@echo "<!-- markdownlint-disable -->" > $@ ; \
	terraform-docs --lockfile=false md .$(TERRAFORM_SOURCE_DIR) >> $@ ; \
	echo "<!-- markdownlint-restore -->" >> $@

test::
	@echo "🚀 Starting tests..."
	./test/run.sh
	@echo "✅ All tests passed."
