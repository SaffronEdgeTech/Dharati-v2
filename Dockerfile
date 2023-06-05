# Base image with required Android dependencies
FROM openjdk:8-jdk

# Set the working directory in the container
WORKDIR /app

# Install required tools and dependencies
RUN apt-get update && \
    apt-get install -y curl git unzip && \
    apt-get clean

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 && \
    export PATH="$PATH:/app/flutter/bin" && \
    flutter config --no-analytics && \
    flutter precache

# Set up Flutter environment variables
ENV PATH="/app/flutter/bin:${PATH}"
ENV FLUTTER_HOME="/app/flutter"

# Copy the Flutter project to the container
COPY . .

# Build the Flutter APK
RUN flutter pub get && \
    flutter build apk --release

# Set up Android SDK environment variables
ENV ANDROID_HOME=/usr/lib/android-sdk \
    PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Install Firebase CLI
RUN curl -sL https://firebase.tools | bash

# Set up Firebase configuration
COPY android/app/google-services.json /app/android/app/

# Connect the APK with Firebase
RUN firebase auth:login && \
    firebase emulators:exec --only auth,firestore,functions,storage "firebase install build/app/outputs/flutter-apk/app-release.apk"

# Expose any necessary ports for Firebase emulators
EXPOSE 8080 9000 5001

# Start the Firebase emulators
CMD ["firebase", "emulators:start", "--only", "auth,firestore,functions,storage"]
