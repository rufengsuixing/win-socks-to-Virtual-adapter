# win-socks-to-Virtual-adapter
<h3>帮助你将socks代理转到一张虚拟网卡上，所有经过虚拟网卡的流量会被发送到代理for windows （tested on win10）</h3>
<p>感谢badvpn，windows tap项目  <br>
适用于IPV6服务端，服务端为ipv4需自行修改route<br>
获取适配器名称和IP的方法是通过搜索10.为开头的ip来确定的<br>
进程绑定现在是绑定的shadowsocksr<br>
通过用户自定义服务器地址列表然后脚本读取ssr的配置文件实现多配置切换 for udp need restart<br>
启用udp需要在服务器上进行端口监听（tested on debian）</b>
<h3>安装</h3>
<p>pc 将windowsclient文件夹里的内容拷到shadowsocksr目录下<br>
修改start.bat 手动写入服务器地址列表(要求是ipv4地址)<br><br>
在linux服务器端，通过winscp将linuxserver/badvpn-udpgw文件拷入  编译自https://github.com/ambrop72/badvpn<br>
<h4>服务端如果要实现后台监听</h4>
修改 udpgw.service 里面的badvpn-udpgw 位置和服务器ipv4<br>
将 udpgw.service 复制到/etc/systemd/system/下<br>
<code>systemctl daemon-reload</code><br>
开机自启则 <code>systemctl enable udpgw.service</code></p>
<h3>运行</h3>
<p>
linux 服务端<code>systemctl start udpgw.service</code> 或者 badvpn-udpgw --listen-addr [服务器ipv4]:7300<br>
windows客户端右键管理员运行start.bat</p>
