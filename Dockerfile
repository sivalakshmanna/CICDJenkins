# Use the .NET 6 SDK image (includes runtime and build tools)
FROM mcr.microsoft.com/dotnet/sdk:6.0

# Set the working directory inside the container
WORKDIR /app

# Copy all project files to the container
COPY . .

# Restore dependencies
RUN dotnet restore

# Build and publish the application
RUN dotnet publish -c Release -o /app/out

# Set the working directory to the published output folder
WORKDIR /app/out

# Expose the application port
EXPOSE 4000

# Run the application
ENTRYPOINT ["dotnet", "dotnetwebapp.dll", "--urls", "http://*:5000"]
