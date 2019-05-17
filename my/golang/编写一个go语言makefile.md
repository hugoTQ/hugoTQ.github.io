# 编写一个GoLand makefile

标签（空格分隔）： 未分类

---

```shell
# Go parameters

PROJECT_ROOT = $(shell pwd)
ROOT_DIR=$(shell git rev-parse --show-toplevel)
GIT_BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT = $(shell git rev-parse --short HEAD)
BUILD_DATE = $(shell date +"%F")
BUILD_TIME = $(shell date +"%T")
VERSION = V100R001C01

ifdef BV
VERSION = $(BV)
endif
$(info BVersion is ${VERSION})

COMPILER = $(shell go version | awk '{ printf "%s-%s", $$3, $$4 }')

XLDFLAGS="-X main.productVersion=${VERSION} \
    -X main.compilerVersion=${COMPILER} \
    -X main.gitBranch=${GIT_BRANCH} \
    -X main.gitCommit=${GIT_COMMIT} \
    -X main.buildDate=${BUILD_DATE} \
    -X main.buildTime=${BUILD_TIME} \
    "

SERVICE = transcode

ifeq ($(PAAS), 1.0)
VPATH = v1.0
else
VPATH = v2.0
endif

default: build

all: build test

.PHONY : all build test distclean dist clean

build: clean 
	@go build -ldflags ${XLDFLAGS} -o build/bin/${SERVICE}
	@mkdir build/lib

clean:
	rm -rf build/* 

test: build
	@cd test && make

distclean:
	rm -rf release/*

dist: distclean build
	@if [ "${VPATH}" == "v2.0" ]; then\
		echo -e "\033[31m dist do not support paas2.0 at present, pls use \"make dist PAAS=1.0\" for paas1.0.\033[0m";\
		exit 1;\
	fi

	@mkdir -p ${ROOT_DIR}/release
	@cd ${ROOT_DIR}/release
	@mkdir -p ${ROOT_DIR}/release/${SERVICE}
	@cp -r ${ROOT_DIR}/script/${VPATH}/install/* ${ROOT_DIR}/release
	@cp -r ${ROOT_DIR}/build/bin ${ROOT_DIR}/release/${SERVICE}
	@cp -r ${ROOT_DIR}/script/${VPATH}/run/* ${ROOT_DIR}/release/${SERVICE}/bin
	@cp -r ${ROOT_DIR}/build/lib ${ROOT_DIR}/release/${SERVICE}
	@cp -r ${ROOT_DIR}/conf ${ROOT_DIR}/release/${SERVICE}
	
	@cd ${ROOT_DIR}/release; mv mpc mpc_${SERVICE}
	@cd ${ROOT_DIR}/release/${SERVICE}/bin; mv real_rc real_rc${SERVICE}; mv rc rc${SERVICE}
	@cd ${ROOT_DIR}/release; sed -i "s/MAKE_DIST_SERVICE/${SERVICE}/g" `grep "MAKE_DIST_SERVICE" * -r -l`
	@cd ${ROOT_DIR}/release; tar -zcf ${SERVICE}.tar.gz *

	@echo "dist ${VPATH} finish, pkg: ${ROOT_DIR}/release/${SERVICE}.tar.gz"

```