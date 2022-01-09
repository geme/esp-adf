FROM fedora:34

RUN dnf -y update && dnf install -y \
	git \
	wget \
	flex \
	bison \
	gperf \
	python3 \
	python3-pip \
	python3-setuptools \
	cmake \
	ninja-build \
	ccache \
	dfu-util \
	libusbx

RUN mkdir -p /opt/esp/ 
WORKDIR /opt/esp/
RUN git clone -b v4.3.2 --recursive https://github.com/espressif/esp-idf.git
RUN git clone https://github.com/espressif/esp-adf.git

WORKDIR /opt/esp/esp-adf
RUN	git config submodule.esp-idf.update none
RUN git submodule update --init --recursive
RUN rm -rf esp-idf/ && ln -s /opt/esp/esp-idf ./esp-idf

WORKDIR /opt/esp/esp-idf
RUN ./install.sh

ENTRYPOINT ["sh", "-c", ". /opt/esp/esp-idf/export.sh && \"$@\"", "-s"]
ENV ADF_PATH=/opt/esp/esp-adf/

CMD ["/bin/bash"]

