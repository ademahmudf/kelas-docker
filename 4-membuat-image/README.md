## Membuat Image dengan Dockerfile

Untuk membuat sebuah docker image, kita akan membutuhkan sebuah Dockerfile. 
Format `Dockerfile` :
```
#comment
INSTRUCTION arguments
```
Untuk membuat docker image untuk aplikasi todo-list, ikuti langkah-langkah berikut :

1. Buat sebuah file bernama `Dockerfile` dengan konten seperti berikut.

    ```dockerfile
    FROM node:12-alpine
    RUN apk add --no-cache python g++ make
    WORKDIR /app
    COPY . .
    RUN yarn install --production
    CMD ["node", "src/index.js"]
    ```

    Pastikan file `Dockerfile` tidak memiliki extension `.txt`

1. Build docker image menggunakan command `docker build` command.

    ```bash
    docker build -t todo-list .
    ```

    Command tersebut akan menginstruksikan docker host untuk mengeksekusi setiap command yang kita definisikan di `Dockerfile` 
    
    - `FROM` : Mengistruksikan docker untuk menggunakan base image `node:12-alpine`
    - `RUN` : Menginstruksikan docker untuk menjalankan command `apk add --no-cache python g++ make`
    - `WORKDIR` : Mengistruksikan docker untuk menggunakan direktori `/app`
    - `COPY` : Mengistruksikan docker untuk mengcopy semua file yang ada di current folder, kedalam folder `/app` didalam image.
    - `CMD` : Mengistruksikan docker untuk mengeksekusi command `node src/index.js` pada saat container image dijalankan.

    `-t` pada command `docker build` menandakan tag image yang akan kita gunakan, dan `.` di akhir command menandakan bahwa Dockerfile berada di current direktory.

## Menjalankan Container App

Untuk menjalankan container dari image yang telah kita buat, gunakan command `docker run`

1. Start container dengan command `docker run` :

    ```bash
    docker run -it -d --name todo-list -p 3000:3000 todo-list
    ```


1. Setelah container berhasil dijalankan, buka [http://localhost:3000](http://localhost:3000).
    

1. Sekarang kita sudah bisa menggunakan aplikasi yang kita buat.