## Persistent Data

Untuk praktek mengenai persistent data di docker, kita akan menjalankan dua container, yaitu **MySQL** dan **Todo-list** yang sebelumnya telah kita buat.
Untuk MySQL kita akan menggunakan **docker volume** dan untuk todo-list app akan menggunakan metode **bind mount**.

Dan juga kita akan mempraktekan multi container dan docker network.
Ingat, bahwa jika container berada di network yang sama, maka semua container tersebut dapat saling berkomunikasi satu sama lain dengan menggunakan DNS.


## MySQL dengan docker volume

Ikuti langkah-langkah berikut :

1. Buat docker network.
    ```bash
    docker network create todo_net
    ```
1. Buat docker volume.

    ```bash
    docker volume create mysql-data
    ```

1. Start MySQL container dan attach network dan volume yang sudah kita buat sebelumnya.
Untuk lebih detail tentang cara menjalankan container MySQL, lihat di [MySQL Docker Hub listing](https://hub.docker.com/_/mysql/).

    ```bash
    docker run -it -d --name mysql \
        --network todo_net --network-alias mysql \
        -v mysql-data:/var/lib/mysql \
        -e MYSQL_ROOT_PASSWORD=Password1 \
        -e MYSQL_DATABASE=todos \
        mysql:5.7
    ```

1. Pastikan container database sudah running dan sudah bisa login.

    ```bash
    docker exec -it <mysql-container-id> mysql -p
    ```

    ```cli
    mysql> SHOW DATABASES;
    ```

    Pastikan database todos sudah ada:

    ```plaintext
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | performance_schema |
    | sys                |
    | todos              |
    +--------------------+
    5 rows in set (0.00 sec)
    ```


## Menjalankan container todo-apps dengan MySQL

Tambahkan environment berikut pada saat menjalankan container todo-apps:

- `MYSQL_HOST` - mysql
- `MYSQL_USER` - root
- `MYSQL_PASSWORD` - Password1
- `MYSQL_DB` - todos


1. Masuk kedalam folder `app` (yang sebelumnya sudah kita clone di pertemuan 4)
1. Jalankan container todo-apps dengan command berikut:

    ```bash hl_lines="3 4 5 6 7"
    docker run -it -d --name todo-apps -p 3000:3000 \
      -w /app -v "$(pwd):/app" \
      --network todo_net \
      -e MYSQL_HOST=mysql \
      -e MYSQL_USER=root \
      -e MYSQL_PASSWORD=Password1 \
      -e MYSQL_DB=todos \
      node:12-alpine \
      sh -c "yarn install && yarn run dev"
    ```

1. Cek log container (`docker logs <container-id>`)

    ```plaintext hl_lines="7"
    # Previous log messages omitted
    $ nodemon src/index.js
    [nodemon] 1.19.2
    [nodemon] to restart at any time, enter `rs`
    [nodemon] watching dir(s): *.*
    [nodemon] starting `node src/index.js`
    Connected to mysql db at host mysql
    Listening on port 3000
    ```

1. Buka aplikasi melalui browser `http://localhost:3000/` dan tambahkan item pada todo list.

1. Konek ke database MySQL, pastikan item yang ditambahkan sudah ada di database

    ```bash
    docker exec -it <mysql-container-id> mysql -p todos
    ```

    ```plaintext
    mysql> select * from todo_items;
    +--------------------------------------+--------------------+-----------+
    | id                                   | name               | completed |
    +--------------------------------------+--------------------+-----------+
    | e8bba339-0c25-4559-896b-1d7d8211207d | Pertemuan 5        |         0 |
    +--------------------------------------+--------------------+-----------+
    ```

## OPTIONAL
Kita juga bisa menjalankan container todo-app menggunakan image yang sudah kita buat di pertemuan sebelumnya.
Untuk mencobanya, jalankan command berikut :
```bash hl_lines="3 4 5 6 7"
docker run -it -d --name todo-apps -p 3000:3000 \
    --network todo_net \
    -e MYSQL_HOST=mysql \
    -e MYSQL_USER=root \
    -e MYSQL_PASSWORD=Password1 \
    -e MYSQL_DB=todos \
    ademahmudf/todo-app:v1
```
Sesuaikan nama image sesuai dengan nama image masing-masing.