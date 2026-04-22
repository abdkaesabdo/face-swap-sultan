# 1. استخدام صورة بايثون الرسمية المبنية على Debian Bookworm
# هذه الصورة مستقرة جداً ولا تعاني من مشاكل مستودعات نيفيديا/أوبونتو (الخطأ 100)
FROM python:3.12-slim-bookworm

# منع التوقف للأسئلة التفاعلية
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# 2. تثبيت المكتبات النظامية (بأمر واحد نظيف ومباشر)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 3. تحديث Pip وأدوات البناء
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# 4. تثبيت مكتبات الذكاء الاصطناعي (دعم CUDA 12.1)
# سنقوم بجلب المكتبات من مستودع PyTorch الرسمي مباشرة لضمان السرعة
RUN pip install --no-cache-dir \
    torch==2.3.0 \
    torchvision==0.18.0 \
    --index-url https://download.pytorch.org/whl/cu121

# تثبيت بقية مستلزمات Face Swap
RUN pip install --no-cache-dir \
    numpy==1.26.4 \
    onnx==1.16.0 \
    onnxruntime-gpu==1.17.1 \
    insightface==0.7.3 \
    opencv-python-headless \
    gfpgan \
    basicsr \
    facexlib \
    tqdm \
    pillow

# 5. إعداد مجلد العمل والهيكل
WORKDIR /app
RUN mkdir -p models/_cache models/swap models/insightface/models/buffalo_l

# 6. نسخ الملفات
COPY . .

# 7. التشغيل
CMD ["python", "main.py"]
