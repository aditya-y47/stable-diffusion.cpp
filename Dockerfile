ARG UBUNTU_VERSION=22.04

# Build stage
FROM ubuntu:$UBUNTU_VERSION AS build

RUN apt-get update -y && apt-get install -y build-essential git cmake wget

WORKDIR /sd.cpp
COPY . .

# Install Vulkan SDK
RUN wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | tee /etc/apt/trusted.gpg.d/lunarg.asc && \
    wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.4.309-jammy.list https://packages.lunarg.com/vulkan/1.4.309/lunarg-vulkan-1.4.309-jammy.list && \
    apt update -y && apt install -y vulkan-sdk

# Build the application
RUN mkdir build && cd build && \
    cmake .. -DSD_VULKAN=ON && \
    cmake --build . --config Release

# Runtime stage
FROM ubuntu:$UBUNTU_VERSION AS runtime



RUN apt-get update -y && apt-get install -y wget

# Install Vulkan SDK
RUN wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | tee /etc/apt/trusted.gpg.d/lunarg.asc && \
    wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.4.309-jammy.list https://packages.lunarg.com/vulkan/1.4.309/lunarg-vulkan-1.4.309-jammy.list && \
    apt update -y && apt install -y vulkan-sdk

# Install Vulkan runtime dependencies
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update -y && \
    apt-get install -y libvulkan1 vulkan-utils

# Copy the binary
COPY --from=build /sd.cpp/build/bin/sd /sd

RUN chomod 666 /dev/dri/card1 || true
ENTRYPOINT [ "/sd" ]