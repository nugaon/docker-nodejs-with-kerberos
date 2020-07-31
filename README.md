# Description

This repository is the codebase of the `nugaon/nodejs-with-kerberos` docker image.

The image based on NodeJS 12 server and install Kerberos client on it at build-time, 
then try to retrieve its HTTP service credential from the Kerberos server at the first run. 

# Quick start

```bash
docker run --network=overlay \
  -v ${YOUR_NODEJS_PROJECT_FOLDER}:/usr/src/app \
  -v ${YOUR_KRB5_CONFIG}:/etc/krb5.conf
  -p 127.0.0.1:3000:3000 \
  --network ${NET_WITH_KERBEROS_SERVER} \
  nugaon/nodejs-with-kerberos 
```

You should set the variables according to your environment.
- For `YOUR_KRB5_CONFIG` there is an example in [utils/krb5-client.example.conf](utils/krb5-client.example.conf). Feel free to change it.
- For `YOUR_NODEJS_PROJECT_FOLDER` you should set the path of your nodejs project, where usually placed the package.json file, e.g. '/home/user/nodeproject'
- For `NET_WITH_KERBEROS_SERVER` pass the overlay network's name which on the Kerberos server is also connected.

Useful environment variables:

| Environment variables    | Description                                                 | Default value            |
| ------------------------ | ----------------------------------------------------------- | ------------------------ |
| `KERB_HTTP_SERVICE_NAME` | The Kerberos HTTP service principal name                    | localhost                |
| `KERB_ADMIN_USER`        | administrator account name                                  | admin                    |
| `KERB_ADMIN_PASS`        | administrator's password                                    | admin                    |
| `START_COMMAND`          | Run at the end of the startup script                        | npm run start            |
| `KERB_ADMIN_ADDRESS`     | Kerberos address to check connection e.g. kerberos:749      | null                     |


# Test NodeJS EPs from your computer

First of all, your browser has to be capable of use of Kerberos authentication. To set this properly [read cloudera's article about it.](https://docs.cloudera.com/documentation/enterprise/latest/topics/cdh_sg_browser_access_kerberos_protected_url.html)

Install krb5 client with the proper configuration according to your Kerberos environment, you can login with Kerberos users' credentials.
On linux systems it seems somehow like this:

> kinit eteszt

and pass the eteszt user's password into the prompt. You can check was it either successful or not with

```bash
$ klist
# Ticket cache: FILE:/tmp/krb5cc_1000
# Default principal: eteszt@EXAMPLE.COM
# (...)
```

If you successfully reach this point you can make actions against the server in the name of `eteszt` user in your browser.