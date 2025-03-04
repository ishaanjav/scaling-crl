slides = ant_results other_results

all: $(shell hdeps index.html)

ifdef slides
$(foreach idx,$(shell seq 1 $(words $(slides))),\
	$(eval static/figures/$(word $(idx),$(slides)).svg: build/slide$(idx).pdf))

$(foreach idx,$(shell seq 1 $(words $(slides))),%/slide$(idx).pdf): figures.key | build static/figures
	keysplit --crop $< $*
endif

slides: $(foreach fig,$(slides),static/figures/$(fig).svg)

$(foreach fig,$(slides),static/figures/$(fig).svg):
	pdf2svg $< $@

static/%.svg: static/%.pdf
	pdf2svg $< $@

static/pdf/horizon_generalization.pdf: ~/papers/invariance/horizon_generalization.pdf
	cp $< $@

static/videos/%.png: static/videos/%.mp4
	ffmpeg -i $< -ss 00:00:01 -vframes 1 $@

static/figures/%.pdf: ~/papers/invariance/figures/%.pdf
	cp $< $@

build:
	mkdir -p $@

clean:
	rm -rf build
