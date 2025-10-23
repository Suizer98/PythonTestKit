FROM ubuntu:22.04

# Set the working directory in the container
WORKDIR /usr/src/app

# Set environment variables for non-interactive apt
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN set -xe \
    && apt-get update -y --no-install-recommends \
    && apt-get install -y --no-install-recommends \
        python3-pip \
        python3.10 \
        python3.10-dev \
        build-essential \
        wget \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

COPY . .

# Create non-root user for security
RUN useradd -m -u 1000 non-root
RUN chown -R non-root:non-root /usr/src/app
# Comment out to demonstrate Semgrep finding
USER non-root

CMD ["bash"]
