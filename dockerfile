# 第一阶段：构建 Hexo 静态文件
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --registry=https://registry.npmmirror.com  # 国内源加速
COPY . .
RUN npx hexo clean && npx hexo generate

VOLUME ["/app/public"]
CMD ["cp", "-r", "/app/public/*", "/www/dk_project/wwwroot/bombcat.cc/"]