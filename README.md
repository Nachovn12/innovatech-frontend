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

## GUIA DE ACTUALIZACION DE DIRECCIONES IP (AWS Learner Lab)

En entornos de AWS Learner Lab, la finalizacion de la sesion detiene automaticamente los contenedores. Al reiniciar el laboratorio, Amazon ECS asigna nuevas direcciones IP publicas a cada tarea.

Para asegurar la correcta conexion entre el frontend y los microservicios backend tras un reinicio del laboratorio, se debe ejecutar el siguiente procedimiento:

1. **Obtener Nuevas Direcciones IP**
   Navegar a la consola de AWS ECS -> Clusters -> Tareas.
   Registrar las nuevas IPs publicas correspondientes a los contenedores de `service-ventas` y `service-despachos`.

2. **Actualizar el Codigo Fuente**
   Buscar y reemplazar las cadenas de texto correspondientes a las IPs en los metodos HTTP (axios/fetch) dentro de los siguientes archivos:

   **Para el microservicio de Ventas (Puerto 8083):**
   - `src/componentes/CrudAdmin/TableCompras.jsx`: Reemplazar IP en `http://<IP>:8083/api/v1/ventas`
   - `src/componentes/CrudAdmin/FormDespacho.jsx`: Reemplazar IP en `http://<IP>:8083/api/v1/ventas/${venta.idVenta}`

   **Para el microservicio de Despachos (Puerto 8081):**
   - `src/componentes/CrudAdmin/FormDespacho.jsx`: Reemplazar IP en `http://<IP>:8081/api/v1/despachos`
   - `src/componentes/CrudAdmin/TableDespachos.jsx`: Reemplazar IP en `http://<IP>:8081/api/v1/despachos`
   - `src/componentes/CrudAdmin/FormCierreDespacho.jsx`: Reemplazar IP en `http://<IP>:8081/api/v1/despachos/${despacho.idDespacho}`

3. **Desplegar los Cambios**
   Ejecutar los siguientes comandos en la raiz del repositorio frontend para iniciar el pipeline CI/CD:
   ```bash
   git add .
   git commit -m "Update API endpoints IPs"
   git push
   ```

4. **Obtener la Direccion IP del Frontend**
   Esperar la finalizacion de la accion en GitHub. Navegar a AWS ECS, localizar la nueva tarea de `service-front` y utilizar su nueva IP publica para acceder a la aplicacion web.
