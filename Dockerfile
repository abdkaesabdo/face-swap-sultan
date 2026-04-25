# الأساس المستقر لعام 2026
FROM python:3.12-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_DEFAULT_TIMEOUT=100

# 1. تثبيت أدوات النظام + أدوات البناء الضرورية (دعم شامل)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg libsm6 libxext6 libgl1-mesa-glx git wget curl \
    gcc g++ python3-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. تحديث Pip وأدوات التوافق
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# 3. تثبيت المكتبات الهجينة (تعديل سلطان 2026)
# نستخدم cu121 لأنها تدعم التراجع التلقائي للمعالج في حال تعطل كرت الشاشة
RUN pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cu121
RUN pip install --no-cache-dir numpy==1.26.4 onnx==1.16.0 onnxruntime-gpu==1.17.1
RUN pip install --no-cache-dir opencv-python-headless pillow tqdm

# 4. تثبيت InsightFace
RUN pip install --no-cache-dir insightface==0.7.3

# 5. تثبيت مكتبات تحسين الجودة (GFPGAN وغيرها)
RUN pip install --no-cache-dir gfpgan basicsr facexlib

WORKDIR /app
# إنشاء المسارات اللازمة
RUN mkdir -p models/_cache models/swap models/insightface/models/buffalo_l output
COPY . .

# تشغيل المحرك الذكي
CMD ["python", "main.py"]
