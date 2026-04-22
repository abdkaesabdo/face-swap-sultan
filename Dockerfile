# القاعدة: Ubuntu مع CUDA لدعم كرت الشاشة (NVIDIA)
FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# تثبيت المتطلبات الأساسية وبايثون 3.12 (الخلية 2 و 3)
RUN apt-get update && apt-get install -y \
    software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python3.12 python3.12-dev python3-pip ffmpeg libsm6 libxext6 wget unzip git && \
    rm -rf /var/lib/apt/lists/*

# ضبط بايثون 3.12 كنسخة أساسية
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 && \
    python3 -m pip install --upgrade pip

# تثبيت المكتبات الـ 12 المحددة في الخلية 2 من ملفك
RUN python3 -m pip install \
    numpy==1.26.4 \
    onnx==1.16.0 \
    onnxruntime-gpu==1.17.1 \
    insightface==0.7.3 \
    opencv-python-headless==4.13.0.92 \
    pillow==12.1.1 \
    tqdm==4.67.3 \
    basicsr==1.4.2 \
    facexlib==0.3.0 \
    gfpgan==1.3.8 \
    torch==2.10.0 --index-url https://download.pytorch.org/whl/cu121 \
    torchvision==0.25.0 --index-url https://download.pytorch.org/whl/cu121

# إنشاء هيكل المجلدات "REQUIRED_FOLDERS" من الخلية 1
WORKDIR /app
RUN mkdir -p models/_cache models/swap models/insightface/models/buffalo_l \
    models/gfpgan models/codeformer input output logs temp Templates

CMD ["python3"]
