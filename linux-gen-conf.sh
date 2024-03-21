
#	bash config create from template
#	ENV

CONF_NAME="ovrag-vpn"

for i in {6..13}; do
mkdir $CONF_NAME-cli$i
cat > $CONF_NAME-cli$i/$CONF_NAME-cli$i.ovpn<<EOF
dev tun
persist-tun
persist-key
resolv-retry infinite
remote 217.21.214.197 1199 tcp
cipher AES-256-CBC
tls-client
client
remote-cert-tls server
auth-user-pass # auth.txt
keepalive 10 180
verb 3

key-direction 1
<ca>
</ca>


pkcs12 ovpn-cli$i.p12

#	 routes
#route 10.1.1.0 255.255.255.0 
#route 10.1.2.0 255.255.255.0 
EOF

#	generate auth file
cat > $CONF_NAME-cli$i/auth.txt<<EOF
ovpn-cli$i
cynerp@zzvv0rd$i
EOF
done




#	mv p12 to folders
for i in {6..13}; do mv *$i*p12 *$i; done


