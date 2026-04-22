# الأساس المستقر (Debian Bookworm)
FROM python:3.12-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_DEFAULT_TIMEOUT=100

# 1. تثبيت أدوات النظام
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg libsm6 libxext6 libgl1-mesa-glx git wget curl \
    && rm -rf /var/lib/apt/lists/*

# 2. تحديث pip وتثبيت أدوات التوافق (هذا السطر هو الحل!)
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# 3. تثبيت Torch أولاً (لأنه الأساس)
RUN pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cu121

# 4. تثبيت المكتبات (بترتيب خاص لتجنب الخطأ الذي ظهر لك)
RUN pip install --no-cache-dir numpy==1.26.4 onnx==1.16.0 onnxruntime-gpu==1.17.1
RUN pip install --no-cache-dir opencv-python-headless pillow tqdm

# 5. حل مشكلة basicsr و gfpgan (تثبيتهم بدون فحص التبعيات الصارم)
RUN pip install --no-cache-dir insightface==0.7.3
RUN pip install --no-cache-dir gfpgan basicsr facexlib

WORKDIR /app
RUN mkdir -p models/_cache models/swap models/insightface/models/buffalo_l
COPY . .

CMD ["python", "main.py"]
