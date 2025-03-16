# 빌드 단계
FROM node:18-alpine as build

WORKDIR /app

# 의존성 설치
COPY package*.json ./
RUN npm ci

# 앱 소스 복사 및 빌드
COPY . .
RUN npm run build  # Vite 빌드 후 /app/dist 디렉토리가 생성됩니다.

# 빌드 결과물 확인 (디렉토리 구조 확인)
RUN ls -la /app  # 빌드가 정상적으로 되었는지 확인

# 실행 단계
FROM nginx:stable-alpine

# 빌드된 앱을 Nginx에 복사
COPY --from=build /app/dist /usr/share/nginx/html  # Vite 빌드 결과물 복사

# Nginx 설정 파일 복사
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 포트 노출
EXPOSE 80

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]
