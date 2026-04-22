# 1. القاعدة الحديثة
FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# 2. التخلص من "زبالة" المستودعات المكسورة وتثبيت بايثون 3.12
RUN rm -f /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common curl git wget ffmpeg libsm6 libxext6 libgl1-mesa-glx && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends python3.12 python3.12-dev python3.12-distutils && \
    rm -rf /var/lib/apt/lists/*

# 3. تثبيت pip بشكل مباشر واحترافي لنسخة 3.12
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12

# 4. تثبيت المكتبات (مقسمة لضمان استقرار البناء ورفع الجودة)
RUN python3.12 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# تحميل Torch (أكبر جزء في الحاوية)
RUN python3.12 -m pip install --no-cache-dir \
    torch==2.3.0 torchvision==0.18.0 --index-url https://download.pytorch.org/whl/cu121

# تحميل مكتبات Face Swap (الذكاء الاصطناعي الكامل)
RUN python3.12 -m pip install --no-cache-dir \
    numpy==1.26.4 \
    onnx==1.16.0 \
    onnxruntime-gpu==1.17.1 \
    insightface==0.7.3 \
    opencv-python-headless \
    gfpgan basicsr facexlib tqdm pillow

# 5. إعداد البيئة والملفات
WORKDIR /app
RUN mkdir -p models/_cache models/swap models/insightface/models/buffalo_l
COPY . .

# توحيد الروابط
RUN ln -sf /usr/bin/python3.12 /usr/bin/python3 && ln -sf /usr/bin/python3.12 /usr/bin/python

CMD ["python3", "main.py"]
