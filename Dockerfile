# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    bzip2 \
    gcc \
    make \
    liblzma-dev \
    libbz2-dev \
    libsuitesparse-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /bcftools

# Download and extract bcftools
RUN wget https://github.com/samtools/bcftools/releases/download/1.18/bcftools-1.18.tar.bz2 \
    && tar xjvf bcftools-1.18.tar.bz2 \
    && rm bcftools-1.18.tar.bz2

# Change to the untarred directory from downloading
WORKDIR /bcftools/bcftools-1.18

# Download and compile plugins
RUN /bin/rm -f plugins/score.c plugins/score.h plugins/munge.c plugins/liftover.c plugins/metal.c plugins/blup.c plugins/pgs.c plugins/pgs.mk \
    && wget -P plugins https://raw.githubusercontent.com/freeseek/score/master/score.c \
    && wget -P plugins https://raw.githubusercontent.com/freeseek/score/master/score.h \
    && wget -P plugins https://raw.githubusercontent.com/freeseek/score/master/munge.c \
    && wget -P plugins https://raw.githubusercontent.com/freeseek/score/master/liftover.c \
    && wget -P plugins https://raw.githubusercontent.com/freeseek/score/master/metal.c \
    && wget -P plugins https://raw.githubusercontent.com/freeseek/score/master/blup.c \
    && make


# Move the compiled plugins and script to bin
RUN wget -P plugins https://raw.githubusercontent.com/freeseek/score/master/assoc_plot.R \
    && chmod a+x plugins/assoc_plot.R


# Set environment variables
ENV PATH="/bcftools/bcftools-1.18:$PATH"
ENV BCFTOOLS_PLUGINS="/bcftools/bcftools-1.18/plugins"

# Default command
CMD ["bcftools"]
