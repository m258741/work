PW='!:4*nqGrMJ)MWPKTj1%wyG:H^x;;aO)Zxe6yJgzwv3Udt0t+9Aqo}=EY$rtOZo}*y5D{A4*O1f}'
USER='codeshuttle.user'

curl "https://maximusdev.service-now.com/api/sn_chg_rest/v1/change?sysparm_query=active=true^ORDERBYnumber" \
--request GET \
--header "Accept:application/json" \
--user 'codeshuttle.user':'!:4*nqGrMJ)MWPKTj1%wyG:H^x;;aO)Zxe6yJgzwv3Udt0t+9Aqo}=EY$rtOZo}*y5D{A4*O1f}'

### save/orig:
#curl "https://maximusincnonprod23.service-now.com/api/sn_chg_rest/v1/change?sysparm_query=active=true^ORDERBYnumber" \
#--request GET \
#--header "Accept:application/json" \
#--user 'snow_api':'kDas-@pIobg]N4;j{>BXTB!GF}wuRVl,?w?_i<YUGkDV_UdK&ANNc{#0-9L*Ykky-gZ+zQg5WTpC*P;&4p-n:+eh0w[n0gn%1PY3'
