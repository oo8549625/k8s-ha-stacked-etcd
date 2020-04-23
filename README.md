# 架設k8s + keepalived + haproxy

## ServerIP
| Server  | IP  |
| :------------ |:---------------:|
| master1 | 192.168.210.5 |
| master2 | 192.168.210.24 |
| master3 | 192.168.210.12 |
| VIP | 192.168.210.20 |
| node1 | 192.168.210.3 |
| node2 | 192.168.210.10 |
| node3 | 192.168.210.17 |

## 安裝, 配置及測試 keepalived
```
#三台master都需要安裝keepalived
以下配置須修改(其餘一樣)
master1 state MASTER  priority 11 unicast_src_ip 192.168.210.5 unicast_peer {192.168.210.24 192.168.210.12}
master2 state BACKUP  priority 10 unicast_src_ip 192.168.210.24 unicast_peer {192.168.210.5 192.168.210.12}
master3 state BACKUP  priority 10 unicast_src_ip 192.168.210.12 unicast_peer {192.168.210.5 192.168.210.24}

#keepalived installation
sudo apt-get install -y keepalived

#開機執行
sudo systemctl enable keepalived

#配置文件
sudo nano /etc/keepalived/keepalived.conf

#刪除文件
sudo rm -rf /etc/keepalived/keepalived.conf

#重起｜狀態｜停止｜開始
sudo systemctl restart keepalived
sudo systemctl status keepalived
sudo systemctl stop keepalived
sudo systemctl start keepalived

# ip地址
sudo ip address

#測試
若是該master的STATE=MASTER, 查看ip地址會多出一個VIP, 此例子(192.168.210.20)
重開master1的keepalived之後, 看master1的keepalived狀態從MASTER-->BACKUP, priority高於master2但是不會搶佔
查看master2的keepalived狀態從BACKUP-->MASTER
接著, 重開master2的keepalived, master1回到MASTER STATE, master2 回到BACKUP STATE
```

## 安裝, 配置及測試 haproxy
