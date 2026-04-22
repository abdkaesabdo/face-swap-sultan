# القاعدة الحديثة التي طلبتها
FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# حل مشكلة الخطأ 100: تحديث المفاتيح والمستودعات بشكل آمن
RUN apt-get update || true && \
    apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
    apt-get update && apt-get install -y \
    software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && apt-get install -y \
    python3.12 \
    python3.12-dev \
    python3.12-distutils \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# ربط النسخ وتثبيت pip لنسخة 3.12
RUN ln -sf /usr/bin/python3.12 /usr/bin/python3 && \
    ln -sf /usr/bin/python3.12 /usr/bin/python && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12

# تثبيت كامل المكتبات التي طلبتها وبالنسخ الحديثة
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel && \
    python3 -m pip install --no-cache-dir \
    numpy==1.26.4 \
    onnx==1.16.0 \
    onnxruntime-gpu==1.17.1 \
    insightface==0.7.3 \
    opencv-python-headless==4.10.0.84 \
    pillow==10.3.0 \
    tqdm==4.66.4 \
    basicsr==1.4.2 \
    facexlib==0.3.0 \
    gfpgan==1.3.8 \
    torch==2.3.0 --index-url https://download.pytorch.org/whl/cu121 \
    torchvision==0.18.0 --index-url https://download.pytorch.org/whl/cu121

WORKDIR /app
RUN mkdir -p models/_cache models/swap models/insightface/models/buffalo_l

COPY . .

CMD ["python3", "main.py"]
