# rpmbuilds
project for build common service:



### userage:
1. Appliction service directory structure 
>
└─opt
  ├─apps
     └─demo
         ├─config
         |    config
         ├─lib
         |    app
         └─logs
2. enable service:
```
systemctl enable --now apps@demo
```