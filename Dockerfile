FROM openjdk:11-jdk-slim

# Copy the APK into the image
COPY build/app/outputs/flutter-apk/app-release.apk app-release.apk

# Install ADB
RUN apt-get update && apt-get install -y adb

# Expose ADB port
EXPOSE 5037

# Start ADB server
CMD ["adb", "start-server"]

# Start the app
ENTRYPOINT ["adb", "install", "-r", "app-release.apk"]
