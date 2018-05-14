# The coverage.info file is generated with:
# lcov -c --directory src/dir --output-file coverage.info
# This file must be in the same directory as the code.
# docker run -it -v src/dir:/code lcov_convertor_image
# coverage.xml will be output to the src/dir

FROM alpine:3.6

RUN apk add --no-cache --virtual build-dependencies \
    ca-certificates \
    openssl \
    wget \
    && wget -O lcov_cobertura.py https://raw.github.com/artofus/lcov-to-cobertura-xml/master/lcov_cobertura/lcov_cobertura.py \
    && apk del build-dependencies \
    && apk add --no-cache python \
    && apk add --no-cache binutils

ARG USER=jenkins
ARG UID=1001
ENV USER $USER

RUN mkdir /home/$USER \
  && addgroup -g $UID -S $USER \
  && adduser -u $UID -D -S -G $USER $USER \
  && chown -R $USER:$USER /home/$USER

USER $USER

WORKDIR /code

CMD ["coverage.info", "--base-dir", "/code"]
ENTRYPOINT ["/usr/bin/python", "/lcov_cobertura.py"]

