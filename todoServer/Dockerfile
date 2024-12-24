# 使用 Python 3.11 作为基础镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 使用阿里云的 apt 源
RUN echo "deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib" > /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list

# 安装 MySQL client 和构建依赖
#RUN apt-get update
#RUN apt-get install build-essential
#RUN apt-get install pkg-config
#RUN apt-get install default-libmysqlclient-dev
#RUN apt-get install gcc
#RUN apt-get install libssl-dev
#RUN apt-get install libffi-dev
#RUN apt-get install libmariadb-dev


RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev \
    gcc \
    libssl-dev \
    libffi-dev \
    libmariadb-dev

# 设置pip源为阿里云
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ \
    && pip config set install.trusted-host mirrors.aliyun.com

# 复制项目文件到容器中
COPY . /app/

# 升级 pip
RUN pip install --upgrade pip

# 安装项目依赖
RUN pip install --no-cache-dir -r requirements.txt

# 暴露端口
EXPOSE 8000

# 启动 Django 服务器
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]