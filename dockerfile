# 第一阶段：构建 Hexo 静态文件
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --registry=https://registry.npmmirror.com  # 国内源加速
COPY . .
RUN npx hexo clean && npx hexo generate

# 第二阶段：Nginx 提供静态页面
FROM nginx:stable-alpine
# 关键：留空默认配置，通过宝塔挂载自定义配置
RUN rm -f /etc/nginx/conf.d/default.conf
# 复制静态文件
COPY --from=builder /app/public /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://127.0.0.1/healthz || exit 1
CMD ["nginx", "-g", "daemon off;"]