# Use the official Flutter image as the base image
FROM mobiledevops/flutter-sdk-image as build

# Set the working directory in the container
WORKDIR /app

# Copy the pubspec.* files to the container
COPY pubspec.* ./

# Run Flutter pub get to install dependencies
RUN flutter pub get

# Copy the entire project to the container
COPY . .

# Build the Flutter APK
RUN flutter build apk

# Use the official NGINX image as the base image for the final image
FROM nginx

# Copy the built APK from the previous stage to the NGINX root directory
COPY --from=build /app/build/app/outputs/flutter-apk/app-release.apk /usr/share/nginx/html/app-release.apk

# Expose the NGINX default port
EXPOSE 80
