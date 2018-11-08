CUDA_VERSION ?= "9.0"
CUDA_PATH ?= /usr/local/cuda-$(CUDA_VERSION)
lib ?= lib
CXXFLAGS += -I=$(CUDA_PATH)/include
LDFLAGS += -L=$(CUDA_PATH)/$(lib) -Wl,-rpath,$(CUDA_PATH)/$(lib)
NVCC = nvcc
LIBS = -lcuda -lcublas -lcudart

installdir = /opt/cudatests/gpu_burn

.PHONY: all
all: compare.ptx gpu_burn

compare.ptx: compare.cu
	$(NVCC) $(NVCCFLAGS) -ptx -o $@ $<

gpu_burn: gpu_burn-drv.cpp
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $< $(LIBS)

.PHONY: all
install: all
	install -d $(DESTDIR)$(installdir)
	install -m 0644 compare.ptx $(DESTDIR)$(installdir)
	install -m 0744 gpu_burn $(DESTDIR)$(installdir)

.PHONY: clean
clean:
	rm -f compare.ptx gpu_burn
