# Base image with Android SDK
FROM openjdk:11-jdk-slim

# Set environment variables
ENV ANDROID_COMPILE_SDK=30
ENV ANDROID_BUILD_TOOLS=30.0.3
ENV ANDROID_SDK_ROOT=/sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools/
ENV PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin/

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl unzip git && \
    rm -rf /var/lib/apt/lists/*

# Download and install Android SDK
RUN mkdir /sdk && \
    cd /sdk && \
    curl -o sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip && \
    unzip sdk-tools.zip && \
    rm sdk-tools.zip && \
    echo 'count=0' > /root/.android/repositories.cfg && \
    yes | /sdk/cmdline-tools/bin/sdkmanager --licenses

# Install Android build tools and platform
RUN /sdk/cmdline-tools/bin/sdkmanager "platforms;android-$ANDROID_COMPILE_SDK" "build-tools;$ANDROID_BUILD_TOOLS"

# Copy the Android project files to the container
COPY . /app
WORKDIR /app

# Build the Android APK
RUN chmod +x ./gradlew
RUN ./gradlew assembleDebug

# Entrypoint command (adjust as needed)
CMD ["echo", "Docker container running!"]
