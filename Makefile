all: readme

test::
	@echo "🚀 Starting tests..."
	./test/run.sh
	@echo "✅ All tests passed."

readme:
	atmos generate docs component
	atmos generate docs readme
