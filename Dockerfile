# Base image
FROM openjdk:8-jdk-alpine

# Set working directory
WORKDIR /app

# Copy APK from Jenkins workspace to container
COPY build/app/outputs/flutter-apk/app-release.apk app-release.apk

# Expose port
EXPOSE 8080

# Start the app
CMD ["java", "-jar", "app-release.apk"]
