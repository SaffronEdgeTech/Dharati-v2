# Base image with Android SDK and necessary dependencies
FROM mobiledevops/android-sdk-image

# Set working directory
WORKDIR /app

# Copy the archived APK to the container
COPY build/app/outputs/flutter-apk/app-release.apk .

# Expose port 5000 for the Android application
EXPOSE 5000

# Start the application
CMD ["java", "-jar", "app-release.apk"]
