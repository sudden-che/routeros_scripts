# ca info
:global country ""
:global state ""
:global loc ""
:global org ""
:global unit "DEMO"
:global keysize 4096
:global crlhost 127.0.0.1
# server info
:global caname "ovpn-ca"
:global servercn "ovpn-serv"
# days valid
:global days 7300 

# server openvpn port
:global openvpn_port 12345
# client how much certificates 
:global from 1
#	max count
:global fromto 3
#	ppp service name
:global service "ovpn"
#	ppp ovpn profile name
:global profile "ovpn"
# new pwd mask
:global pwdmask ""

:global cliname "cli"

# create ca
/certificate add name=ca country=$country state=$state locality=$loc organization=$org unit=$unit common-name="" key-size=$keysize days-valid=$days key-usage=crl-sign,key-cert-sign; 
# create sign
/certificate sign ca ca-crl-host=$crlhost name=$caname
# create serv
/certificate add name=$servercn country=$country state=$state locality=$loc organization=$org unit=$unit  common-name=$servercn key-size=$keysize days-valid=$days key-usage=digital-signature,key-encipherment,tls-server;
# sign serv
/certificate sign $servercn ca=$caname name=$servercn

# mikrotik create ovpn-clis
/ppp profile add name=ovpn

# create client certs
:for i from=$from to=$fromto do={/certificate add country=$country state=$state locality=$loc organization=$org unit=$unit name=($cliname.$i) common-name=($cliname.$i) key-size=$keysize days-valid=$days key-usage=tls-client;}

# sign client certs
:for i from=$from to=$fromto do={/certificate sign ca=$caname ($cliname.$i);}

# add ppp secrets
:for i from=$from to=$fromto do={/ppp secret add name=($cliname.$i) service=$service profile=$profile password=($pwdmask.$i);}

# export to p12
:for i from=$from to=$fromto do={/certificate export-certificate type=pkcs12 ($cliname.$i) file-name=($cliname.$i) export-passphrase=($pwdmask.$i);}


# in bash
# crt export
#openssl pkcs12 -in path_to_your_p12_file -nokeys -out cert.crt -passin pass:#yourpass
# private key export
#openssl pkcs12 -in path_to_your_p12_file -nocerts -out cert.key -passin pass:#yourpass

# enable interface
:global openvpnport 18000
# может не примениться, лучше проверить и применить руками 
/interface ovpn-server server
set enabled=yes
set port=$openvpnport
set cipher=aes192,aes256
set require-client-certificate=yes
set certificate=$servercn
set default-profile=ovpn

