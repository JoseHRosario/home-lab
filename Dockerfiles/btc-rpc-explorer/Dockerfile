#Build the image:docker build -t btc-rpc-explorer .

FROM node:20 AS builder
WORKDIR /workspace
# Clone the btc-rpc-explorer repo into the builder stage (shallow clone)
RUN apt-get update \
	&& apt-get install -y --no-install-recommends git ca-certificates \
	&& rm -rf /var/lib/apt/lists/* \
	&& git clone --depth 1 --single-branch https://github.com/janoside/btc-rpc-explorer . \
	&& rm -rf .git \
	&& npm install --production=false

FROM node:20-alpine
WORKDIR /workspace
COPY --from=builder /workspace .
# Ensure files are owned by UID:GID 1000 and writable by the owner.
# Avoid creating a named group/user to prevent GID conflicts in the base image.
RUN chown -R 1000:1000 /workspace \
	&& chmod -R u+rwX /workspace

USER 1000:1000
CMD ["npm", "start"]
EXPOSE 3002