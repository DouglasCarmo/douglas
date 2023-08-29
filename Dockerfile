FROM amazonlinux:2

# Atualizando e instalando pacotes
RUN yum update -y && yum upgrade -y && \
    yum install -y \
    epel-release \
    software-properties-common \
    gcc-c++ \
    make \
    cmake \
    clang \
    git \
    patch \
    curl \
    bzip2 \
    nano \
    wget \
    openssl-devel \
    libxml2-devel \
    libffi-devel \
    libxslt-devel \
    zlib-devel \
    libsqlite3x-devel \
    boost-devel \
    icu \
    python3 \
    python3-devel \
    python3-pip

# Instalando pipx
RUN python3 -m pip install --user pipx

# Clonando o repositório
RUN cd ~ && git clone https://github.com/tiagomunarolo/cpp-sas7bdat.git

# Configurando e construindo o projeto
RUN cd ~/cpp-sas7bdat && \
    make pyenv-download && \
    make pyenv-python

# Criando um ambiente virtual Python
RUN python3 -m pipx ensurepath
RUN python3 -m pipx install virtualenv
RUN python3 -m virtualenv /root/.pyenv/versions/venv38

# Ativando o ambiente virtual
ENV ACTIVATEPY /root/.pyenv/versions/venv38/bin/activate
SHELL ["/bin/bash", "-c", "source ${ACTIVATEPY}"]

# Atualizando pip e instalando pacotes Python
RUN python3 -m pip install --upgrade pip && \
    pip install wheel setuptools gcovr==5.0 numpy cmaketools conan==1.53.0

# Voltando ao shell padrão do Docker
SHELL ["/bin/sh", "-c"]

# Configurando e construindo o projeto novamente
RUN cd ~/cpp-sas7bdat && \
    source ${ACTIVATEPY} && \
    make configure && \
    make build
