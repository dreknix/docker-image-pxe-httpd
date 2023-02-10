# Docker image for HTTP server in PXE

This Docker image provides a HTTP server based on Python and Flask for a
netboot environment. It is part of the Docker compse
[PXE service](https://github.com/dreknix/docker-compose-pxe). The HTTP server
provides a iPXE boot menu and several installation and live systems are
supported. In order to boot iPXE the compatible
[Docker image](https://github.com/dreknix/docker-image-pxe-tftpd) should be
used.

The image is also available from
[Docker Hub](https://hub.docker.com/r/dreknix/pxe-httpd):

```console
$ docker pull dreknix/pxe-httpd
```

## License

[MIT](https://github.com/dreknix/docker-image-pxe-httpd/blob/main/LICENSE)
