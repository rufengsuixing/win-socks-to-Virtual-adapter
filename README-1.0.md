# win-socks-to-Virtual-adapter
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
windows客户端右键管理员运行 开始上网1.0.bat</p>
<h3>more</h3>
<p>因为防止dns污染，服务端解析dns，所以内网网站需要用hosts来访问，提供了一个host生成脚本</p>
<h4>用法</h4>
复制导航页的源文件代码到source.txt（导航部分就行）,修改findhost.bat里的dns服务器为内网dns服务器(可能还有内网ip范围默认10.)，运行脚本，生成result.txt，人工大概检查一下，运行修改host使用内网网站.bat,想恢复时点击还原hosts即可。
<p>更新日志：<br>
change the way to get gateway<br>
change the way to set gateway to default<br>
一个代码错误<br>
增加无ipv4的时候无脚本延时导致启动失败的问题<br>
增加轻度修复网络在未连校园网时的修复效果<br>
如果没有ipv6会无数次重试获取ipv6<br>
增加备份和恢复网络配置（需要重启）<br>
降低日志数量，只显示错误<br>
增加dns修复，route修复<br>
修复内网网站访问（部分）<br>
修改更改route的方式，增强兼容性<br>
增强轻度修复网络<br>
主适配器名称获取错误<br>
修改获取route的方式<br>
增加守护脚本和自动修复网络<br>
修复驱动引导流程<br>
修改引导用户安装驱动<br>
route 接口错误<br>
无网络连接闪退<br>
网络接口获取增加检测，防止route更改失败<br>
增加非正常关闭此程序的检测（没卵用）<br>
有ipv6地址无法上网时自动重获ipv6<br>
无ipv4也增加守护脚本<br>
修改主适配器名称获取方式为ipv6<br>
不再强制关闭已有进程<br>
自检测防止重复运行<br>
延时调整，细节调整<br>
启动时刷新dns缓存<br>
新增修改hosts使用校内网站<br>
小bug fix
版本大改，服务端需重新配置
</p>
