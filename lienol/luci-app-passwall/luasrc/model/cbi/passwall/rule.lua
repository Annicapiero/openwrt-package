local e = require"nixio.fs"
local e = require"luci.sys"
--local t = luci.sys.exec("cat /usr/share/passwall/dnsmasq.d/gfwlist.conf|grep -c ipset")

m=Map("passwall")
-- [[ Rule Settings ]]--
s=m:section(TypedSection,"global_rules",translate("Rule status"))
s.anonymous=true
s:append(Template("passwall/rule_version"))

o=s:option(Flag,"auto_update",translate("Enable auto update rules"))
o.default=0
o.rmempty=false

o=s:option(ListValue,"week_update",translate("Week update rules"))
o:value(7,translate("Every day"))
for e=1,6 do
o:value(e,translate("Week")..e)
end
o:value(0,translate("Week")..translate("day"))
o.default=0
o:depends("auto_update",1)

o=s:option(ListValue,"time_update",translate("Day update rules"))
for e=0,23 do
o:value(e,e..translate("oclock"))
end
o.default=0
o:depends("auto_update",1)

-- [[ V2ray Settings ]]--
s=m:section(TypedSection,"global",translate("V2ray Update"))
s.anonymous=true
s:append(Template("passwall/v2ray"))

-- [[ Kcptun Settings ]]--
s=m:section(TypedSection,"global_kcptun",translate("Kcptun Update"))
s.anonymous=true
s:append(Template("passwall/kcptun"))
o=s:option(Value,"kcptun_client_file",translate("Kcptun client path"))
o.default="/usr/bin/kcptun_client"
o.rmempty=false
--[[
o = s:option(Button, "_check_kcptun", translate("Manually update"),
	translate("Make sure there is enough space to install Kcptun"))
o.template = "passwall/kcptun"
o.inputstyle = "apply"
o.btnclick = "onBtnClick_kcptun(this);"
o.id = "_kcptun-check_btn"]]--

-- [[ Subscribe Settings ]]--
s=m:section(TypedSection,"global_subscribe",translate("Server Subscribe"))
s.anonymous=true

o=s:option(DynamicList,"baseurl_ssr",translate("SSR Subscribe URL"),translate("Servers unsubscribed will be deleted in next update; Please summit the Subscribe URL first before manually update."))
o=s:option(DynamicList,"baseurl_v2ray",translate("V2ray Subscribe URL"),translate("Servers unsubscribed will be deleted in next update; Please summit the Subscribe URL first before manually update."))

o=s:option(Button,"_update",translate("Manually update"))
o.inputstyle="apply"
function o.write(e,e)
luci.sys.call("/usr/share/passwall/subscription.sh")
luci.http.redirect(luci.dispatcher.build_url("admin","vpn","passwall","log"))
end
o=s:option(Button,"_stop",translate("Delete All Subscribe"))
o.inputstyle="remove"
function o.write(e,e)
luci.sys.call("/usr/share/passwall/subscription.sh stop")
luci.http.redirect(luci.dispatcher.build_url("admin","vpn","passwall","log"))
end

o=s:option(Flag,"subscribe_by_ss",translate("Subscribe via proxy"))
o.default=0
o.rmempty=false

o=s:option(Flag,"auto_update_subscribe",translate("Enable auto update subscribe"))
o.default=0
o.rmempty=false

o=s:option(ListValue,"week_update_subscribe",translate("Week update rules"))
o:value(7,translate("Every day"))
for e=1,6 do
o:value(e,translate("Week")..e)
end
o:value(0,translate("Week")..translate("day"))
o.default=0
o:depends("auto_update_subscribe",1)

o=s:option(ListValue,"time_update_subscribe",translate("Day update rules"))
for e=0,23 do
o:value(e,e..translate("oclock"))
end
o.default=0
o:depends("auto_update_subscribe",1)

return m
