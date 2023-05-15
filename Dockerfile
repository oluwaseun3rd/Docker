FROM node:12.16.1 as build-stage
WORKDIR /app
ARG stage
COPY package*.json ./
RUN npm install
COPY . .
RUN if [ "$stage" = "staging" ]; then npm run stage ; else npm run build; fi


# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]