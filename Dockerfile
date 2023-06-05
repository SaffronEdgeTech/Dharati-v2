# Base image with required Android dependencies
FROM openjdk:8-jdk

# Set the working directory in the container
WORKDIR /app

# Copy the APK file to the container
COPY build/app/outputs/apk/release/app-release.apk .

# Install Node.js and NPM
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean

# Install Firebase CLI
RUN npm install -g firebase-tools

# Install Firebase SDKs and other dependencies
RUN sdkmanager --install "platform-tools" "platforms;android-29" && \
    yes | sdkmanager --licenses && \
    firebase setup:emulators:android

# Set up Firebase configuration
COPY android/app/google-services.json /app/

# Connect the APK with Firebase
RUN firebase auth:login && \
    firebase emulators:exec --only auth,firestore,functions,storage "firebase install app-release.apk"

# Expose any necessary ports for Firebase emulators
EXPOSE 8080 9000 5001

# Start the Firebase emulators
CMD ["firebase", "emulators:start", "--only", "auth,firestore,functions,storage"]
