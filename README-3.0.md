# win-socks-to-Virtual-adapter3.0
<h3>帮助你将socks代理转到一张虚拟网卡上，所有经过虚拟网卡的流量会被发送到代理for windows </h3>
<p>感谢badvpn，windows tap项目  <br>
<h4>原理简介</h4>
<p>udp需要服务端支持<br>
将tcp转发至虚拟网卡转发至socks，udp通过tcp方式转发到socks然后在服务端转换为udp发送出去</p>
<h3>注意事项</h3>
适用于IPV6服务端，服务端为ipv4需自行修改route<br>
获取适配器名称和IP的方法是通过ipv6 ip来确定的<br>
进程绑定现在是绑定的shadowsocksr<br>
启用udp需要在服务器上进行端口监听（tested on debian）</p>
<h3>安装</h3>
<p>pc 将windowsclient文件夹里的内容拷到shadowsocksr目录下<br>
在linux服务器端，通过winscp将linuxserver/badvpn-udpgw文件拷入  编译自https://github.com/ambrop72/badvpn<br>
<h4>服务端如果要用udp并实现后台监听</h4>
将 udpgw.service 复制到/etc/systemd/system/下<br>
<code>systemctl daemon-reload</code><br>
开机自启则 <code>systemctl enable udpgw.service</code></p>
<h3>运行</h3>
<p>linux 服务端<code>systemctl start udpgw.service</code> <br>
windows客户端右键管理员运行 开始上网3.0.bat</p>
<h3>more</h3>
<p><code>set protect=1</code>1为开启保护（自动修复route）适合网络变动大的情况<br>
<code>set protectping=1</code>1为开启v6 ping检测，自动重获ipv6 地址 <br>
<code>set pro_dalay=20</code> 为保护检测隔多少时间一次<br>
<code>set pro_hide=1</code>保护检测是否隐藏执行<br></p>
<p>因为防止dns污染，服务端解析dns，所以内网网站需要用hosts来访问，提供了一个host生成脚本</p>
<h4>用法</h4>
<p>复制导航页的源文件代码到source.txt（导航部分就行）,修改findhost.bat里的dns服务器为内网dns服务器(可能还有内网ip范围默认10.)，运行脚本，生成result.txt，人工大概检查一下，运行修改host使用内网网站.bat,想恢复时点击还原hosts即可。</p>
<h4>更新日志：</h4>
<p>3.0第一个版本<br>
增加参数调整
增加自动提权
</p>
