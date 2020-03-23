Docker NFS Server
================

Usage
----
```bash
docker run -d --name nfs --privileged cpuguy83/nfs-server /path/to/share /path/to/share2 /path/to/shareN
```

Shared paths must be in `/polyaxon` directory, otherwise they will not be exhibited via NFS. This seems to be somehow related to VOLUME mounts.

```bash
docker run -d --name nfs-client --privileged --link nfs:nfs cpuguy83/nfs-client /path/on/nfs/server:/path/on/client
``` 

More Info
=========

See https://container42.com/2014/03/29/docker-quicktip-4-remote-volumes/
