# 1. القاعدة: Ubuntu مع CUDA 12.1 لدعم كرت الشاشة
FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

# منع التوقف لطلب مدخلات أثناء التثبيت
ENV DEBIAN_FRONTEND=noninteractive

# 2. تثبيت المتطلبات وبايثون 3.12 مع الأدوات اللازمة للبناء
RUN apt-get update && apt-get install -y \
    software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python3.12 \
    python3.12-dev \
    python3.12-distutils \
    python3.12-venv \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    wget \
    unzip \
    git && \
    rm -rf /var/lib/apt/lists/*

# 3. ربط نسخ بايثون وتثبيت pip يدوياً (لحل مشكلة 3.12)
RUN ln -sf /usr/bin/python3.12 /usr/bin/python3 && \
    ln -sf /usr/bin/python3.12 /usr/bin/python && \
    wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

# 4. تحديث أدوات التثبيت الأساسية
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# 5. تثبيت مكتبات الذكاء الاصطناعي (متوافقة مع CUDA 12.1)
RUN python3 -m pip install --no-cache-dir \
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

# 6. إعداد هيكل المجلدات داخل الحاوية
WORKDIR /app
RUN mkdir -p models/_cache models/swap models/insightface/models/buffalo_l

# 7. نسخ ملفات مشروعك بالكامل إلى الحاوية
COPY . .

# 8. أمر التشغيل الافتراضي (تأكد أن ملفك الأساسي اسمه main.py)
CMD ["python3", "main.py"]
