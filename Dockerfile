# Etapa 1: Build
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Etapa 2: Produccion
FROM nginx:alpine
# Copiamos el build generado en la etapa anterior a la carpeta por defecto de nginx
COPY --from=build /app/dist /usr/share/nginx/html
# Configuracion base para Nginx con Vite/React Router
RUN echo 'server { listen 80; location / { root /usr/share/nginx/html; index index.html index.htm; try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf
# Exponemos el puerto 80
EXPOSE 80
# Iniciamos Nginx
CMD ["nginx", "-g", "daemon off;"]
