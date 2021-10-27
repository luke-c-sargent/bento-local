# MOVED TO FRONTEND DOCKERFILE
#apt-get update && apt-get install -y python3 python3-pip git

#echo "cloning dataloader code" \
# && git clone --single-branch --branch master --recurse-submodules -j8 https://github.com/CBIIT/icdc-dataloader.git /usr/local/icdc_dataloader \
# && cd /usr/local/icdc_dataloader \
# && pip3 install -r requirements.txt

# copy indices file from backend
cp /tmp/es_indices_bento.yml /usr/local/icdc_dataloader/config/es_indices_bento.yml

# update the neo4j credentials in the dataloader config file
cp /usr/local/icdc_dataloader/config/es_loader.yml.j2 /usr/local/icdc_dataloader/config/es_loader_local.yml \
 && sed -i "s/\"{{ neo4j_password }}\"/$NEO4J_PASS/g" /usr/local/icdc_dataloader/config/es_loader_local.yml \
 && sed -i "s/{{neo4j_ip}}/$NEO4J_HOST/g" /usr/local/icdc_dataloader/config/es_loader_local.yml \
 && sed -i "s/{{ es_host }}/$ES_HOST/g" /usr/local/icdc_dataloader/config/es_loader_local.yml

echo "loading data from neo4j" \
 && cat /usr/local/icdc_dataloader/config/es_loader_local.yml \
 && cd /usr/local/icdc_dataloader \
 && python3 es_loader.py config/es_indices_bento.yml config/es_loader_local.yml