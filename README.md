# Frontend Despacho

Este es el proyecto frontend para la plataforma de Innovatech Chile. Fue construido usando React y Vite.

## Ejecución Local

Para ejecutar este proyecto en tu máquina local:
1. Asegúrate de tener Node.js instalado.
2. Ejecuta `npm install` para instalar las dependencias.
3. Ejecuta `npm run dev` para levantar el servidor de desarrollo.

## Arquitectura y Despliegue en AWS (EP3)

Este proyecto está contenedorizado y preparado para su despliegue en un clúster de **Amazon ECS**.
Utiliza un archivo `Dockerfile` multi-etapa que primero compila la aplicación usando Node.js, y luego la sirve utilizando un servidor ligero de **Nginx** en el puerto 80.

### Integración Continua y Despliegue Continuo (CI/CD)

El repositorio cuenta con un pipeline configurado en GitHub Actions (`.github/workflows/aws-deploy.yml`).

**Flujo Automático:**
Cada vez que se hace un `push` a la rama `main`:
1. El código se descarga en un runner de GitHub.
2. Se autentica en AWS mediante credenciales almacenadas en los GitHub Secrets.
3. Se compila la imagen Docker del frontend.
4. Se sube la imagen al registro de **Amazon ECR**.
5. Se invoca a **Amazon ECS** para que actualice la *Task Definition* y reinicie los contenedores (Despliegue automático).

**Requisitos Previos en GitHub Secrets:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN` (Necesario si usas AWS Academy)
