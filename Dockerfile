FROM python:2

RUN apt-get -y update && \
    apt-get -y install libopencv-dev libtesseract-dev git cmake build-essential libleptonica-dev liblog4cplus-dev libcurl3-dev beanstalkd && \
    pip install tornado

ADD webservice /webservice

ADD openalpr /usr/alpr

RUN cd /usr/alpr/src && \
      mkdir build && \
      cd build && \
      cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc .. && \
      make -j2 && \
      make install

RUN cd /usr/alpr/src/bindings/python && \
      python setup.py install && \
      ./make.sh

ENTRYPOINT ["python"]

CMD ["/webservice/openalpr_web.py"]
