variable "IMAGE" {
	default = "npm-http2-ci"
}
variable "NPM_VERSION" {
	default = "2.17.0"
}
variable "NPM_SOURCE_COMMIT" {
	default = "5c8aec9bdeca0a2fb6a71e060ec598aa6eddd186"
}
variable "PATCH_REVISION" {
	default = "dev"
}
variable "BUILD_DATE" {
	default = ""
}

target "certbot-node" {
	tags = ["${IMAGE}:certbot-node", "${IMAGE}:certbot-node-${PATCH_REVISION}"]
}

target "proxy-manager" {
	inherits = ["common"]
	context = "npm-source"
	dockerfile = "docker/Dockerfile"
	contexts = {
		patched-base = "target:certbot-node"
	}
	args = {
		BASE_IMAGE = "patched-base"
		BUILD_VERSION = NPM_VERSION
		BUILD_COMMIT = NPM_SOURCE_COMMIT
		BUILD_DATE = BUILD_DATE
	}
	tags = ["${IMAGE}:latest", "${IMAGE}:${NPM_VERSION}-http2-${PATCH_REVISION}"]
	labels = {
		"org.opencontainers.image.revision" = PATCH_REVISION
	}
}
