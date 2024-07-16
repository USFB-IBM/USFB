#!/bin/bash

builddir=$1
# in case of outbound, you need to pass "client_impl", while in case of in bound, it should be just empty like ""
clParentFolder=""
if [ ! "$2" == "." ]; then
    clParentFolder="/$2"
fi

clientdir=$3

echo "Usage : deploy-apis.sh builddir client_parenet_folder clientdir"
echo "builddir: ${builddir}, parent folder: ${clParentFolder}, Client Dir: ${clientdir}"

basefolder="${builddir}${clParentFolder}"
echo "base folder is $basefolder"

if [ ! -d "$basefolder/$clientdir" ]; then
	exit
fi

if [ -d "$basefolder/target/apis" ]; then
    cd target
    rm -Rf apis
    cd ..
fi



#prop_location=($builddir/client_impl/$clientdir/devops/apic-deployment)
prop_location="$basefolder/${clientdir}/devops/apic-deployment"

echo $prop_location
readarray -t props_arr <<< $(ls "$prop_location")
mkdir -p target/apis
for f in "${props_arr[@]}"; 
do
   if [[ $f =~ -${env_to_deploy}\.yaml ]]; then 
	   echo "$f"
	   cp -r $prop_location/$f target/apis
   fi
done


######################################################################
#if [[ $(echo $alm_level) == "Release" ]];
#then
  apic_catalog=""
  if [[ $env_to_deploy == "sit" ]]
  then
    apic_catalog="sit"
  elif [[ $env_to_deploy == "uat" ]]
  then
    apic_catalog="uat"
  else
    apic_catalog="ace"
  fi
#fi
#######################################################################

apic login --accept-license -s "$apic_server_name" -r "$apic_realm" -u "$apic_username" -p "$apic_password"
cdir="$(pwd)"
cd target/apis
readarray -t prop_arr <<< $(ls )
for yamlfile in "${prop_arr[@]}"; 
do
   echo "APIs to deploy: the file name is $yamlfile"
   echo "Catalogue name is $apic_catalog"
   apic draft-apis:create --accept-license "$yamlfile" --server "$apic_server_name" --org "$apic_org_name"
   product=$(echo $yamlfile | tr '[:upper:]' '[:lower:]' | tr -d '.')
   #fileNameMinusYamlextension=${yamlfile%.*}   
   #product=$(echo $fileNameMinusYamlextension | tr '[:upper:]' '[:lower:]' ) 
   
   echo "Product name is $product"
   rm -rf "$product".yaml
   apic create:product --accept-license --title "$product" --apis "$yamlfile"
   apic draft-products:create --accept-license "$product".yaml --server "$apic_server_name" --org "$apic_org_name"
   echo "apic products publish $product.yaml -c $apic_catalog --server $apic_server_name --org $apic_org_name"
   task_log=$(apic products publish --accept-license "$product".yaml -c "$apic_catalog" --server "$apic_server_name" --org "$apic_org_name" )
   echo "$task_log :: Intimation deployment flow"
done
ls | grep "yamlyaml".yaml | xargs rm -rf
cd ${cdir}
